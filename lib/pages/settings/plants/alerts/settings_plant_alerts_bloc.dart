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
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsPlantAlertsBlocEvent extends Equatable {}

class SettingsPlantAlertsBlocEventInit extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBlocEventUpdateParameters extends SettingsPlantAlertsBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SettingsPlantAlertsBlocState extends Equatable {}

class SettingsPlantAlertsBlocStateInit extends SettingsPlantAlertsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBlocStateDone extends SettingsPlantAlertsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBlocStateLoading extends SettingsPlantAlertsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBloc extends Bloc<SettingsPlantAlertsBlocEvent, SettingsPlantAlertsBlocState> {
  final MainNavigateToSettingsPlantAlerts args;

  SettingsPlantAlertsBloc(this.args) : super(SettingsPlantAlertsBlocStateInit());

  @override
  Stream<SettingsPlantAlertsBlocState> mapEventToState(SettingsPlantAlertsBlocEvent event) async* {
    if (event is SettingsPlantAlertsBlocEventInit) {}
  }
}
