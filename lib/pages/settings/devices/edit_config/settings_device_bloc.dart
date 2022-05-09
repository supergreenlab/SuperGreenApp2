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

class SettingsDeviceBlocEventRefresh extends SettingsDeviceBlocEvent {
  final bool delete;

  SettingsDeviceBlocEventRefresh({this.delete = false});

  @override
  List<Object> get props => [delete];
}

class SettingsDeviceBlocEventRefreshing extends SettingsDeviceBlocEvent {
  final double percent;
  SettingsDeviceBlocEventRefreshing(this.percent);

  @override
  List<Object> get props => [percent];
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

class SettingsDeviceBlocStateRefreshing extends SettingsDeviceBlocState {
  final double percent;
  SettingsDeviceBlocStateRefreshing(this.percent);

  @override
  List<Object> get props => [percent];
}

class SettingsDeviceBlocStateLoaded extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateLoaded(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsDeviceBlocStateRefreshed extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateRefreshed(this.device);

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
    } else if (event is SettingsDeviceBlocEventRefresh) {
      yield SettingsDeviceBlocStateRefreshing(0);
      refreshParams(delete: event.delete);
    } else if (event is SettingsDeviceBlocEventRefreshing) {
      if (event.percent != 100) {
        yield SettingsDeviceBlocStateRefreshing(event.percent);
      } else {
        yield SettingsDeviceBlocStateRefreshed(device);
        await Future.delayed(Duration(seconds: 2));
        yield SettingsDeviceBlocStateLoaded(device);
      }
    } else if (event is SettingsDeviceBlocEventUpdate) {
      yield SettingsDeviceBlocStateLoading();
      await DeviceHelper.updateDeviceName(args.device, event.name);
      yield SettingsDeviceBlocStateDone(device);
    }
  }

  void refreshParams({bool delete = false}) async {
    String? auth = AppDB().getDeviceAuth(device.identifier);
    final deviceName = await DeviceAPI.fetchStringParam(device.ip, "DEVICE_NAME", auth: auth);
    final mdnsDomain = await DeviceAPI.fetchStringParam(device.ip, "MDNS_DOMAIN", auth: auth);
    await RelDB.get().devicesDAO.updateDevice(
        DevicesCompanion(id: Value(device.id), name: Value(deviceName), mdns: Value(mdnsDomain), synced: Value(false)));
    await DeviceAPI.fetchAllParams(device.ip, device.id, (adv) {
      add(SettingsDeviceBlocEventRefreshing(adv));
    }, delete: delete, auth: auth);
    add(SettingsDeviceBlocEventRefreshing(100));
  }
}
