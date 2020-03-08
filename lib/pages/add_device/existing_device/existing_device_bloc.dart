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
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class ExistingDeviceBlocEvent extends Equatable {}

class ExistingDeviceBlocEventStartSearch extends ExistingDeviceBlocEvent {
  final String query;
  ExistingDeviceBlocEventStartSearch(this.query);

  @override
  List<Object> get props => [query];
}

class ExistingDeviceBlocState extends Equatable {
  @override
  List<Object> get props => [];

}

class ExistingDeviceBlocStateResolving extends ExistingDeviceBlocState {
  ExistingDeviceBlocStateResolving() : super();
}

class ExistingDeviceBlocStateFound extends ExistingDeviceBlocState {
  final String ip;
  ExistingDeviceBlocStateFound(this.ip) : super();

  @override
  List<Object> get props => [this.ip];
}

class ExistingDeviceBlocStateNotFound extends ExistingDeviceBlocState {
  ExistingDeviceBlocStateNotFound();
}

class ExistingDeviceBloc
    extends Bloc<ExistingDeviceBlocEvent, ExistingDeviceBlocState> {
  final MainNavigateToExistingDeviceEvent _args;

  ExistingDeviceBloc(this._args);

  @override
  ExistingDeviceBlocState get initialState => ExistingDeviceBlocState();

  @override
  Stream<ExistingDeviceBlocState> mapEventToState(
      ExistingDeviceBlocEvent event) async* {
    if (event is ExistingDeviceBlocEventStartSearch) {
      yield ExistingDeviceBlocStateResolving();
      final ip = await DeviceAPI.resolveLocalName(event.query.toLowerCase());
      if (ip == "" || ip == null) {
        yield ExistingDeviceBlocStateNotFound();
        return;
      }
      yield ExistingDeviceBlocStateFound(ip);
    }
  }

}
