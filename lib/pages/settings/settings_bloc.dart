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
import 'package:super_green_app/data/kv/app_db.dart';

abstract class SettingsBlocEvent extends Equatable {}

class SettingsBlocEventSetFreedomUnit extends SettingsBlocEvent {
  final bool freedomUnits;

  SettingsBlocEventSetFreedomUnit(this.freedomUnits);

  @override
  List<Object> get props => [freedomUnits];
}

class SettingsBlocEventSetPinLock extends SettingsBlocEvent {
  final String pinLock;

  SettingsBlocEventSetPinLock(this.pinLock);

  @override
  List<Object> get props => [pinLock];
}

class SettingsBlocState extends Equatable {
  final bool freedomUnits;
  final String pinLock;

  SettingsBlocState(this.freedomUnits, this.pinLock);

  @override
  List<Object> get props => [freedomUnits, pinLock];
}

class SettingsBloc extends LegacyBloc<SettingsBlocEvent, SettingsBlocState> {
  SettingsBloc() : super(SettingsBlocState(
    AppDB().getUserSettings().freedomUnits!,
    AppDB().getAppData().pinLock ?? '',
  ));

  @override
  Stream<SettingsBlocState> mapEventToState(SettingsBlocEvent event) async* {
    if (event is SettingsBlocEventSetFreedomUnit) {
      AppDB().setFreedomUnits(event.freedomUnits);
      yield SettingsBlocState(event.freedomUnits, state.pinLock);
    } else if (event is SettingsBlocEventSetPinLock) {
      AppDB().setPinLock(event.pinLock);
      yield SettingsBlocState(state.freedomUnits, event.pinLock);
    }
  }
}
