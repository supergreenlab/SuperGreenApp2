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
import 'package:super_green_app/data/backend/time_series/time_series_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class PlantFeedAppBarBlocEvent extends Equatable {}

class PlantFeedAppBarBlocEventLoadChart extends PlantFeedAppBarBlocEvent {
  @override
  List<Object> get props => [];
}

class PlantFeedAppBarBlocEventReloadChart extends PlantFeedAppBarBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  @override
  List<Object> get props => [rand];
}

abstract class PlantFeedAppBarBlocState extends Equatable {}

class PlantFeedAppBarBlocStateInit extends PlantFeedAppBarBlocState {
  @override
  List<Object> get props => [];
}

class PlantFeedAppBarBlocStateLoaded extends PlantFeedAppBarBlocState {
  final List<charts.Series<Metric, DateTime>> graphData;
  final Plant plant;

  PlantFeedAppBarBlocStateLoaded(this.graphData, this.plant);

  @override
  List<Object> get props => [graphData, plant];
}

class PlantFeedAppBarBloc
    extends Bloc<PlantFeedAppBarBlocEvent, PlantFeedAppBarBlocState> {
  Timer _timer;
  final Plant plant;

  PlantFeedAppBarBloc(this.plant) {
    add(PlantFeedAppBarBlocEventLoadChart());
  }

  @override
  PlantFeedAppBarBlocState get initialState => PlantFeedAppBarBlocStateInit();

  @override
  Stream<PlantFeedAppBarBlocState> mapEventToState(
      PlantFeedAppBarBlocEvent event) async* {
    if (event is PlantFeedAppBarBlocEventLoadChart) {
      try {
        List<charts.Series<Metric, DateTime>> graphData =
            await updateChart(plant);
        yield PlantFeedAppBarBlocStateLoaded(graphData, plant);
        _timer = Timer.periodic(Duration(seconds: 60), (timer) {
          this.add(PlantFeedAppBarBlocEventReloadChart());
        });
      } catch (e) {}
    } else if (event is PlantFeedAppBarBlocEventReloadChart) {
      try {
        List<charts.Series<Metric, DateTime>> graphData =
            await updateChart(plant);
        yield PlantFeedAppBarBlocStateLoaded(graphData, plant);
      } catch (e) {}
    }
  }

  Future<List<charts.Series<Metric, DateTime>>> updateChart(Plant plant) async {
    if (plant.device == null) {
      await Future.delayed(Duration(milliseconds: 500));
      return _createDummyData();
    } else {
      Device device = await RelDB.get().devicesDAO.getDevice(plant.device);
      if (device == null) {
        _timer.cancel();
        return _createDummyData();
      }
      String identifier = device.identifier;
      int deviceBox = plant.deviceBox;
      charts.Series<Metric, DateTime> temp =
          await TimeSeriesAPI.fetchTimeSeries(
              plant,
              identifier,
              'Temperature',
              'BOX_${deviceBox}_TEMP',
              charts.MaterialPalette.green.shadeDefault,
              transform: _tempUnit);
      charts.Series<Metric, DateTime> humi =
          await TimeSeriesAPI.fetchTimeSeries(
              plant,
              identifier,
              'Humidity',
              'BOX_${deviceBox}_HUMI',
              charts.MaterialPalette.blue.shadeDefault);
      charts.Series<Metric, DateTime> ventilation =
          await TimeSeriesAPI.fetchTimeSeries(
              plant,
              identifier,
              'Ventilation',
              'BOX_${deviceBox}_BLOWER_DUTY',
              charts.MaterialPalette.cyan.shadeDefault);
      List<dynamic> timerOutput = await TimeSeriesAPI.fetchMetric(
          plant, identifier, 'BOX_${deviceBox}_TIMER_OUTPUT');
      List<List<dynamic>> dims = [];
      Module lightModule =
          await RelDB.get().devicesDAO.getModule(device.id, "led");
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param boxParam =
            await RelDB.get().devicesDAO.getParam(device.id, "LED_${i}_BOX");
        if (boxParam.ivalue != plant.deviceBox) {
          continue;
        }
        List<dynamic> dim =
            await TimeSeriesAPI.fetchMetric(plant, identifier, 'LED_${i}_DIM');
        dims.add(dim);
      }
      List<int> avgDims = TimeSeriesAPI.avgMetrics(dims);
      charts.Series<Metric, DateTime> light = TimeSeriesAPI.toTimeSeries(
          TimeSeriesAPI.multiplyMetric(timerOutput, avgDims),
          'Light',
          charts.MaterialPalette.yellow.shadeDefault);
      return [temp, humi, light, ventilation];
    }
  }

  List<charts.Series<Metric, DateTime>> _createDummyData() {
    final tempData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            _tempUnit((cos(index / 100) * 20) + Random().nextInt(7) + 20)
                .toDouble()));
    final humiData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            ((sin(index / 100) * 5).toInt() + Random().nextInt(3) + 20)
                .toDouble()));
    final lightData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20)
                .toDouble()));

    return [
      charts.Series<Metric, DateTime>(
        id: 'Temperature',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: tempData,
      ),
      charts.Series<Metric, DateTime>(
        id: 'Humidity',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: humiData,
      ),
      charts.Series<Metric, DateTime>(
        id: 'Light',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: lightData,
      ),
    ];
  }

  double _tempUnit(double temp) {
    if (AppDB().getAppData().freedomUnits == true) {
      return temp * 9 / 5 + 32;
    }
    return temp;
  }

  @override
  Future<void> close() async {
    if (_timer != null) {
      _timer.cancel();
    }
    return super.close();
  }
}
