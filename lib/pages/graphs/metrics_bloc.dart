import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/backend/time_series/time_series.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class MetricsBlocEvent extends Equatable {}

class MetricsBlocEventLoadChart extends MetricsBlocEvent {
  @override
  List<Object> get props => [];
}

class MetricsBlocEventReloadChart extends MetricsBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  @override
  List<Object> get props => [rand];
}

class MetricsBlocState extends Equatable {
  final List<charts.Series<Metric, DateTime>> graphData;

  MetricsBlocState(this.graphData);

  @override
  List<Object> get props => [graphData];
}

class MetricsBlocStateInit extends MetricsBlocState {
  MetricsBlocStateInit(List<charts.Series<Metric, DateTime>> graphData) : super(graphData);
}

class MetricsBlocStateLoaded extends MetricsBlocState {
  MetricsBlocStateLoaded(List<charts.Series<Metric, DateTime>> graphData) : super(graphData);
}

class MetricsBloc extends Bloc<MetricsBlocEvent, MetricsBlocState> {
  final MainNavigateToMetrics _args;

  Timer _timer;

  MetricsBloc(this._args) {
    add(MetricsBlocEventLoadChart());
  }

  @override
  get initialState => MetricsBlocStateInit(_args.graphData);

  @override
  Stream<MetricsBlocState> mapEventToState(MetricsBlocEvent event) async* {
    if (event is MetricsBlocEventLoadChart) {
      List<charts.Series<Metric, DateTime>> graphData =
          await updateChart(_args.box);
      yield MetricsBlocStateLoaded(graphData);
      _timer = Timer.periodic(Duration(seconds: 60), (timer) {
        this.add(MetricsBlocEventReloadChart());
      });
    } else if (event is MetricsBlocEventReloadChart) {
      List<charts.Series<Metric, DateTime>> graphData =
          await updateChart(_args.box);
      yield MetricsBlocStateLoaded(graphData);
    }
  }

  Future<List<charts.Series<Metric, DateTime>>> updateChart(Box box) async {
    Device device = await RelDB.get().devicesDAO.getDevice(box.device);
    String identifier = device.identifier;
    int deviceBox = box.deviceBox;
    charts.Series<Metric, DateTime> temp = await TimeSeries.fetchTimeSeries(
        box,
        identifier,
        'Temperature',
        'BOX_${deviceBox}_TEMP',
        charts.MaterialPalette.green.shadeDefault,
        transform: _tempUnit);
    charts.Series<Metric, DateTime> humi = await TimeSeries.fetchTimeSeries(
        box,
        identifier,
        'Humidity',
        'BOX_${deviceBox}_HUMI',
        charts.MaterialPalette.blue.shadeDefault);
    List<dynamic> timerOutput = await TimeSeries.fetchMetric(
        box, identifier, 'BOX_${deviceBox}_TIMER_OUTPUT');
    List<List<dynamic>> dims = [];
    Module lightModule =
        await RelDB.get().devicesDAO.getModule(device.id, "led");
    for (int i = 0; i < lightModule.arrayLen; ++i) {
      Param boxParam =
          await RelDB.get().devicesDAO.getParam(device.id, "LED_${i}_BOX");
      if (boxParam.ivalue != box.deviceBox) {
        continue;
      }
      List<dynamic> dim =
          await TimeSeries.fetchMetric(box, identifier, 'LED_${i}_DIM');
      dims.add(dim);
    }
    List<int> avgDims = TimeSeries.avgMetrics(dims);
    charts.Series<Metric, DateTime> light = TimeSeries.toTimeSeries(
        TimeSeries.multiplyMetric(timerOutput, avgDims),
        'Light',
        charts.MaterialPalette.yellow.shadeDefault);
    return [temp, humi, light];
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
