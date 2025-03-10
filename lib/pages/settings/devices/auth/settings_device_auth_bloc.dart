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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
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

  final String? oldUsername;
  final String? oldPassword;

  SettingsDeviceAuthBlocEventSetAuth(
      {required this.username, required this.password, this.oldUsername, this.oldPassword});

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
  final bool? needsUpgrade;

  SettingsDeviceAuthBlocStateLoaded(this.device, {required this.authSetup, this.needsUpgrade});

  @override
  List<Object?> get props => [device, authSetup, needsUpgrade];
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

class SettingsDeviceAuthBloc extends LegacyBloc<SettingsDeviceAuthBlocEvent, SettingsDeviceAuthBlocState> {
  final MainNavigateToSettingsDeviceAuth args;

  SettingsDeviceAuthBloc(this.args) : super(SettingsDeviceAuthBlocStateInit()) {
    add(SettingsDeviceAuthBlocEventInit());
  }

  @override
  Stream<SettingsDeviceAuthBlocState> mapEventToState(SettingsDeviceAuthBlocEvent event) async* {
    if (event is SettingsDeviceAuthBlocEventInit) {
      Param otaTimestamp = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_TIMESTAMP');
      String? auth = AppDB().getDeviceAuth(args.device.identifier);
      yield SettingsDeviceAuthBlocStateLoaded(
        args.device,
        authSetup: auth != null,
        needsUpgrade: otaTimestamp.ivalue! <= BackendAPI.lastBeforeRemoteControlTimestamp,
      );
    } else if (event is SettingsDeviceAuthBlocEventSetAuth) {
      yield SettingsDeviceAuthBlocStateLoading();
      String? auth = AppDB().getDeviceAuth(args.device.identifier);
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
            authSetup: true,
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
