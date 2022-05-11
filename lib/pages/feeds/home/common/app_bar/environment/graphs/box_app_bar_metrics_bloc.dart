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
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/time_series/time_series_api.dart';
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
  final Plant? plant;
  final Box box;

  PlantFeedAppBarBlocStateLoaded(this.graphData, this.plant, this.box);

  @override
  List<Object?> get props => [graphData, plant, box];
}

class BoxAppBarMetricsBloc extends LegacyBloc<PlantFeedAppBarBlocEvent, PlantFeedAppBarBlocState> {
  Timer? _timer;
  final Plant? plant;
  Box? box;

  BoxAppBarMetricsBloc({this.plant, this.box}) : super(PlantFeedAppBarBlocStateInit()) {
    add(PlantFeedAppBarBlocEventLoadChart());
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      this.add(PlantFeedAppBarBlocEventReloadChart());
    });
  }

  @override
  Stream<PlantFeedAppBarBlocState> mapEventToState(PlantFeedAppBarBlocEvent event) async* {
    if (event is PlantFeedAppBarBlocEventLoadChart) {
      try {
        if (box == null) {
          final db = RelDB.get();
          box = await db.plantsDAO.getBox(plant!.box);
        }
        List<charts.Series<Metric, DateTime>> graphData = await updateChart();
        yield PlantFeedAppBarBlocStateLoaded(graphData, plant, box!);
      } catch (e) {
        print(e);
      }
    } else if (event is PlantFeedAppBarBlocEventReloadChart) {
      try {
        List<charts.Series<Metric, DateTime>> graphData = await updateChart();
        yield PlantFeedAppBarBlocStateLoaded(graphData, plant, box!);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List<charts.Series<Metric, DateTime>>> updateChart() async {
    if (box?.device == null) {
      return _createDummyData();
    } else {
      late Device device;
      try {
        device = await RelDB.get().devicesDAO.getDevice(box!.device!);
      } catch (e) {
        _timer?.cancel();
        _timer = null;
        return _createDummyData();
      }
      String identifier = device.identifier;
      int deviceBox = box!.deviceBox!;
      charts.Series<Metric, DateTime> temp = await TimeSeriesAPI.fetchTimeSeries(
          box!, identifier, 'Temperature', 'BOX_${deviceBox}_TEMP', charts.MaterialPalette.green.shadeDefault,
          transform: _tempUnit);
      charts.Series<Metric, DateTime> humi = await TimeSeriesAPI.fetchTimeSeries(
          box!, identifier, 'Humidity', 'BOX_${deviceBox}_HUMI', charts.MaterialPalette.blue.shadeDefault);
      charts.Series<Metric, DateTime> vpd = await TimeSeriesAPI.fetchTimeSeries(
          box!, identifier, 'VPD', 'BOX_${deviceBox}_VPD', charts.MaterialPalette.deepOrange.shadeDefault,
          transform: _vpd);

      charts.Series<Metric, DateTime> ventilation = await TimeSeriesAPI.fetchTimeSeries(
          box!, identifier, 'Ventilation', 'BOX_${deviceBox}_BLOWER_DUTY', charts.MaterialPalette.cyan.shadeDefault);
      List<dynamic> timerOutput = await TimeSeriesAPI.fetchMetric(box!, identifier, 'BOX_${deviceBox}_TIMER_OUTPUT');
      List<List<dynamic>> dims = [];
      Module lightModule = await RelDB.get().devicesDAO.getModule(device.id, "led");
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param boxParam = await RelDB.get().devicesDAO.getParam(device.id, "LED_${i}_BOX");
        if (boxParam.ivalue != box!.deviceBox!) {
          continue;
        }
        List<dynamic> dim = await TimeSeriesAPI.fetchMetric(box!, identifier, 'LED_${i}_DIM');
        dims.add(dim);
      }
      List<int> avgDims = TimeSeriesAPI.avgMetrics(dims);
      charts.Series<Metric, DateTime> light = TimeSeriesAPI.toTimeSeries(
          TimeSeriesAPI.multiplyMetric(timerOutput, avgDims), 'Light', charts.MaterialPalette.yellow.shadeDefault);
      charts.Series<Metric, DateTime> co2 = await TimeSeriesAPI.fetchTimeSeries(
          box!, identifier, 'CO2', 'BOX_${deviceBox}_CO2', charts.MaterialPalette.gray.shadeDefault,
          transform: _vpd);
      charts.Series<Metric, DateTime> weight = await TimeSeriesAPI.fetchTimeSeries(
          box!, identifier, 'WEIGHT', 'BOX_${deviceBox}_WEIGHT', charts.MaterialPalette.purple.shadeDefault,
          transform: _vpd);
      return [temp, humi, vpd, light, ventilation, co2, weight];
    }
  }

  List<charts.Series<Metric, DateTime>> _createDummyData() {
    final tempData = List.generate(
        50,
        (index) => Metric(DateTime.now().subtract(Duration(hours: 72)).add(Duration(hours: index * 72 ~/ 50)),
            _tempUnit((cos(index / 100) * 20) + Random().nextInt(7) + 20).toDouble()));
    final humiData = List.generate(
        50,
        (index) => Metric(DateTime.now().subtract(Duration(hours: 72)).add(Duration(hours: index * 72 ~/ 50)),
            ((sin(index / 100) * 5).toInt() + Random().nextInt(3) + 20).toDouble()));
    final vpdData = List.generate(
        50,
        (index) => Metric(DateTime.now().subtract(Duration(hours: 72)).add(Duration(hours: index * 72 ~/ 50)),
            ((sin(index / 100) * 5).toInt() + Random().nextInt(3) + 20).toDouble()));
    final lightData = List.generate(
        50,
        (index) => Metric(DateTime.now().subtract(Duration(hours: 72)).add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20).toDouble()));
    final ventilationData = List.generate(
        50,
        (index) => Metric(DateTime.now().subtract(Duration(hours: 72)).add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20).toDouble()));
    final co2Data = List.generate(
        50,
        (index) => Metric(DateTime.now().subtract(Duration(hours: 72)).add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20).toDouble()));
    final weightData = List.generate(
        50,
        (index) => Metric(DateTime.now().subtract(Duration(hours: 72)).add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20).toDouble()));

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
        id: 'VPD',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: vpdData,
      ),
      charts.Series<Metric, DateTime>(
        id: 'Light',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: lightData,
      ),
      charts.Series<Metric, DateTime>(
        id: 'Ventilation',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: ventilationData,
      ),
      charts.Series<Metric, DateTime>(
        id: 'CO2',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: co2Data,
      ),
      charts.Series<Metric, DateTime>(
        id: 'Weight',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (Metric metric, _) => metric.time,
        measureFn: (Metric metric, _) => metric.metric,
        data: weightData,
      ),
    ];
  }

  double _tempUnit(double temp) {
    if (AppDB().getAppData().freedomUnits == true) {
      return temp * 9 / 5 + 32;
    }
    return temp;
  }

  double _vpd(double vpd) {
    return min(140, max(vpd * 4, 0));
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
