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

abstract class DevicePairingBlocEvent extends Equatable {}

class DevicePairingBlocEventReset extends DevicePairingBlocEvent {
  DevicePairingBlocEventReset();

  @override
  List<Object> get props => [];
}

class DevicePairingBlocEventSetName extends DevicePairingBlocEvent {
  final String name;
  DevicePairingBlocEventSetName(this.name);

  @override
  List<Object> get props => [name];
}

class DevicePairingBlocEventPair extends DevicePairingBlocEvent {
  DevicePairingBlocEventPair();

  @override
  List<Object> get props => [];
}

class DevicePairingBlocState extends Equatable {
  final Device device;
  DevicePairingBlocState(this.device);

  @override
  List<Object> get props => [device];
}

class DevicePairingBlocStateLoading extends DevicePairingBlocState {
  DevicePairingBlocStateLoading(Device device) : super(device);
}

class DevicePairingBlocStateDone extends DevicePairingBlocState {
  DevicePairingBlocStateDone(Device device) : super(device);
}

class DevicePairingBloc extends Bloc<DevicePairingBlocEvent, DevicePairingBlocState> {
  final MainNavigateToDevicePairingEvent args;

  DevicePairingBloc(this.args) : super(DevicePairingBlocState(args.device));

  @override
  Stream<DevicePairingBlocState> mapEventToState(DevicePairingBlocEvent event) async* {
    if (event is DevicePairingBlocEventReset) {
      yield DevicePairingBlocState(args.device);
    } else if (event is DevicePairingBlocEventPair) {
      yield DevicePairingBlocStateLoading(args.device);
      await DeviceHelper.pairDevice(args.device);
      await Future.delayed(Duration(seconds: 1));
      yield DevicePairingBlocStateDone(args.device);
    }
  }
}
