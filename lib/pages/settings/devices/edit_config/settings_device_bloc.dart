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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsDeviceBlocEvent extends Equatable {}

class SettingsDeviceBlocEventInit extends SettingsDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDeviceBlocEventUpdate extends SettingsDeviceBlocEvent {
  final String name;

  SettingsDeviceBlocEventUpdate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class SettingsDeviceBlocState extends Equatable {}

class SettingsDeviceBlocStateLoading extends SettingsDeviceBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDeviceBlocStateLoaded extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateLoaded(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsDeviceBlocStateDone extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateDone(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsDeviceBloc extends LegacyBloc<SettingsDeviceBlocEvent, SettingsDeviceBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsDevice args;
  late Device device;

  SettingsDeviceBloc(this.args) : super(SettingsDeviceBlocStateLoading()) {
    add(SettingsDeviceBlocEventInit());
  }

  @override
  Stream<SettingsDeviceBlocState> mapEventToState(SettingsDeviceBlocEvent event) async* {
    if (event is SettingsDeviceBlocEventInit) {
      device = await RelDB.get().devicesDAO.getDevice(args.device.id);
      yield SettingsDeviceBlocStateLoaded(device);
    } else if (event is SettingsDeviceBlocEventUpdate) {
      yield SettingsDeviceBlocStateLoading();
      await DeviceHelper.updateDeviceName(args.device, event.name);
      yield SettingsDeviceBlocStateDone(device);
    }
  }
}
