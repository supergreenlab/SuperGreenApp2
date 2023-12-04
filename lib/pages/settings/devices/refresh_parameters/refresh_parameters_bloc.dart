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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class RefreshParametersBlocEvent extends Equatable {}

class RefreshParametersBlocEventInit extends RefreshParametersBlocEvent {
  @override
  List<Object> get props => [];
}

class RefreshParametersBlocEventError extends RefreshParametersBlocEvent {
  @override
  List<Object> get props => [];
}

class RefreshParametersBlocEventRefreshing extends RefreshParametersBlocEvent {
  final double percent;
  RefreshParametersBlocEventRefreshing(this.percent);

  @override
  List<Object> get props => [percent];
}

class RefreshParametersBlocEventUpdate extends RefreshParametersBlocEvent {
  final String name;

  RefreshParametersBlocEventUpdate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class RefreshParametersBlocState extends Equatable {}

class RefreshParametersBlocStateLoading extends RefreshParametersBlocState {
  @override
  List<Object> get props => [];
}

class RefreshParametersBlocStateError extends RefreshParametersBlocState {
  @override
  List<Object> get props => [];
}

class RefreshParametersBlocStateRefreshing extends RefreshParametersBlocState {
  final double percent;
  RefreshParametersBlocStateRefreshing(this.percent);

  @override
  List<Object> get props => [percent];
}

class RefreshParametersBlocStateLoaded extends RefreshParametersBlocState {
  final Device device;

  RefreshParametersBlocStateLoaded(this.device);

  @override
  List<Object> get props => [device];
}

class RefreshParametersBlocStateRefreshed extends RefreshParametersBlocState {
  final Device device;

  RefreshParametersBlocStateRefreshed(this.device);

  @override
  List<Object> get props => [device];
}

class RefreshParametersBlocStateDone extends RefreshParametersBlocState {
  final Device device;

  RefreshParametersBlocStateDone(this.device);

  @override
  List<Object> get props => [device];
}

class RefreshParametersBloc extends LegacyBloc<RefreshParametersBlocEvent, RefreshParametersBlocState> {
  //ignore: unused_field
  final MainNavigateToRefreshParameters args;
  late Device device;

  RefreshParametersBloc(this.args) : super(RefreshParametersBlocStateLoading()) {
    add(RefreshParametersBlocEventInit());
  }

  @override
  Stream<RefreshParametersBlocState> mapEventToState(RefreshParametersBlocEvent event) async* {
    if (event is RefreshParametersBlocEventInit) {
      device = await RelDB.get().devicesDAO.getDevice(args.device.id);
      refreshParams();
      yield RefreshParametersBlocStateLoaded(device);
    } else if (event is RefreshParametersBlocEventRefreshing) {
      if (event.percent != 100) {
        yield RefreshParametersBlocStateRefreshing(event.percent);
      } else {
        yield RefreshParametersBlocStateRefreshed(device);
        await Future.delayed(Duration(seconds: 2));
        yield RefreshParametersBlocStateLoaded(device);
      }
    } else if (event is RefreshParametersBlocEventError) {
      yield RefreshParametersBlocStateError();
    }
  }

  void refreshParams({bool delete = false}) async {
    String? auth = AppDB().getDeviceAuth(device.identifier);
    final deviceName = await DeviceAPI.fetchStringParam(device.ip, "DEVICE_NAME", auth: auth);
    final mdnsDomain = await DeviceAPI.fetchStringParam(device.ip, "MDNS_DOMAIN", auth: auth);
    await RelDB.get().devicesDAO.updateDevice(
        DevicesCompanion(id: Value(device.id), name: Value(deviceName), mdns: Value(mdnsDomain), synced: Value(false)));
    try {
      await DeviceAPI.fetchAllParams(device.ip, device.id, (adv) {
        add(RefreshParametersBlocEventRefreshing(adv));
      }, delete: delete, auth: auth);
    } catch (e) {
      add(RefreshParametersBlocEventError());
    }
    add(RefreshParametersBlocEventRefreshing(100));
  }
}
