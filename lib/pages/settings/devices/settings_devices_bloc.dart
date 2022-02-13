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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsDevicesBlocEvent extends Equatable {}

class SettingsDevicesBlocEventInit extends SettingsDevicesBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDevicesblocEventBoxListChanged extends SettingsDevicesBlocEvent {
  final List<Device> devices;

  SettingsDevicesblocEventBoxListChanged(this.devices);

  @override
  List<Object> get props => [devices];
}

class SettingsDevicesBlocEventDeleteDevice extends SettingsDevicesBlocEvent {
  final Device device;

  SettingsDevicesBlocEventDeleteDevice(this.device);

  @override
  List<Object> get props => [device];
}

abstract class SettingsDevicesBlocState extends Equatable {}

class SettingsDevicesBlocStateInit extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateLoading extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateNotEmptyBox extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateLoaded extends SettingsDevicesBlocState {
  final List<Device> devices;

  SettingsDevicesBlocStateLoaded(this.devices);

  @override
  List<Object> get props => [devices];
}

class SettingsDevicesBloc extends LegacyBloc<SettingsDevicesBlocEvent, SettingsDevicesBlocState> {
  late List<Device> devices;
  StreamSubscription<List<Device>>? _devicesStream;

  //ignore: unused_field
  final MainNavigateToSettingsDevices args;

  SettingsDevicesBloc(this.args) : super(SettingsDevicesBlocStateInit()) {
    add(SettingsDevicesBlocEventInit());
  }

  @override
  Stream<SettingsDevicesBlocState> mapEventToState(event) async* {
    if (event is SettingsDevicesBlocEventInit) {
      yield SettingsDevicesBlocStateLoading();
      _devicesStream = RelDB.get().devicesDAO.watchDevices().listen(_onDeviceListChange);
    } else if (event is SettingsDevicesblocEventBoxListChanged) {
      yield SettingsDevicesBlocStateLoaded(event.devices);
    } else if (event is SettingsDevicesBlocEventDeleteDevice) {
      await RelDB.get().plantsDAO.cleanDeviceIDs(event.device.id);
      await DeviceHelper.deleteDevice(event.device);
    }
  }

  void _onDeviceListChange(List<Device> d) {
    devices = d;
    add(SettingsDevicesblocEventBoxListChanged(devices));
  }

  @override
  Future<void> close() async {
    await _devicesStream?.cancel();
    return super.close();
  }
}
