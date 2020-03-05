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

class BoxFeedBlocEventBoxUpdated extends BoxFeedBlocEvent {
  final Box box;

  BoxFeedBlocEventBoxUpdated(this.box);

  @override
  List<Object> get props => [box];
}

abstract class BoxFeedBlocState extends Equatable {}

abstract class BoxFeedBlocStateBox extends BoxFeedBlocState {
  final Box box;
  final List<charts.Series<Metric, int>> graphData;

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
  BoxFeedBlocStateBoxLoaded(Box box, List<charts.Series<Metric, int>> graphData)
      : super(box, graphData);

  @override
  List<Object> get props => [box, graphData];
}

class BoxFeedBloc extends Bloc<BoxFeedBlocEvent, BoxFeedBlocState> {
  final HomeNavigateToBoxFeedEvent _args;
  final List<charts.Series<Metric, int>> _graphData = [];

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
      if (box.device == null) {
        _graphData.addAll(_createDummyData());
      } else {
        Device device = await RelDB.get().devicesDAO.getDevice(box.device);
        charts.Series<Metric, int> temp = await getMetricsName(
            device.identifier,
            'BOX_${box.deviceBox}_TEMP',
            charts.MaterialPalette.green.shadeDefault);
        charts.Series<Metric, int> humi = await getMetricsName(
            device.identifier,
            'BOX_${box.deviceBox}_HUMI',
            charts.MaterialPalette.blue.shadeDefault);
        charts.Series<Metric, int> light = await getMetricsName(
            device.identifier,
            'BOX_${box.deviceBox}_TIMER_OUTPUT',
            charts.MaterialPalette.yellow.shadeDefault);
        _graphData.addAll([temp, humi, light]);
      }
      RelDB.get().boxesDAO.watchBox(box.id).listen(_onBoxUpdated);
    } else if (event is BoxFeedBlocEventBoxUpdated) {
      yield BoxFeedBlocStateBoxLoaded(event.box, _graphData);
    }
  }

  Future<charts.Series<Metric, int>> getMetricsName(
      String controllerID, String name, charts.Color color) async {
    Response resp = await get(
        'https://api.supergreenlab.com/metrics?cid=$controllerID&q=$name&t=72&n=50');
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return charts.Series<Metric, int>(
      id: 'Temperature',
      strokeWidthPxFn: (_, __) => 3,
      colorFn: (_, __) => color,
      domainFn: (Metric metric, _) => metric.year,
      measureFn: (Metric metric, _) => metric.metric,
      data: data['metrics'].map<Metric>((values) {
        return Metric(values[0], values[1].toDouble());
      }).toList(),
    );
  }

  void _onBoxUpdated(Box box) {
    add(BoxFeedBlocEventBoxUpdated(box));
  }

  List<charts.Series<Metric, int>> _createDummyData() {
    final tempData = List.generate(
        50,
        (index) => Metric(
            index,
            ((cos(index / 100) * 20).toInt() + Random().nextInt(7) + 20)
                .toDouble()));
    final humiData = List.generate(
        50,
        (index) => Metric(
            index,
            ((sin(index / 100) * 5).toInt() + Random().nextInt(3) + 20)
                .toDouble()));
    final lightData = List.generate(
        50,
        (index) => Metric(
            index,
            ((cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20)
                .toDouble()));

    return [
      charts.Series<Metric, int>(
        id: 'Temperature',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Metric metric, _) => metric.year,
        measureFn: (Metric metric, _) => metric.metric,
        data: tempData,
      ),
      charts.Series<Metric, int>(
        id: 'Humidity',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Metric metric, _) => metric.year,
        measureFn: (Metric metric, _) => metric.metric,
        data: humiData,
      ),
      charts.Series<Metric, int>(
        id: 'Light',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Metric metric, _) => metric.year,
        measureFn: (Metric metric, _) => metric.metric,
        data: lightData,
      ),
    ];
  }
}

class Metric {
  final int year;
  final double metric;

  Metric(this.year, this.metric);
}
