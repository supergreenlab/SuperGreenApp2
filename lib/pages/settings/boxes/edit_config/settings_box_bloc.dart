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
import 'package:super_green_app/data/api/backend/feeds/box_helper.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';

abstract class SettingsBoxBlocEvent extends Equatable {}

class SettingsBoxBlocEventInit extends SettingsBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsBoxBlocEventUpdate extends SettingsBoxBlocEvent {
  final String name;
  final Device? device;
  final int? deviceBox;
  final Device? screenDevice;

  SettingsBoxBlocEventUpdate(this.name, this.device, this.deviceBox, this.screenDevice);

  @override
  List<Object?> get props => [name, device, screenDevice];
}

abstract class SettingsBoxBlocState extends Equatable {}

class SettingsBoxBlocStateLoading extends SettingsBoxBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxBlocStateLoaded extends SettingsBoxBlocState {
  final Box box;
  final Device? device;
  final int? deviceBox;
  final Device? screenDevice;

  SettingsBoxBlocStateLoaded(this.box, this.device, this.deviceBox, this.screenDevice);

  @override
  List<Object?> get props => [box, device, deviceBox, screenDevice];
}

class SettingsBoxBlocStateDone extends SettingsBoxBlocState {
  final Box box;
  final Device? device;
  final int? deviceBox;
  final Device? screenDevice;

  SettingsBoxBlocStateDone(this.box, this.device, this.deviceBox, this.screenDevice);

  @override
  List<Object?> get props => [box, device, deviceBox];
}

class SettingsBoxBloc extends LegacyBloc<SettingsBoxBlocEvent, SettingsBoxBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsBox args;
  late Box box;
  Device? device;
  int? deviceBox;
  Device? screenDevice;

  SettingsBoxBloc(this.args) : super(SettingsBoxBlocStateLoading()) {
    add(SettingsBoxBlocEventInit());
  }

  @override
  Stream<SettingsBoxBlocState> mapEventToState(SettingsBoxBlocEvent event) async* {
    if (event is SettingsBoxBlocEventInit) {
      box = await RelDB.get().plantsDAO.getBox(args.box.id);
      if (box.device != null) {
        device = await RelDB.get().devicesDAO.getDevice(box.device!);
        deviceBox = box.deviceBox;
      }
      if (box.screenDevice != null) {
        screenDevice = await RelDB.get().devicesDAO.getDevice(box.screenDevice!);
      }
      yield SettingsBoxBlocStateLoaded(box, device, deviceBox, screenDevice);
    } else if (event is SettingsBoxBlocEventUpdate) {
      yield SettingsBoxBlocStateLoading();
      await BoxHelper.removeBoxDevice(box,
          removeDevice: event.device == null, removeScreenDevice: event.screenDevice == null);
      await BoxHelper.setBoxDevice(box,
          device: event.device, deviceBox: event.deviceBox, screenDevice: event.screenDevice);
      if (event.name != box.name) {
        await RelDB.get()
            .plantsDAO
            .updateBox(BoxesCompanion(id: Value(box.id), name: Value(event.name), synced: Value(false)));
      }
      yield SettingsBoxBlocStateDone(box, event.device, event.deviceBox, event.screenDevice);
    }
  }
}
