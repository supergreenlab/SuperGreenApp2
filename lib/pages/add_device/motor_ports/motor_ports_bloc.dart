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

import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class MotorPortBlocEvent extends Equatable {}

class MotorPortBlocEventInit extends MotorPortBlocEvent {
  MotorPortBlocEventInit() : super();

  @override
  List<Object> get props => [];
}

class MotorPortBlocState extends Equatable {
  final List<Device> devices;

  MotorPortBlocState(this.devices);

  @override
  List<Object> get props => [devices];
}

class MotorPortBlocStateDeviceListUpdated extends MotorPortBlocState {
  MotorPortBlocStateDeviceListUpdated(List<Device> devices) : super(devices);
}

class MotorPortBlocStateDone extends MotorPortBlocState {
  final Device device;
  final int deviceBox;

  MotorPortBlocStateDone(List<Device> devices, this.device, this.deviceBox) : super(devices);

  @override
  List<Object> get props => [];
}

class MotorPortBloc extends LegacyBloc<MotorPortBlocEvent, MotorPortBlocState> {
  List<Device> _devices = [];
  StreamSubscription<List<Device>>? _stream;

  //ignore: unused_field
  final MainNavigateToMotorPortEvent args;

  MotorPortBloc(this.args) : super(MotorPortBlocState([])) {
    this.add(MotorPortBlocEventInit());
  }

  @override
  Stream<MotorPortBlocState> mapEventToState(MotorPortBlocEvent event) async* {
    if (event is MotorPortBlocEventInit) {
      final ddb = RelDB.get().devicesDAO;
    }
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
