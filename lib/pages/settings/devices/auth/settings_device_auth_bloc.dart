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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/device_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsDeviceAuthBlocEvent extends Equatable {}

class SettingsDeviceAuthBlocEventInit extends SettingsDeviceAuthBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDeviceAuthBlocEventPair extends SettingsDeviceAuthBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDeviceAuthBlocEventSetAuth extends SettingsDeviceAuthBlocEvent {
  final String username;
  final String password;

  final String oldUsername;
  final String oldPassword;

  SettingsDeviceAuthBlocEventSetAuth({this.username, this.password, this.oldUsername, this.oldPassword});

  @override
  List<Object> get props => [username, password];
}

abstract class SettingsDeviceAuthBlocState extends Equatable {}

class SettingsDeviceAuthBlocStateInit extends SettingsDeviceAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDeviceAuthBlocStateLoaded extends SettingsDeviceAuthBlocState {
  final Device device;
  final bool authSetup;

  SettingsDeviceAuthBlocStateLoaded(this.device, {this.authSetup});

  @override
  List<Object> get props => [device, authSetup];
}

class SettingsDeviceAuthBlocStateLoading extends SettingsDeviceAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDeviceAuthBlocStateAuthError extends SettingsDeviceAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDeviceAuthBlocStateDoneAuth extends SettingsDeviceAuthBlocState {
  final Device device;

  SettingsDeviceAuthBlocStateDoneAuth(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsDeviceAuthBloc extends Bloc<SettingsDeviceAuthBlocEvent, SettingsDeviceAuthBlocState> {
  final MainNavigateToSettingsDeviceAuth args;

  SettingsDeviceAuthBloc(this.args) : super(SettingsDeviceAuthBlocStateInit()) {
    add(SettingsDeviceAuthBlocEventInit());
  }

  @override
  Stream<SettingsDeviceAuthBlocState> mapEventToState(SettingsDeviceAuthBlocEvent event) async* {
    if (event is SettingsDeviceAuthBlocEventInit) {
      String auth = AppDB().getDeviceAuth(args.device.identifier);
      yield SettingsDeviceAuthBlocStateLoaded(
        args.device,
        authSetup: auth != null,
      );
    } else if (event is SettingsDeviceAuthBlocEventSetAuth) {
      yield SettingsDeviceAuthBlocStateLoading();
      String auth = AppDB().getDeviceAuth(args.device.identifier);
      if (auth != null) {
        try {
          String oldAuth = base64.encode(utf8.encode('${event.oldUsername}:${event.oldPassword}'));
          String identifier =
              await DeviceAPI.fetchStringParam(args.device.ip, 'BROKER_CLIENTID', nRetries: 1, auth: oldAuth);
          if (identifier != args.device.identifier) {
            throw 'Wrong identifier';
          }
        } catch (e) {
          yield SettingsDeviceAuthBlocStateAuthError();
          yield SettingsDeviceAuthBlocStateLoaded(
            args.device,
            authSetup: auth != null,
          );
          return;
        }
      }

      await DeviceHelper.updateAuth(args.device, event.username, event.password);
      await Future.delayed(Duration(seconds: 1));
      yield SettingsDeviceAuthBlocStateDoneAuth(args.device);
    }
  }
}
