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

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

class DeviceWifiBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DeviceWifiBlocEventSetup extends DeviceWifiBlocEvent {
  final String ssid;
  final String pass;

  DeviceWifiBlocEventSetup(this.ssid, this.pass);

  @override
  List<Object> get props => [ssid, pass];
}

class DeviceWifiBlocEventRetrySearch extends DeviceWifiBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  DeviceWifiBlocEventRetrySearch();

  @override
  List<Object> get props => [rand];
}

class DeviceWifiBlocEventRetypeCredentials extends DeviceWifiBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  DeviceWifiBlocEventRetypeCredentials();

  @override
  List<Object> get props => [rand];
}

class DeviceWifiBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class DeviceWifiBlocStateLoading extends DeviceWifiBlocState {
  @override
  List<Object> get props => [];
}

class DeviceWifiBlocStateSearching extends DeviceWifiBlocState {
  @override
  List<Object> get props => [];
}

class DeviceWifiBlocStateNotFound extends DeviceWifiBlocState {
  @override
  List<Object> get props => [];
}

class DeviceWifiBlocStateDone extends DeviceWifiBlocState {
  final Device device;

  DeviceWifiBlocStateDone(this.device);

  @override
  List<Object> get props => [];
}

class DeviceWifiBloc extends Bloc<DeviceWifiBlocEvent, DeviceWifiBlocState> {
  final MainNavigateToDeviceWifiEvent args;

  DeviceWifiBloc(this.args);

  @override
  DeviceWifiBlocState get initialState => DeviceWifiBlocState();

  @override
  Stream<DeviceWifiBlocState> mapEventToState(
      DeviceWifiBlocEvent event) async* {
    if (event is DeviceWifiBlocEventSetup) {
      yield DeviceWifiBlocStateLoading();
      var ddb = RelDB.get().devicesDAO;
      Param ssid = await ddb.getParam(args.device.id, 'WIFI_SSID');
      await DeviceHelper.updateStringParam(args.device, ssid, event.ssid);
      try {
        Param pass = await ddb.getParam(args.device.id, 'WIFI_PASSWORD');
        await DeviceHelper.updateStringParam(args.device, pass, event.pass,
            timeout: 5, nRetries: 1);
      } catch (e) {
        print(e);
      }
      yield* _researchDevice();
    } else if (event is DeviceWifiBlocEventRetrySearch) {
      yield* _researchDevice();
    } else if (event is DeviceWifiBlocEventRetypeCredentials) {
      yield DeviceWifiBlocState();
    }
  }

  Stream<DeviceWifiBlocState> _researchDevice() async* {
    var ddb = RelDB.get().devicesDAO;
    Device device = await ddb.getDevice(args.device.id);

    yield DeviceWifiBlocStateSearching();
    await RelDB.get().devicesDAO.updateDevice(
        DevicesCompanion(id: Value(device.id), isReachable: Value(false)));

    String ip;
    for (int i = 0; i < 4; ++i) {
      await new Future.delayed(const Duration(seconds: 2));
      ip = await DeviceAPI.resolveLocalName(device.mdns);
      if (ip == "" || ip == null) {
        continue;
      }
      break;
    }

    if (ip == "" || ip == null) {
      yield DeviceWifiBlocStateNotFound();
      return;
    }

    await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(
        id: Value(device.id), ip: Value(ip), isReachable: Value(true)));
    device = await RelDB.get().devicesDAO.getDevice(device.id);

    Param ipParam = await ddb.getParam(device.id, 'WIFI_IP');
    await ddb.updateParam(ipParam.copyWith(svalue: ip));

    Param wifiStatusParam = await ddb.getParam(device.id, 'WIFI_STATUS');
    await DeviceHelper.refreshIntParam(device, wifiStatusParam);

    if (wifiStatusParam.ivalue != 3) {
      yield DeviceWifiBlocStateNotFound();
      return;
    }

    yield DeviceWifiBlocStateDone(device);
  }
}
