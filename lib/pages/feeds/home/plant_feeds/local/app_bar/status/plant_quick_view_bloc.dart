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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/widgets/app_bar_metric.dart';

abstract class PlantQuickViewBlocEvent extends Equatable {}

class PlantQuickViewBlocEventInit extends PlantQuickViewBlocEvent {
  @override
  List<Object?> get props => [];
}

class PlantQuickViewBlocEventLoaded extends PlantQuickViewBlocEvent {
  final PlantQuickViewBlocStateLoaded state;

  PlantQuickViewBlocEventLoaded(this.state);

  @override
  List<Object?> get props => [state];
}

abstract class PlantQuickViewBlocState extends Equatable {}

class PlantQuickViewBlocStateInit extends PlantQuickViewBlocState {
  final Plant plant;

  PlantQuickViewBlocStateInit(this.plant);

  @override
  List<Object?> get props => [plant];
}

class PlantQuickViewBlocStateLoaded extends PlantQuickViewBlocState {
  final Plant plant;
  final BoxMetrics metrics;

  PlantQuickViewBlocStateLoaded(this.plant, this.metrics);

  @override
  List<Object?> get props => [this.plant, this.metrics];
}

class PlantQuickViewBloc extends LegacyBloc<PlantQuickViewBlocEvent, PlantQuickViewBlocState> {
  final Plant plant;
  Device? device;
  late Box box;

  late BoxMetrics metrics;

  late StreamSubscription<Param> tempListener;
  late StreamSubscription<Param> humidityListener;
  late StreamSubscription<Param> vpdListener;
  late StreamSubscription<Param> co2Listener;
  late StreamSubscription<Param> weightListener;

  PlantQuickViewBloc(this.plant) : super(PlantQuickViewBlocStateInit(plant)) {
    add(PlantQuickViewBlocEventInit());
  }

  @override
  Stream<PlantQuickViewBlocState> mapEventToState(PlantQuickViewBlocEvent event) async* {
    if (event is PlantQuickViewBlocEventInit) {
      metrics = BoxMetrics();
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(this.plant.box);
      device = await db.devicesDAO.getDevice(box.device!);
      try {
        metrics =
            metrics.copyWith(temp: await RelDB.get().devicesDAO.getParam(device!.id, "BOX_${box.deviceBox}_TEMP"));
        tempListener = RelDB.get().devicesDAO.watchParam(device!.id, "BOX_${box.deviceBox}_TEMP").listen(onTempChange);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"device": device});
      }
      try {
        metrics =
            metrics.copyWith(humidity: await RelDB.get().devicesDAO.getParam(device!.id, "BOX_${box.deviceBox}_HUMI"));
        humidityListener =
            RelDB.get().devicesDAO.watchParam(device!.id, "BOX_${box.deviceBox}_HUMI").listen(onHumidityChange);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"device": device});
      }
      try {
        metrics = metrics.copyWith(vpd: await RelDB.get().devicesDAO.getParam(device!.id, "BOX_${box.deviceBox}_VPD"));
        vpdListener = RelDB.get().devicesDAO.watchParam(device!.id, "BOX_${box.deviceBox}_VPD").listen(onVPDChange);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"device": device});
      }
      try {
        metrics = metrics.copyWith(co2: await RelDB.get().devicesDAO.getParam(device!.id, "BOX_${box.deviceBox}_CO2"));
        co2Listener = RelDB.get().devicesDAO.watchParam(device!.id, "BOX_${box.deviceBox}_CO2").listen(onCO2Change);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"device": device});
      }
      try {
        metrics =
            metrics.copyWith(weight: await RelDB.get().devicesDAO.getParam(device!.id, "BOX_${box.deviceBox}_WEIGHT"));
        weightListener =
            RelDB.get().devicesDAO.watchParam(device!.id, "BOX_${box.deviceBox}_WEIGHT").listen(onWeightChange);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"device": device});
      }

      yield PlantQuickViewBlocStateLoaded(plant, metrics);
    } else if (event is PlantQuickViewBlocEventLoaded) {
      yield event.state;
    }
  }

  void onTempChange(Param value) {
    add(PlantQuickViewBlocEventLoaded(PlantQuickViewBlocStateLoaded(plant, metrics.copyWith(temp: value))));
  }

  void onHumidityChange(Param value) {
    add(PlantQuickViewBlocEventLoaded(PlantQuickViewBlocStateLoaded(plant, metrics.copyWith(humidity: value))));
  }

  void onVPDChange(Param value) {
    add(PlantQuickViewBlocEventLoaded(PlantQuickViewBlocStateLoaded(plant, metrics.copyWith(vpd: value))));
  }

  void onCO2Change(Param value) {
    add(PlantQuickViewBlocEventLoaded(PlantQuickViewBlocStateLoaded(plant, metrics.copyWith(co2: value))));
  }

  void onWeightChange(Param value) {
    add(PlantQuickViewBlocEventLoaded(PlantQuickViewBlocStateLoaded(plant, metrics.copyWith(weight: value))));
  }

  @override
  Future<void> close() {
    tempListener.cancel();
    humidityListener.cancel();
    vpdListener.cancel();
    co2Listener.cancel();
    weightListener.cancel();
    return super.close();
  }
}
