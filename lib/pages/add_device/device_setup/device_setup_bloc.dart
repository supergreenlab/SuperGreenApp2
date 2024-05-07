/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:convert';

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceSetupBlocEvent extends Equatable {}

class DeviceSetupBlocEventStartSetup extends DeviceSetupBlocEvent {
  final String? username;
  final String? password;

  DeviceSetupBlocEventStartSetup({this.username, this.password});

  @override
  List<Object?> get props => [username, password];
}

class DeviceSetupBlocEventProgress extends DeviceSetupBlocEvent {
  final double percent;
  DeviceSetupBlocEventProgress(this.percent);

  @override
  List<Object> get props => [percent];
}

class DeviceSetupBlocEventLoadingError extends DeviceSetupBlocEvent {
  final bool requiresAuth;

  DeviceSetupBlocEventLoadingError({this.requiresAuth = false});

  @override
  List<Object?> get props => [requiresAuth];
}

class DeviceSetupBlocEventAlreadyExists extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocEventDone extends DeviceSetupBlocEvent {
  final Device device;
  final bool requiresInititalSetup;
  final bool requiresWifiSetup;

  DeviceSetupBlocEventDone(this.device, this.requiresInititalSetup, this.requiresWifiSetup);

  @override
  List<Object> get props => [device];
}

class DeviceSetupBlocState extends Equatable {
  final double percent;

  DeviceSetupBlocState(this.percent);

  @override
  List<Object> get props => [percent];
}

class DeviceSetupBlocStateOutdated extends DeviceSetupBlocState {
  DeviceSetupBlocStateOutdated() : super(0);
}

class DeviceSetupBlocStateAlreadyExists extends DeviceSetupBlocState {
  DeviceSetupBlocStateAlreadyExists() : super(0);
}

class DeviceSetupBlocStateLoadingError extends DeviceSetupBlocState {
  final bool requiresAuth;

  DeviceSetupBlocStateLoadingError({this.requiresAuth = false}) : super(0);
}

class DeviceSetupBlocStateDone extends DeviceSetupBlocState {
  final Device device;
  final bool requiresInititalSetup;
  final bool requiresWifiSetup;

  DeviceSetupBlocStateDone(this.device, this.requiresInititalSetup, this.requiresWifiSetup) : super(1);

  @override
  List<Object> get props => [device];
}

class DeviceSetupBloc extends LegacyBloc<DeviceSetupBlocEvent, DeviceSetupBlocState> {
  final MainNavigateToDeviceSetupEvent args;

  DeviceSetupBloc(this.args) : super(DeviceSetupBlocState(0)) {
    Future.delayed(const Duration(seconds: 1), () => this.add(DeviceSetupBlocEventStartSetup()));
  }

  @override
  Stream<DeviceSetupBlocState> mapEventToState(DeviceSetupBlocEvent event) async* {
    if (event is DeviceSetupBlocEventStartSetup) {
      this._startSearch(event);
    } else if (event is DeviceSetupBlocEventProgress) {
      yield DeviceSetupBlocState(event.percent);
    } else if (event is DeviceSetupBlocEventLoadingError) {
      yield DeviceSetupBlocStateLoadingError(requiresAuth: event.requiresAuth);
    } else if (event is DeviceSetupBlocEventAlreadyExists) {
      yield DeviceSetupBlocStateAlreadyExists();
    } else if (event is DeviceSetupBlocEventDone) {
      yield DeviceSetupBlocStateDone(event.device, event.requiresInititalSetup, event.requiresWifiSetup);
    }
  }

  void _startSearch(DeviceSetupBlocEventStartSetup event) async {
    try {
      add(DeviceSetupBlocEventProgress(0));
      final db = RelDB.get().devicesDAO;
      String deviceIdentifier;
      String? auth;

      if (event.username != null && event.password != null) {
        auth = base64.encode(utf8.encode('${event.username}:${event.password}'));
      }

      try {
        deviceIdentifier = await DeviceAPI.fetchStringParam(args.ip, "BROKER_CLIENTID", auth: auth, nRetries: 10);
      } catch (e) {
        add(DeviceSetupBlocEventLoadingError(requiresAuth: e.toString().endsWith('401')));
        return;
      }

      try {
        await db.getDeviceByIdentifier(deviceIdentifier);
        add(DeviceSetupBlocEventAlreadyExists());
        return;
      } catch (e) {}

      AppDB().setDeviceAuth(deviceIdentifier, auth);

      int deviceID;

      try {
        final deviceName = await DeviceAPI.fetchStringParam(args.ip, "DEVICE_NAME", auth: auth);
        final mdnsDomain = await DeviceAPI.fetchStringParam(args.ip, "MDNS_DOMAIN", auth: auth);

        final DevicesCompanion device =
            DevicesCompanion.insert(identifier: deviceIdentifier, name: deviceName, ip: args.ip, mdns: mdnsDomain);
        deviceID = await db.addDevice(device);
      } catch (e) {
        add(DeviceSetupBlocEventLoadingError());
        return;
      }

      try {
        await DeviceAPI.fetchAllParams(args.ip, deviceID, (adv) {
          add(DeviceSetupBlocEventProgress(adv));
        }, auth: auth);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"ip": args.ip, "deviceID": deviceID});
        add(DeviceSetupBlocEventLoadingError());
      }

      Device d = await db.getDevice(deviceID);

      final Param time = await db.getParam(deviceID, 'TIME');
      await DeviceHelper.updateIntParam(d, time, DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);

      final Param state = await db.getParam(deviceID, 'STATE');

      // Just got his device
      if (state.ivalue == 0 && d.isController) {
        // set schedule to local timezone
        final Module boxes = await db.getModule(deviceID, 'box');
        for (int i = 0; i < boxes.arrayLen; ++i) {
          try {
            final Param onHour = await db.getParam(deviceID, 'BOX_${i}_ON_HOUR');
            final Param onMin = await db.getParam(deviceID, 'BOX_${i}_ON_MIN');
            await DeviceHelper.updateHourMinParams(d, onHour, onMin, onHour.ivalue!, onMin.ivalue!);

            final Param offHour = await db.getParam(deviceID, 'BOX_${i}_OFF_HOUR');
            final Param offMin = await db.getParam(deviceID, 'BOX_${i}_OFF_MIN');
            await DeviceHelper.updateHourMinParams(d, offHour, offMin, offHour.ivalue!, offMin.ivalue!);
          } catch (e, trace) {
            Logger.logError(e, trace, data: {"ip": args.ip, "deviceID": deviceID});
          }
        }

        // set motors MAX parameter
        try {
          final Module motors = await db.getModule(deviceID, 'motor');
          for (int i = 0; i < motors.arrayLen; ++i) {
            final Param max = await db.getParam(deviceID, 'MOTOR_${i}_MAX');
            await DeviceHelper.updateIntParam(d, max, 50);
          }
        } catch (e) {}
      }

      final Param wifi = await db.getParam(deviceID, 'WIFI_STATUS');
      add(DeviceSetupBlocEventDone(d, state.ivalue == 0, wifi.ivalue != 3));
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"ip": args.ip});
      add(DeviceSetupBlocEventLoadingError());
    }
  }
}
