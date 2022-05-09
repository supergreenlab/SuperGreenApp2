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

import 'dart:async';

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DevicePairingBlocEvent extends Equatable {}

class DevicePairingBlocEventPair extends DevicePairingBlocEvent {
  DevicePairingBlocEventPair();

  @override
  List<Object> get props => [];
}

class DevicePairingBlocEventInit extends DevicePairingBlocEvent {
  DevicePairingBlocEventInit();

  @override
  List<Object> get props => [];
}

abstract class DevicePairingBlocState extends Equatable {}

class DevicePairingBlocStateLoaded extends DevicePairingBlocState {
  final Device device;
  final bool loggedIn;
  final bool needsUpgrade;

  DevicePairingBlocStateLoaded(this.device, {required this.loggedIn, required this.needsUpgrade});

  @override
  List<Object> get props => [device, loggedIn, needsUpgrade];
}

class DevicePairingBlocStateInit extends DevicePairingBlocState {
  DevicePairingBlocStateInit();

  @override
  List<Object> get props => [];
}

class DevicePairingBlocStateLoading extends DevicePairingBlocState {
  DevicePairingBlocStateLoading();

  @override
  List<Object> get props => [];
}

class DevicePairingBlocStateDone extends DevicePairingBlocState {
  final Device device;

  DevicePairingBlocStateDone(this.device);

  @override
  List<Object> get props => [device];
}

class DevicePairingBloc extends LegacyBloc<DevicePairingBlocEvent, DevicePairingBlocState> {
  final MainNavigateToDevicePairingEvent args;

  DevicePairingBloc(this.args) : super(DevicePairingBlocStateInit()) {
    add(DevicePairingBlocEventInit());
  }

  @override
  Stream<DevicePairingBlocState> mapEventToState(DevicePairingBlocEvent event) async* {
    if (event is DevicePairingBlocEventInit) {
      Param otaTimestamp = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_TIMESTAMP');
      yield DevicePairingBlocStateLoaded(
        args.device,
        loggedIn: AppDB().getAppData().jwt != null,
        needsUpgrade: otaTimestamp.ivalue! <= BackendAPI.lastBeforeRemoteControlTimestamp,
      );
    } else if (event is DevicePairingBlocEventPair) {
      yield DevicePairingBlocStateLoading();
      await DeviceHelper.pairDevice(args.device);
      await Future.delayed(Duration(seconds: 1));
      yield DevicePairingBlocStateDone(args.device);
    }
  }
}
