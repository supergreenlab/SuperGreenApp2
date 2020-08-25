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
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceNameBlocEvent extends Equatable {}

class DeviceNameBlocEventReset extends DeviceNameBlocEvent {
  DeviceNameBlocEventReset();

  @override
  List<Object> get props => [];
}

class DeviceNameBlocEventSetName extends DeviceNameBlocEvent {
  final String name;
  DeviceNameBlocEventSetName(this.name);

  @override
  List<Object> get props => [name];
}

class DeviceNameBlocState extends Equatable {
  final Device device;
  DeviceNameBlocState(this.device);

  @override
  List<Object> get props => [device];
}

class DeviceNameBlocStateLoading extends DeviceNameBlocState {
  DeviceNameBlocStateLoading(Device device) : super(device);
}

class DeviceNameBlocStateDone extends DeviceNameBlocState {
  final bool requiresWifiSetup;

  DeviceNameBlocStateDone(Device device, this.requiresWifiSetup)
      : super(device);
}

class DeviceNameBloc extends Bloc<DeviceNameBlocEvent, DeviceNameBlocState> {
  final MainNavigateToDeviceNameEvent args;

  DeviceNameBloc(this.args) : super(DeviceNameBlocState(args.device));

  @override
  Stream<DeviceNameBlocState> mapEventToState(
      DeviceNameBlocEvent event) async* {
    if (event is DeviceNameBlocEventReset) {
      yield DeviceNameBlocState(args.device);
    } else if (event is DeviceNameBlocEventSetName) {
      yield DeviceNameBlocStateLoading(args.device);
      var ddb = RelDB.get().devicesDAO;
      await DeviceHelper.updateDeviceName(args.device, event.name);

      Param wifiStatus = await ddb.getParam(args.device.id, 'WIFI_STATUS');
      Device device = await ddb.getDevice(args.device.id);
      yield DeviceNameBlocStateDone(device, wifiStatus.ivalue != 3);
    }
  }
}
