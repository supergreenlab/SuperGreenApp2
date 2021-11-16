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
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/services/models/alerts.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsPlantAlertsBlocEvent extends Equatable {}

class SettingsPlantAlertsBlocEventInit extends SettingsPlantAlertsBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  @override
  List<Object> get props => [rand];
}

class SettingsPlantAlertsBlocEventUpdateParameters extends SettingsPlantAlertsBlocEvent {
  final bool enabled;
  final AlertsSettings alertsSettings;

  SettingsPlantAlertsBlocEventUpdateParameters(this.enabled, this.alertsSettings);

  @override
  List<Object> get props => [enabled, alertsSettings];
}

abstract class SettingsPlantAlertsBlocState extends Equatable {}

class SettingsPlantAlertsBlocStateInit extends SettingsPlantAlertsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantAlertsBlocStateNotLoaded extends SettingsPlantAlertsBlocState {
  final bool? hasController;
  final bool? isSync;
  final bool? isLoggedIn;

  final Box box;

  SettingsPlantAlertsBlocStateNotLoaded({this.hasController, this.isSync, required this.box, this.isLoggedIn});

  @override
  List<Object?> get props => [hasController, isSync, box, isLoggedIn];
}

class SettingsPlantAlertsBlocStateLoaded extends SettingsPlantAlertsBlocState {
  final bool enabled;
  final AlertsSettings alertsSettings;

  SettingsPlantAlertsBlocStateLoaded(this.enabled, this.alertsSettings);

  @override
  List<Object> get props => [enabled, alertsSettings];
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

  StreamSubscription<Device>? deviceSubscription;

  SettingsPlantAlertsBloc(this.args) : super(SettingsPlantAlertsBlocStateInit()) {
    add(SettingsPlantAlertsBlocEventInit());
  }

  @override
  Stream<SettingsPlantAlertsBlocState> mapEventToState(SettingsPlantAlertsBlocEvent event) async* {
    if (event is SettingsPlantAlertsBlocEventInit) {
      Plant plant = await RelDB.get().plantsDAO.getPlant(args.plant.id);
      Box box = await RelDB.get().plantsDAO.getBox(plant.box!);
      if (box.device == null) {
        yield SettingsPlantAlertsBlocStateNotLoaded(hasController: false, box: box);
        return;
      }
      Device device = await RelDB.get().devicesDAO.getDevice(box.device!);
      if (device.serverID == null) {
        bool isLoggedIn = AppDB().getAppData().jwt != null;
        if (isLoggedIn) {
          deviceSubscription?.cancel();
          deviceSubscription = RelDB.get().devicesDAO.watchDevice(device.id).listen((Device device) {
            if (device.serverID != null) {
              add(SettingsPlantAlertsBlocEventInit());
              deviceSubscription?.cancel();
            }
          });
        }
        yield SettingsPlantAlertsBlocStateNotLoaded(isSync: false, box: box, isLoggedIn: isLoggedIn);
        return;
      }
      AlertsSettings alertsSettings = await BackendAPI().servicesAPI.getPlantAlertSettings(plant.serverID!);
      yield SettingsPlantAlertsBlocStateLoaded(plant.alerts, alertsSettings);
    } else if (event is SettingsPlantAlertsBlocEventUpdateParameters) {
      yield SettingsPlantAlertsBlocStateLoading();
      Plant plant = await RelDB.get().plantsDAO.getPlant(args.plant.id);
      await BackendAPI().servicesAPI.setPlantAlertSettings(plant.serverID!, event.alertsSettings);
      await RelDB.get()
          .plantsDAO
          .updatePlant(PlantsCompanion(id: Value(plant.id), alerts: Value(event.enabled), synced: Value(false)));

      yield SettingsPlantAlertsBlocStateDone(plant);
    }
  }

  @override
  Future<void> close() async {
    deviceSubscription?.cancel();
    await super.close();
  }
}
