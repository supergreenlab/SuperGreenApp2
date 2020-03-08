import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class BoxFeedAppBarBlocEvent extends Equatable {}

class BoxFeedAppBarBlocEventLoadChart extends BoxFeedAppBarBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedAppBarBlocEventReloadChart extends BoxFeedAppBarBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  @override
  List<Object> get props => [rand];
}

abstract class BoxFeedAppBarBlocState extends Equatable {}

class BoxFeedAppBarBlocStateInit extends BoxFeedAppBarBlocState {
  @override
  List<Object> get props => [];
}

class BoxFeedAppBarBlocStateLoaded extends BoxFeedAppBarBlocState {
  final List<charts.Series<Metric, DateTime>> graphData;

  BoxFeedAppBarBlocStateLoaded(this.graphData);

  @override
  List<Object> get props => [];
}

class BoxFeedAppBarBloc
    extends Bloc<BoxFeedAppBarBlocEvent, BoxFeedAppBarBlocState> {
  Timer _timer;
  final Box box;

  BoxFeedAppBarBloc(this.box) {
    add(BoxFeedAppBarBlocEventLoadChart());
  }

  @override
  BoxFeedAppBarBlocState get initialState => BoxFeedAppBarBlocStateInit();

  @override
  Stream<BoxFeedAppBarBlocState> mapEventToState(
      BoxFeedAppBarBlocEvent event) async* {
    if (event is BoxFeedAppBarBlocEventLoadChart) {
      List<charts.Series<Metric, DateTime>> graphData = await updateChart(box);
      yield BoxFeedAppBarBlocStateLoaded(graphData);
      if (event is BoxFeedAppBarBlocEventLoadChart) {
        _timer = Timer.periodic(Duration(seconds: 60), (timer) {
          this.add(BoxFeedAppBarBlocEventReloadChart());
        });
      }
    } else if (event is BoxFeedAppBarBlocEventReloadChart) {
      List<charts.Series<Metric, DateTime>> graphData = await updateChart(box);
      yield BoxFeedAppBarBlocStateLoaded(graphData);
    }
  }

  Future updateChart(Box box) async {
    if (box.device == null) {
      await Future.delayed(Duration(milliseconds: 2000));
      return _createDummyData();
    } else {
      Device device = await RelDB.get().devicesDAO.getDevice(box.device);
      String identifier = device.identifier;
      int deviceBox = box.deviceBox;
      charts.Series<Metric, DateTime> temp = await getMetricsName(
          identifier,
          'Temperature',
          'BOX_${deviceBox}_TEMP',
          charts.MaterialPalette.green.shadeDefault);
      charts.Series<Metric, DateTime> humi = await getMetricsName(
          identifier,
          'Humidity',
          'BOX_${deviceBox}_HUMI',
          charts.MaterialPalette.blue.shadeDefault);
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
          if (i > dims.length - 1) {
            dims.add(d);
          } else {
            dims.setAll(i, [dims[i] + d]);
          }
        }
        ++n;
      }
      if (n > 0) {
        dims = dims.map<int>((a) => a ~/ n).toList();
      }
      int i = 0;
      charts.Series<Metric, DateTime> light = getTimeSeries(
          duty
              .map<dynamic>(
                  (d) => [d[0], n == 0 ? d[1] : d[1] * dims[i++] / 100])
              .toList(),
          'Light',
          charts.MaterialPalette.yellow.shadeDefault);
      return [temp, humi, light];
    }
  }

  Future<charts.Series<Metric, DateTime>> getMetricsName(String controllerID,
      String graphID, String name, charts.Color color) async {
    List<dynamic> values = await getMetricRequest(controllerID, name);
    return getTimeSeries(values, graphID, color);
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
    if (_timer != null) {
      _timer.cancel();
    }
    return super.close();
  }
}

class Metric {
  final DateTime time;
  final double metric;

  Metric(this.time, this.metric);
}
