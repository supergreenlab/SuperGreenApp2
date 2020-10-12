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
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/users/users_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsAuthBlocEvent extends Equatable {}

class SettingsAuthBlocEventInit extends SettingsAuthBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsAuthBlocEventSetSyncedOverGSM extends SettingsAuthBlocEvent {
  final bool syncOverGSM;

  SettingsAuthBlocEventSetSyncedOverGSM(this.syncOverGSM);

  @override
  List<Object> get props => [syncOverGSM];
}

class SettingsAuthBlocEventLogout extends SettingsAuthBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SettingsAuthBlocState extends Equatable {}

class SettingsAuthBlocStateInit extends SettingsAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsAuthBlocStateLoading extends SettingsAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsAuthBlocStateLoaded extends SettingsAuthBlocState {
  final bool isAuth;
  final bool syncOverGSM;
  final User user;

  SettingsAuthBlocStateLoaded(this.isAuth, this.syncOverGSM, this.user);

  @override
  List<Object> get props => [isAuth, syncOverGSM, user];
}

class SettingsAuthBlocStateDone extends SettingsAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsAuthBloc
    extends Bloc<SettingsAuthBlocEvent, SettingsAuthBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsAuth args;
  bool _isAuth;

  SettingsAuthBloc(this.args) : super(SettingsAuthBlocStateInit()) {
    _isAuth = AppDB().getAppData().jwt != null;
    add(SettingsAuthBlocEventInit());
  }

  @override
  Stream<SettingsAuthBlocState> mapEventToState(
      SettingsAuthBlocEvent event) async* {
    if (event is SettingsAuthBlocEventInit) {
      yield SettingsAuthBlocStateLoading();
      yield SettingsAuthBlocStateLoaded(
          _isAuth, AppDB().getAppData().syncOverGSM, null);
      User user;
      if (_isAuth) {
        user = await BackendAPI().usersAPI.me();
      }
      yield SettingsAuthBlocStateLoaded(
          _isAuth, AppDB().getAppData().syncOverGSM, user);
    } else if (event is SettingsAuthBlocEventSetSyncedOverGSM) {
      AppDB().setSynceOverGSM(event.syncOverGSM);
    } else if (event is SettingsAuthBlocEventLogout) {
      AppDB().setJWT(null);
      yield SettingsAuthBlocStateDone();
    }
  }
}
