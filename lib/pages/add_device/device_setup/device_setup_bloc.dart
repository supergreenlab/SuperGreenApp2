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
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceSetupBlocEvent extends Equatable {}

class DeviceSetupBlocEventStartSetup extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
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

  DeviceSetupBlocStateDone(this.device, this.requiresInititalSetup, this.requiresWifiSetup) : super(1);

  @override
  List<Object> get props => [device];
}

class DeviceSetupBloc extends Bloc<DeviceSetupBlocEvent, DeviceSetupBlocState> {
  final MainNavigateToDeviceSetupEvent _args;

  @override
  DeviceSetupBlocState get initialState => DeviceSetupBlocState(0);

  DeviceSetupBloc(this._args) {
    Future.delayed(const Duration(seconds: 1),
        () => this.add(DeviceSetupBlocEventStartSetup()));
  }

  @override
  Stream<DeviceSetupBlocState> mapEventToState(
      DeviceSetupBlocEvent event) async* {
    if (event is DeviceSetupBlocEventStartSetup) {
      yield* this._startSearch(event);
    }
  }

  Stream<DeviceSetupBlocState> _startSearch(
      DeviceSetupBlocEventStartSetup event) async* {
    try {
      final db = RelDB.get().devicesDAO;
      final deviceIdentifier =
          await DeviceAPI.fetchStringParam(_args.ip, "BROKER_CLIENTID");

      if (await db.getDeviceByIdentifier(deviceIdentifier) != null) {
        yield DeviceSetupBlocStateAlreadyExists();
        return;
      }

      final deviceName =
          await DeviceAPI.fetchStringParam(_args.ip, "DEVICE_NAME");
      final mdnsDomain =
          await DeviceAPI.fetchStringParam(_args.ip, "MDNS_DOMAIN");
      final config = await DeviceAPI.fetchConfig(_args.ip);
      final keys = json.decode(config);

      final device = DevicesCompanion.insert(
          identifier: deviceIdentifier,
          name: deviceName,
          config: config,
          ip: _args.ip,
          mdns: mdnsDomain);
      final deviceID = await db.addDevice(device);
      final Map<String, int> modules = Map();

      double total = keys['keys'].length.toDouble(), done = 0;
      for (Map<String, dynamic> k in keys['keys']) {
        var moduleName = k['module'];
        if (modules.containsKey(moduleName) == false) {
          bool isArray = k.containsKey('array');
          ModulesCompanion module = ModulesCompanion.insert(
              device: deviceID,
              name: moduleName,
              isArray: isArray,
              arrayLen: isArray ? k['array']['len'] : 0);
          final moduleID = await db.addModule(module);
          modules[moduleName] = moduleID;
        }
        int type = k['type'] == 'integer' ? INTEGER_TYPE : STRING_TYPE;
        ParamsCompanion param;
        if (type == INTEGER_TYPE) {
          final value = await DeviceAPI.fetchIntParam(_args.ip, k['caps_name']);
          param = ParamsCompanion.insert(
              device: deviceID,
              module: modules[moduleName],
              key: k['caps_name'],
              type: type,
              ivalue: Value(value));
        } else {
          final value =
              await DeviceAPI.fetchStringParam(_args.ip, k['caps_name']);
          param = ParamsCompanion.insert(
              device: deviceID,
              module: modules[moduleName],
              key: k['caps_name'],
              type: type,
              svalue: Value(value));
        }
        await db.addParam(param);
        ++done;
        yield DeviceSetupBlocState(done / total);
      }

      Param state = await db.getParam(deviceID, 'STATE');
      Param wifi = await db.getParam(deviceID, 'WIFI_STATUS');
      final d = await db.getDevice(deviceID);
      yield DeviceSetupBlocStateDone(d, state.ivalue == 0, wifi.ivalue != 3);
    } catch (e) {
      yield DeviceSetupBlocStateLoadingError();
    }
  }
}
