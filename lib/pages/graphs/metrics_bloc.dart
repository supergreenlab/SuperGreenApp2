import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/backend/time_series/time_series_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class MetricsBlocEvent extends Equatable {}

class MetricsBlocEventChartParams extends MetricsBlocEvent {
  final bool showTemp;
  final bool showHumi;
  final bool showLight;
  final int fromTime;
  final int toTime;

  MetricsBlocEventChartParams(
      this.showTemp, this.showHumi, this.showLight, this.fromTime, this.toTime);

  @override
  List<Object> get props => [showTemp, showHumi, showLight];
}

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
  MetricsBlocStateInit(List<charts.Series<Metric, DateTime>> graphData)
      : super(graphData);
}

class MetricsBlocStateLoaded extends MetricsBlocState {
  final List<FeedEntry> entries;

  MetricsBlocStateLoaded(
      List<charts.Series<Metric, DateTime>> graphData, this.entries)
      : super(graphData);
}

class MetricsBloc extends Bloc<MetricsBlocEvent, MetricsBlocState> {
  bool showTemp = true;
  bool showHumi = true;
  bool showLight = true;
  int fromTime =
      DateTime.now().add(Duration(hours: -72)).millisecondsSinceEpoch ~/ 1000;
  int toTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  List<FeedEntry> _events;

  final MainNavigateToMetrics args;

  Timer _timer;

  MetricsBloc(this.args) {
    add(MetricsBlocEventLoadChart());
  }

  @override
  get initialState => MetricsBlocStateInit(args.graphData);

  @override
  Stream<MetricsBlocState> mapEventToState(MetricsBlocEvent event) async* {
    if (event is MetricsBlocEventLoadChart) {
      List<charts.Series<Metric, DateTime>> graphData =
          await updateChart(args.plant);
      _events =
          await RelDB.get().feedsDAO.getEnvironmentFeedEntries(args.plant.feed);
      yield MetricsBlocStateLoaded(graphData, _events);
      _timer = Timer.periodic(Duration(seconds: 60), (timer) {
        this.add(MetricsBlocEventReloadChart());
      });
    } else if (event is MetricsBlocEventReloadChart) {
      List<charts.Series<Metric, DateTime>> graphData =
          await updateChart(args.plant);
      yield MetricsBlocStateLoaded(graphData, _events);
    } else if (event is MetricsBlocEventChartParams) {
      showTemp = event.showTemp;
      showHumi = event.showHumi;
      showLight = event.showLight;
      fromTime = event.fromTime;
      toTime = event.toTime;
      List<charts.Series<Metric, DateTime>> graphData =
          await updateChart(args.plant);
      yield MetricsBlocStateLoaded(graphData, _events);
    }
  }

  Future<List<charts.Series<Metric, DateTime>>> updateChart(Plant plant) async {
    final db = RelDB.get();
    Box box = await db.plantsDAO.getBox(plant.box);
    Device device = await db.devicesDAO.getDevice(box.device);
    String identifier = device.identifier;
    int deviceBox = box.deviceBox;
    List<charts.Series<Metric, DateTime>> chs = [];
    if (showTemp) {
      chs.add(await getTempSeries(plant, identifier, deviceBox));
    }
    if (showHumi) {
      chs.add(await getHumiSeries(plant, identifier, deviceBox));
    }
    if (showLight) {
      chs.add(await getLightSeries(plant, device, identifier, deviceBox));
    }
    return chs;
  }

  Future<charts.Series<Metric, DateTime>> getTempSeries(
      Plant plant, String identifier, int deviceBox) async {
    return await TimeSeriesAPI.fetchTimeSeries(plant, identifier, 'Temperature',
        'BOX_${deviceBox}_TEMP', charts.MaterialPalette.green.shadeDefault,
        transform: _tempUnit);
  }

  Future<charts.Series<Metric, DateTime>> getHumiSeries(
      Plant plant, String identifier, int deviceBox) async {
    return await TimeSeriesAPI.fetchTimeSeries(plant, identifier, 'Humidity',
        'BOX_${deviceBox}_HUMI', charts.MaterialPalette.blue.shadeDefault);
  }

  Future<charts.Series<Metric, DateTime>> getLightSeries(
      Plant plant, Device device, String identifier, int deviceBox) async {
    final db = RelDB.get();
    Box box = await db.plantsDAO.getBox(plant.box);
    List<dynamic> timerOutput = await TimeSeriesAPI.fetchMetric(
        plant, identifier, 'BOX_${deviceBox}_TIMER_OUTPUT');
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
          await TimeSeriesAPI.fetchMetric(plant, identifier, 'LED_${i}_DIM');
      dims.add(dim);
    }
    List<int> avgDims = TimeSeriesAPI.avgMetrics(dims);
    return TimeSeriesAPI.toTimeSeries(
        TimeSeriesAPI.multiplyMetric(timerOutput, avgDims),
        'Light',
        charts.MaterialPalette.yellow.shadeDefault);
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
