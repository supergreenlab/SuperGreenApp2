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
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:wifi_iot/wifi_iot.dart';

const DefaultSSID = '🤖🍁';
const DefaultPass = 'multipass';

abstract class NewDeviceBlocEvent extends Equatable {}

class NewDeviceBlocEventStartSearch extends NewDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateMissingPermission extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateConnectingToSSID extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateConnectionToSSIDFailed extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateConnectionToSSIDSuccess extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBloc extends Bloc<NewDeviceBlocEvent, NewDeviceBlocState> {
  MainNavigateToNewDeviceEvent _args;
  final PermissionHandler _permissionHandler = PermissionHandler();

  @override
  NewDeviceBlocState get initialState => NewDeviceBlocState();

  NewDeviceBloc(this._args) {
    Future.delayed(const Duration(seconds: 1), () => this.add(NewDeviceBlocEventStartSearch()));
  }

  @override
  Stream<NewDeviceBlocState> mapEventToState(NewDeviceBlocEvent event) async* {
    if (event is NewDeviceBlocEventStartSearch) {
      yield* this._startSearch(event);
    }
  }

  Stream<NewDeviceBlocState> _startSearch(
      NewDeviceBlocEventStartSearch event) async* {
    if (Platform.isIOS &&
        await _permissionHandler
                .checkPermissionStatus(PermissionGroup.locationWhenInUse) !=
            PermissionStatus.granted) {
      final result = await _permissionHandler
          .requestPermissions([PermissionGroup.locationWhenInUse]);
      if (result[PermissionGroup.locationWhenInUse] !=
          PermissionStatus.granted) {
        yield NewDeviceBlocStateMissingPermission();
        return;
      }
    }
    final currentSSID = await WiFiForIoTPlugin.getSSID();
    if (currentSSID != DefaultSSID) {
      yield NewDeviceBlocStateConnectingToSSID();
      if (await WiFiForIoTPlugin.connect(DefaultSSID,
              password: DefaultPass, security: NetworkSecurity.WPA, joinOnce: false) ==
          false) {
        yield NewDeviceBlocStateConnectionToSSIDFailed();
        return;
      }
    }
    yield NewDeviceBlocStateConnectionToSSIDSuccess();
  }
}
