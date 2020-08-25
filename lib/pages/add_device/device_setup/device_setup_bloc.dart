/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceSetupBlocEvent extends Equatable {}

class DeviceSetupBlocEventStartSetup extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocEventProgress extends DeviceSetupBlocEvent {
  final double percent;
  DeviceSetupBlocEventProgress(this.percent);

  @override
  List<Object> get props => [percent];
}

class DeviceSetupBlocEventLoadingError extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocEventAlreadyExists extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocEventDone extends DeviceSetupBlocEvent {
  final Device device;
  final bool requiresInititalSetup;
  final bool requiresWifiSetup;

  DeviceSetupBlocEventDone(
      this.device, this.requiresInititalSetup, this.requiresWifiSetup);

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
  DeviceSetupBlocStateLoadingError() : super(0);
}

class DeviceSetupBlocStateDone extends DeviceSetupBlocState {
  final Device device;
  final bool requiresInititalSetup;
  final bool requiresWifiSetup;

  DeviceSetupBlocStateDone(
      this.device, this.requiresInititalSetup, this.requiresWifiSetup)
      : super(1);

  @override
  List<Object> get props => [device];
}

class DeviceSetupBloc extends Bloc<DeviceSetupBlocEvent, DeviceSetupBlocState> {
  final MainNavigateToDeviceSetupEvent args;

  DeviceSetupBloc(this.args) : super(DeviceSetupBlocState(0)) {
    Future.delayed(const Duration(seconds: 1),
        () => this.add(DeviceSetupBlocEventStartSetup()));
  }

  @override
  Stream<DeviceSetupBlocState> mapEventToState(
      DeviceSetupBlocEvent event) async* {
    if (event is DeviceSetupBlocEventStartSetup) {
      this._startSearch(event);
    } else if (event is DeviceSetupBlocEventProgress) {
      yield DeviceSetupBlocState(event.percent);
    } else if (event is DeviceSetupBlocEventLoadingError) {
      yield DeviceSetupBlocStateLoadingError();
    } else if (event is DeviceSetupBlocEventAlreadyExists) {
      yield DeviceSetupBlocStateAlreadyExists();
    } else if (event is DeviceSetupBlocEventDone) {
      yield DeviceSetupBlocStateDone(
          event.device, event.requiresInititalSetup, event.requiresWifiSetup);
    }
  }

  void _startSearch(DeviceSetupBlocEventStartSetup event) async {
    try {
      final db = RelDB.get().devicesDAO;
      String deviceIdentifier;

      try {
        deviceIdentifier =
            await DeviceAPI.fetchStringParam(args.ip, "BROKER_CLIENTID");
      } catch (e) {
        add(DeviceSetupBlocEventLoadingError());
        return;
      }

      try {
        if (await db.getDeviceByIdentifier(deviceIdentifier) != null) {
          add(DeviceSetupBlocEventAlreadyExists());
          return;
        }
      } catch (e) {
        add(DeviceSetupBlocEventAlreadyExists());
        return;
      }

      int deviceID;

      try {
        final deviceName =
            await DeviceAPI.fetchStringParam(args.ip, "DEVICE_NAME");
        final mdnsDomain =
            await DeviceAPI.fetchStringParam(args.ip, "MDNS_DOMAIN");

        final device = DevicesCompanion.insert(
            identifier: deviceIdentifier,
            name: deviceName,
            ip: args.ip,
            mdns: mdnsDomain);
        deviceID = await db.addDevice(device);
      } catch (e) {
        add(DeviceSetupBlocEventLoadingError());
        return;
      }

      try {
        await DeviceAPI.fetchAllParams(args.ip, deviceID, (adv) {
          add(DeviceSetupBlocEventProgress(adv));
        });
      } catch (e) {
        Logger.log(e);
        add(DeviceSetupBlocEventLoadingError());
      }

      final d = await db.getDevice(deviceID);

      final Param time = await db.getParam(deviceID, 'TIME');
      await DeviceHelper.updateIntParam(
          d, time, DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);

      final Param state = await db.getParam(deviceID, 'STATE');

      // Just got his device, set schedule to local timezone
      if (state.ivalue == 0) {
        final Module boxes = await db.getModule(deviceID, 'box');
        for (int i = 0; i < boxes.arrayLen; ++i) {
          final Param onHour = await db.getParam(deviceID, 'BOX_${i}_ON_HOUR');
          final Param offHour =
              await db.getParam(deviceID, 'BOX_${i}_OFF_HOUR');

          await DeviceHelper.updateHourParam(d, onHour, onHour.ivalue);
          await DeviceHelper.updateHourParam(d, offHour, offHour.ivalue);
        }
      }

      final Param wifi = await db.getParam(deviceID, 'WIFI_STATUS');
      add(DeviceSetupBlocEventDone(d, state.ivalue == 0, wifi.ivalue != 3));
    } catch (e) {
      add(DeviceSetupBlocEventLoadingError());
    }
  }
}
