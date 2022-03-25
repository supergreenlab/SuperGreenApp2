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
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_page.dart';

class BoxMetrics extends Equatable {
  final Param? temp;
  final Param? humidity;
  final Param? vpd;
  final Param? co2;
  final Param? weight;
  final DateTime? lastWatering;

  BoxMetrics({this.temp, this.humidity, this.vpd, this.co2, this.weight, this.lastWatering});

  @override
  List<Object?> get props => [temp, humidity, vpd, co2, weight, lastWatering];

  BoxMetrics copyWith({Param? temp, Param? humidity, Param? vpd, Param? co2, Param? weight, DateTime? lastWatering}) {
    return BoxMetrics(
      temp: temp ?? this.temp,
      humidity: humidity ?? this.humidity,
      vpd: vpd ?? this.vpd,
      co2: co2 ?? this.co2,
      weight: weight ?? this.weight,
    );
  }
}

abstract class AppBarMetricsBlocEvent extends Equatable {}

class AppBarMetricsBlocEventInit extends AppBarMetricsBlocEvent {
  @override
  List<Object?> get props => [];
}

class AppBarMetricsBlocEventLoaded extends AppBarMetricsBlocEvent {
  final AppBarMetricsBlocStateLoaded state;

  AppBarMetricsBlocEventLoaded(this.state);

  @override
  List<Object?> get props => [state];
}

abstract class AppBarMetricsBlocState extends Equatable {}

class AppBarMetricsBlocStateInit extends AppBarMetricsBlocState {
  final Plant plant;

  AppBarMetricsBlocStateInit(this.plant);

  @override
  List<Object?> get props => [plant];
}

class AppBarMetricsBlocStateLoaded extends AppBarMetricsBlocState {
  final Plant plant;
  final BoxMetrics metrics;

  AppBarMetricsBlocStateLoaded(this.plant, this.metrics);

  @override
  List<Object?> get props => [this.plant, this.metrics];
}

class AppBarMetricsBloc extends LegacyBloc<AppBarMetricsBlocEvent, AppBarMetricsBlocState> {
  final Plant plant;
  Device? device;
  late Box box;

  late BoxMetrics metrics;

  late StreamSubscription<Param> tempListener;
  late StreamSubscription<Param> humidityListener;
  late StreamSubscription<Param> vpdListener;
  late StreamSubscription<Param> co2Listener;
  late StreamSubscription<Param> weightListener;

  AppBarMetricsBloc(this.plant) : super(AppBarMetricsBlocStateInit(plant)) {
    add(AppBarMetricsBlocEventInit());
  }

  @override
  Stream<AppBarMetricsBlocState> mapEventToState(AppBarMetricsBlocEvent event) async* {
    if (event is AppBarMetricsBlocEventInit) {
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

      yield AppBarMetricsBlocStateLoaded(plant, metrics);
    } else if (event is AppBarMetricsBlocEventLoaded) {
      yield event.state;
    }
  }

  void onTempChange(Param value) {
    add(AppBarMetricsBlocEventLoaded(AppBarMetricsBlocStateLoaded(plant, metrics.copyWith(temp: value))));
  }

  void onHumidityChange(Param value) {
    add(AppBarMetricsBlocEventLoaded(AppBarMetricsBlocStateLoaded(plant, metrics.copyWith(humidity: value))));
  }

  void onVPDChange(Param value) {
    add(AppBarMetricsBlocEventLoaded(AppBarMetricsBlocStateLoaded(plant, metrics.copyWith(vpd: value))));
  }

  void onCO2Change(Param value) {
    add(AppBarMetricsBlocEventLoaded(AppBarMetricsBlocStateLoaded(plant, metrics.copyWith(co2: value))));
  }

  void onWeightChange(Param value) {
    add(AppBarMetricsBlocEventLoaded(AppBarMetricsBlocStateLoaded(plant, metrics.copyWith(weight: value))));
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
