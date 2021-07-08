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
import 'package:super_green_app/data/api/backend/services/models/alerts.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsPlantAlertsBlocEvent extends Equatable {}

class SettingsPlantAlertsBlocEventInit extends SettingsPlantAlertsBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBlocEventUpdateParameters extends SettingsPlantAlertsBlocEvent {
  final AlertsSettings alertsSettings;

  SettingsPlantAlertsBlocEventUpdateParameters(this.alertsSettings);

  @override
  List<Object> get props => [alertsSettings];
}

abstract class SettingsPlantAlertsBlocState extends Equatable {}

class SettingsPlantAlertsBlocStateInit extends SettingsPlantAlertsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBlocStateNotLoaded extends SettingsPlantAlertsBlocState {
  final bool hasController;
  final bool isSync;

  SettingsPlantAlertsBlocStateNotLoaded({this.hasController, this.isSync});

  @override
  List<Object> get props => [hasController, isSync];
}

class SettingsPlantAlertsBlocStateLoaded extends SettingsPlantAlertsBlocState {
  final AlertsSettings alertsSettings;

  SettingsPlantAlertsBlocStateLoaded(this.alertsSettings);

  @override
  List<Object> get props => [alertsSettings];
}

class SettingsPlantAlertsBlocStateDone extends SettingsPlantAlertsBlocState {
  final Plant plant;

  SettingsPlantAlertsBlocStateDone(this.plant);

  @override
  List<Object> get props => [plant];
}

class SettingsPlantAlertsBlocStateLoading extends SettingsPlantAlertsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBloc extends Bloc<SettingsPlantAlertsBlocEvent, SettingsPlantAlertsBlocState> {
  final MainNavigateToSettingsPlantAlerts args;

  SettingsPlantAlertsBloc(this.args) : super(SettingsPlantAlertsBlocStateInit()) {
    add(SettingsPlantAlertsBlocEventInit());
  }

  @override
  Stream<SettingsPlantAlertsBlocState> mapEventToState(SettingsPlantAlertsBlocEvent event) async* {
    if (event is SettingsPlantAlertsBlocEventInit) {
      Box box = await RelDB.get().plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        yield SettingsPlantAlertsBlocStateNotLoaded(hasController: false);
        return;
      }
      Device device = await RelDB.get().devicesDAO.getDevice(box.device);
      if (device.serverID == null) {
        yield SettingsPlantAlertsBlocStateNotLoaded(isSync: false);
        return;
      }
      AlertsSettings alertsSettings = await BackendAPI().servicesAPI.getPlantAlertSettings(args.plant.serverID);
      yield SettingsPlantAlertsBlocStateLoaded(alertsSettings);
    } else if (event is SettingsPlantAlertsBlocEventUpdateParameters) {
      yield SettingsPlantAlertsBlocStateLoading();
      await BackendAPI().servicesAPI.setPlantAlertSettings(args.plant.serverID, event.alertsSettings);
      yield SettingsPlantAlertsBlocStateDone(args.plant);
    }
  }
}
