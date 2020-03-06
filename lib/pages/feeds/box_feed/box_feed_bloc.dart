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
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class BoxFeedBlocEvent extends Equatable {}

class BoxFeedBlocEventLoadBox extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocEventReloadChart extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocEventBoxUpdated extends BoxFeedBlocEvent {
  final Box box;

  BoxFeedBlocEventBoxUpdated(this.box);

  @override
  List<Object> get props => [box];
}

abstract class BoxFeedBlocState extends Equatable {}

abstract class BoxFeedBlocStateBox extends BoxFeedBlocState {
  final Box box;
  final List<charts.Series<Metric, DateTime>> graphData;

  BoxFeedBlocStateBox(this.box, this.graphData);
}

class BoxFeedBlocStateInit extends BoxFeedBlocState {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateNoBox extends BoxFeedBlocState {
  BoxFeedBlocStateNoBox() : super();

  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateBoxLoaded extends BoxFeedBlocStateBox {
  BoxFeedBlocStateBoxLoaded(
      Box box, List<charts.Series<Metric, DateTime>> graphData)
      : super(box, graphData);

  @override
  List<Object> get props => [box, graphData];
}

class BoxFeedBloc extends Bloc<BoxFeedBlocEvent, BoxFeedBlocState> {
  Timer _timer;
  final HomeNavigateToBoxFeedEvent _args;

  final List<charts.Series<Metric, DateTime>> _graphData = [];

  BoxFeedBloc(this._args) {
    this.add(BoxFeedBlocEventLoadBox());
  }

  @override
  BoxFeedBlocState get initialState => BoxFeedBlocStateInit();

  @override
  Stream<BoxFeedBlocState> mapEventToState(BoxFeedBlocEvent event) async* {
    if (event is BoxFeedBlocEventLoadBox) {
      AppDB _db = AppDB();
      Box box = _args.box;
      if (box == null) {
        AppData appData = _db.getAppData();
        if (appData.lastBoxID == null) {
          yield BoxFeedBlocStateNoBox();
          return;
        }
        box = await RelDB.get().boxesDAO.getBox(appData.lastBoxID);
      } else {
        _db.setLastBox(box.id);
      }

      await updateChart(box);
      _timer = Timer.periodic(Duration(seconds: 60), (timer) { this.add(BoxFeedBlocEventReloadChart()); });
      RelDB.get().boxesDAO.watchBox(box.id).listen(_onBoxUpdated);
      yield BoxFeedBlocStateBoxLoaded(box, _graphData);
    } else if (event is BoxFeedBlocEventBoxUpdated) {
      yield BoxFeedBlocStateBoxLoaded(event.box, _graphData);
    } else if (event is BoxFeedBlocEventReloadChart) {
      yield BoxFeedBlocStateBoxLoaded((this.state as BoxFeedBlocStateBoxLoaded).box, _graphData);
    }
  }

  Future updateChart(box) async {
    if (box.device == null) {
      _graphData.addAll(_createDummyData());
    } else {
      Device device = await RelDB.get().devicesDAO.getDevice(box.device);
      String identifier = device.identifier;
      int deviceBox = box.deviceBox;
      charts.Series<Metric, DateTime> temp = await getMetricsName(identifier,
          'BOX_${deviceBox}_TEMP', charts.MaterialPalette.green.shadeDefault);
      charts.Series<Metric, DateTime> humi = await getMetricsName(identifier,
          'BOX_${deviceBox}_HUMI', charts.MaterialPalette.blue.shadeDefault);
      List<dynamic> duty =
          await getMetricRequest(identifier, 'BOX_${deviceBox}_TIMER_OUTPUT');
      List<int> dims = [];
      int n = 0;
      Module lightModule =
          await RelDB.get().devicesDAO.getModule(device.id, "led");
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param boxParam =
            await RelDB.get().devicesDAO.getParam(device.id, "LED_${i}_BOX");
        if (boxParam.ivalue != box.deviceBox) {
          continue;
        }
        List<dynamic> dim = await getMetricRequest(identifier, 'LED_${i}_DIM');
        for (int i = 0; i < dim.length; ++i) {
          int d = dim[i][1];
          if (dims.length < i + 1) {
            dims.add(d);
          } else {
            dims.setAll(i, [dims[i] + d]);
          }
        }
        ++n;
      }
      dims = dims.map<int>((a) => a ~/ n).toList();
      int i = 0;
      charts.Series<Metric, DateTime> light = getTimeSeries(
          duty.map<dynamic>((d) => [d[0], d[1] * dims[i++] / 100]).toList(),
          'Light',
          charts.MaterialPalette.yellow.shadeDefault);
      _graphData.addAll([temp, humi, light]);
    }
  }

  Future<charts.Series<Metric, DateTime>> getMetricsName(
      String controllerID, String name, charts.Color color) async {
    List<dynamic> values = await getMetricRequest(controllerID, name);
    return getTimeSeries(values, 'Temperature', color);
  }

  Future<List<dynamic>> getMetricRequest(
      String controllerID, String name) async {
    Response resp = await get(
        'https://api.supergreenlab.com/metrics?cid=$controllerID&q=$name&t=72&n=50');
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return data['metrics'];
  }

  charts.Series<Metric, DateTime> getTimeSeries(
      List<dynamic> values, String graphID, charts.Color color) {
    return charts.Series<Metric, DateTime>(
      id: graphID,
      strokeWidthPxFn: (_, __) => 3,
      colorFn: (_, __) => color,
      domainFn: (Metric metric, _) => metric.time,
      measureFn: (Metric metric, _) => metric.metric,
      data: values.map<Metric>((v) {
        return Metric(
            DateTime.fromMillisecondsSinceEpoch(v[0] * 1000), v[1].toDouble());
      }).toList(),
    );
  }

  void _onBoxUpdated(Box box) {
    add(BoxFeedBlocEventBoxUpdated(box));
  }

  List<charts.Series<Metric, DateTime>> _createDummyData() {
    final tempData = List.generate(
        50,
        (index) => Metric(
            DateTime.now()
                .subtract(Duration(hours: 72))
                .add(Duration(hours: index * 72 ~/ 50)),
            ((cos(index / 100) * 20).toInt() + Random().nextInt(7) + 20)
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
  @override
  Future<void> close() async {
    _timer.cancel();
    super.close();
  }
}

class Metric {
  final DateTime time;
  final double metric;

  Metric(this.time, this.metric);
}
