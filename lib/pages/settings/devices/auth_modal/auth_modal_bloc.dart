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
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class AuthModalBlocEvent extends Equatable {}

class AuthModalBlocEventInit extends AuthModalBlocEvent {
  @override
  List<Object> get props => [];
}

class AuthModalBlocEventAuth extends AuthModalBlocEvent {
  final String username;
  final String password;

  AuthModalBlocEventAuth({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

abstract class AuthModalBlocState extends Equatable {}

class AuthModalBlocStateInit extends AuthModalBlocState {
  @override
  List<Object> get props => [];
}

class AuthModalBlocStateLoaded extends AuthModalBlocState {
  final Device device;

  AuthModalBlocStateLoaded({required this.device});

  @override
  List<Object> get props => [device];
}

class AuthModalBlocStateDone extends AuthModalBlocState {
  final Device device;

  AuthModalBlocStateDone({required this.device});

  @override
  List<Object> get props => [device];
}

class AuthModalBloc extends LegacyBloc<AuthModalBlocEvent, AuthModalBlocState> {
  final Device device;
  final Function onClose;

  AuthModalBloc({required this.device, required this.onClose}) : super(AuthModalBlocStateInit()) {
    add(AuthModalBlocEventInit());
  }

  @override
  Stream<AuthModalBlocState> mapEventToState(AuthModalBlocEvent event) async* {
    if (event is AuthModalBlocEventInit) {
      yield AuthModalBlocStateLoaded(device: device);
    } else if (event is AuthModalBlocEventAuth) {
      await DeviceHelper.updateAuth(device, event.username, event.password);
      yield AuthModalBlocStateDone(device: device);
      await Future.delayed(Duration(seconds: 1));
      onClose();
    }
  }
}
