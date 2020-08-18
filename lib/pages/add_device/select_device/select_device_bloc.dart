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
import 'package:super_green_app/data/helpers/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBlocEvent extends Equatable {}

class SelectDeviceBlocEventDelete extends SelectDeviceBlocEvent {
  final Device device;

  SelectDeviceBlocEventDelete(this.device);

  @override
  List<Object> get props => [device];
}

class SelectDeviceBlocEventLoadDevices extends SelectDeviceBlocEvent {
  SelectDeviceBlocEventLoadDevices() : super();

  @override
  List<Object> get props => [];
}

class SelectDeviceBlocEventDeviceListUpdated extends SelectDeviceBlocEvent {
  final List<Device> devices;

  SelectDeviceBlocEventDeviceListUpdated(this.devices) : super();

  @override
  List<Object> get props => [devices];
}

class SelectDeviceBlocEventSelect extends SelectDeviceBlocEvent {
  final Device device;
  final int deviceBox;

  SelectDeviceBlocEventSelect(this.device, this.deviceBox);

  @override
  List<Object> get props => [device];
}

class SelectDeviceBlocState extends Equatable {
  final List<Device> devices;

  SelectDeviceBlocState(this.devices);

  @override
  List<Object> get props => [devices];
}

class SelectDeviceBlocStateDeviceListUpdated extends SelectDeviceBlocState {
  SelectDeviceBlocStateDeviceListUpdated(List<Device> devices) : super(devices);
}

class SelectDeviceBlocStateDone extends SelectDeviceBlocState {
  final Device device;
  final int deviceBox;

  SelectDeviceBlocStateDone(List<Device> devices, this.device, this.deviceBox)
      : super(devices);

  @override
  List<Object> get props => [devices, device];
}

class SelectDeviceBloc
    extends Bloc<SelectDeviceBlocEvent, SelectDeviceBlocState> {
  List<Device> _devices = [];
  StreamSubscription<List<Device>> _stream;

  //ignore: unused_field
  final MainNavigateToSelectDeviceEvent args;

  SelectDeviceBloc(this.args) : super(SelectDeviceBlocState([])) {
    this.add(SelectDeviceBlocEventLoadDevices());
  }

  @override
  Stream<SelectDeviceBlocState> mapEventToState(
      SelectDeviceBlocEvent event) async* {
    if (event is SelectDeviceBlocEventLoadDevices) {
      final ddb = RelDB.get().devicesDAO;
      final watcher = ddb.watchDevices();
      _stream = watcher.listen(_onDeviceListChanged);
    } else if (event is SelectDeviceBlocEventDeviceListUpdated) {
      _devices = event.devices;
      yield SelectDeviceBlocStateDeviceListUpdated(_devices);
    } else if (event is SelectDeviceBlocEventDelete) {
      final ddb = RelDB.get().devicesDAO;
      await RelDB.get().plantsDAO.cleanDeviceIDs(event.device.id);
      await DeviceHelper.deleteDevice(event.device);
    } else if (event is SelectDeviceBlocEventSelect) {
      final ddb = RelDB.get().devicesDAO;
      final Device device = event.device;
      final stateParam = await ddb.getParam(device.id, 'STATE');
      // TODO declare Param enums when possible
      if (stateParam.ivalue != 2) {
        await DeviceHelper.updateIntParam(device, stateParam, 2);
      }
      yield SelectDeviceBlocStateDone(_devices, event.device, event.deviceBox);
    }
  }

  void _onDeviceListChanged(List<Device> devices) {
    add(SelectDeviceBlocEventDeviceListUpdated(devices));
  }

  @override
  Future<void> close() async {
    if (_stream != null) {
      await _stream.cancel();
    }
    return super.close();
  }
}
