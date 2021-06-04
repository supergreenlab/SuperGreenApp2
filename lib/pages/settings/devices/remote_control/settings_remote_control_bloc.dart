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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/device_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsRemoteControlBlocEvent extends Equatable {}

class SettingsRemoteControlBlocEventInit extends SettingsRemoteControlBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsRemoteControlBlocEventPair extends SettingsRemoteControlBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsRemoteControlBlocEventSetAuth extends SettingsRemoteControlBlocEvent {
  final String username;
  final String password;

  SettingsRemoteControlBlocEventSetAuth(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

abstract class SettingsRemoteControlBlocState extends Equatable {}

class SettingsRemoteControlBlocStateInit extends SettingsRemoteControlBlocState {
  @override
  List<Object> get props => [];
}

class SettingsRemoteControlBlocStateLoaded extends SettingsRemoteControlBlocState {
  final Device device;
  final bool signingSetup;

  SettingsRemoteControlBlocStateLoaded(this.device, {this.signingSetup});

  @override
  List<Object> get props => [device, signingSetup];
}

class SettingsRemoteControlBlocStateLoading extends SettingsRemoteControlBlocState {
  @override
  List<Object> get props => [];
}

class SettingsRemoteControlBlocStateDonePairing extends SettingsRemoteControlBlocState {
  final Device device;

  SettingsRemoteControlBlocStateDonePairing(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsRemoteControlBlocStateDoneAuth extends SettingsRemoteControlBlocState {
  final Device device;

  SettingsRemoteControlBlocStateDoneAuth(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsRemoteControlBloc extends Bloc<SettingsRemoteControlBlocEvent, SettingsRemoteControlBlocState> {
  final MainNavigateToSettingsRemoteControl args;

  SettingsRemoteControlBloc(this.args) : super(SettingsRemoteControlBlocStateInit()) {
    add(SettingsRemoteControlBlocEventInit());
  }

  @override
  Stream<SettingsRemoteControlBlocState> mapEventToState(SettingsRemoteControlBlocEvent event) async* {
    if (event is SettingsRemoteControlBlocEventInit) {
      DeviceData deviceData = AppDB().getDeviceData(args.device.identifier);
      yield SettingsRemoteControlBlocStateLoaded(
        args.device,
        signingSetup: deviceData.signing != null,
      );
    } else if (event is SettingsRemoteControlBlocEventPair) {
      yield SettingsRemoteControlBlocStateLoading();
      await DeviceHelper.pairDevice(args.device);
      await Future.delayed(Duration(seconds: 1));
      yield SettingsRemoteControlBlocStateDonePairing(args.device);
      add(SettingsRemoteControlBlocEventInit());
    }
  }
}
