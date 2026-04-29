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
import 'package:flutter/material.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/time_series/time_series_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

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
  final List<dynamic> version;
  final List<ChartSeries> graphData;
  final Plant? plant;
  final Box box;

  PlantFeedAppBarBlocStateLoaded(
      this.version, this.graphData, this.plant, this.box);

  @override
  List<Object?> get props => [version, graphData, plant, box];
}

class BoxAppBarMetricsBloc
    extends LegacyBloc<PlantFeedAppBarBlocEvent, PlantFeedAppBarBlocState> {
  Timer? _timer;
  final Plant? plant;
  Box? box;

  late List<dynamic> version;

  BoxAppBarMetricsBloc({this.plant, this.box})
      : super(PlantFeedAppBarBlocStateInit()) {
    add(PlantFeedAppBarBlocEventLoadChart());
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      this.add(PlantFeedAppBarBlocEventReloadChart());
    });
  }

  @override
  Stream<PlantFeedAppBarBlocState> mapEventToState(
      PlantFeedAppBarBlocEvent event) async* {
    if (event is PlantFeedAppBarBlocEventLoadChart) {
      try {
        if (box == null) {
          final db = RelDB.get();
          box = await db.plantsDAO.getBox(plant!.box);
        }
        List<ChartSeries> graphData = await updateChart();
        yield PlantFeedAppBarBlocStateLoaded(version, graphData, plant, box!);
      } catch (e) {
        print(e);
      }
    } else if (event is PlantFeedAppBarBlocEventReloadChart) {
      try {
        List<ChartSeries> graphData = await updateChart();
        yield PlantFeedAppBarBlocStateLoaded(version, graphData, plant, box!);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List<ChartSeries>> updateChart() async {
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
      version = await TimeSeriesAPI.fetchMetric(
          box!, identifier, 'OTA_TIMESTAMP', 0, 10000000000);
      ChartSeries temp = await TimeSeriesAPI.fetchTimeSeries(box!, identifier,
          'Temperature', 'BOX_${deviceBox}_TEMP', Colors.green, 0, 50,
          transform: _tempUnit);
      ChartSeries humi = await TimeSeriesAPI.fetchTimeSeries(box!, identifier,
          'Humidity', 'BOX_${deviceBox}_HUMI', Colors.blue, 0, 100);
      ChartSeries vpd = await TimeSeriesAPI.fetchTimeSeries(box!, identifier,
          'VPD', 'BOX_${deviceBox}_VPD', Colors.deepOrange, 0, 254,
          transform: _vpd);

      ChartSeries ventilation = await TimeSeriesAPI.fetchTimeSeries(
          box!,
          identifier,
          'Ventilation',
          'BOX_${deviceBox}_BLOWER_DUTY',
          Colors.cyan,
          0,
          100);

      late ChartSeries light;
      try {
        List<dynamic> timerOutput = await TimeSeriesAPI.fetchMetric(
            box!, identifier, 'BOX_${deviceBox}_TIMER_OUTPUT', 0, 100);
        List<List<dynamic>> dims = [];
        Module lightModule =
            await RelDB.get().devicesDAO.getModule(device.id, "led");
        for (int i = 0; i < lightModule.arrayLen; ++i) {
          Param boxParam =
              await RelDB.get().devicesDAO.getParam(device.id, "LED_${i}_BOX");
          if (boxParam.ivalue != box!.deviceBox!) {
            continue;
          }
          List<dynamic> dim = await TimeSeriesAPI.fetchMetric(
              box!, identifier, 'LED_${i}_DIM', 0, 100);
          dims.add(dim);
        }
        List<int> avgDims = TimeSeriesAPI.avgMetrics(dims);
        light = TimeSeriesAPI.toTimeSeries(
            TimeSeriesAPI.multiplyMetric(timerOutput, avgDims),
            'Light',
            Colors.yellow.shade700);
      } catch (e) {
        light = TimeSeriesAPI.toTimeSeries([], 'Light', Colors.yellow.shade700);
      }

      ChartSeries co2 = await TimeSeriesAPI.fetchTimeSeries(box!, identifier,
          'CO2', 'BOX_${deviceBox}_CO2', Colors.grey, 0, 100000,
          transform: _co2);
      ChartSeries weight = await TimeSeriesAPI.fetchTimeSeries(box!, identifier,
          'Weight', 'BOX_${deviceBox}_WEIGHT', Colors.purple, 0, 100000,
          transform: _weight);
      return [temp, humi, vpd, light, ventilation, co2, weight];
    }
  }

  List<ChartSeries> _createDummyData() {
    final tempData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            _tempUnit((cos(index / 100) * 20) + Random().nextInt(7) + 20, index)
                .toDouble()));
    final humiData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            ((sin(index / 100) * 5).toInt() + Random().nextInt(3) + 20)
                .toDouble()));
    final vpdData = List.generate(
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
    final ventilationData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20)
                .toDouble()));
    final co2Data = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20)
                .toDouble()));
    final weightData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20)
                .toDouble()));

    return [
      ChartSeries(id: 'Temperature', color: Colors.green, data: tempData),
      ChartSeries(id: 'Humidity', color: Colors.blue, data: humiData),
      ChartSeries(id: 'VPD', color: Colors.deepOrange, data: vpdData),
      ChartSeries(id: 'Light', color: Colors.yellow.shade700, data: lightData),
      ChartSeries(id: 'Ventilation', color: Colors.cyan, data: ventilationData),
      ChartSeries(id: 'CO2', color: Colors.grey, data: co2Data),
      ChartSeries(id: 'Weight', color: Colors.purple, data: weightData),
    ];
  }

  double _tempUnit(double temp, int i) {
    if (AppDB().getUserSettings().freedomUnits == true) {
      return temp * 9 / 5 + 32;
    }
    return temp;
  }

  double _vpd(double vpd, int i) {
    return min(
        140,
        max(
            version[i][1] != 0 && version[i][1] < 1700000000
                ? vpd * 4
                : vpd * 0.4,
            0));
  }

  double _weight(double weight, int i) {
    if (AppDB().getUserSettings().freedomUnits == true) {
      return weight / 1000 * 2.20462;
    }
    return weight / 1000;
  }

  double _co2(double co2, int i) {
    return co2 / 20;
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
