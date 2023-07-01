import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:super_green_app/data/api/backend/time_series/time_series_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/graphs/box_app_bar_metrics_bloc.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

const minCharPoints = 10;

class BoxAppBarMetricsPage extends StatefulWidget {
  @override
  _BoxAppBarMetricsPageState createState() => _BoxAppBarMetricsPageState();
}

class _BoxAppBarMetricsPageState extends State<BoxAppBarMetricsPage> {
  int? selectedGraphIndex;

  final ScrollController _scrollController = ScrollController();

  final Map<int, bool> disabledGraphs = {};

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoxAppBarMetricsBloc, PlantFeedAppBarBlocState>(
      listener: (BuildContext context, PlantFeedAppBarBlocState state) {
        if (state is PlantFeedAppBarBlocStateLoaded) {
          Timer(Duration(milliseconds: 500), () {
            if (_scrollController.hasClients == false) {
              return;
            }
            _scrollController.animateTo(50, duration: Duration(seconds: 15), curve: Curves.linear);
          });
        }
      },
      child: BlocBuilder<BoxAppBarMetricsBloc, PlantFeedAppBarBlocState>(
        builder: (BuildContext context, PlantFeedAppBarBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );
          if (state is PlantFeedAppBarBlocStateInit) {
            body = FullscreenLoading(
              title: 'Loading..',
              textColor: Color(0xFF494949),
            );
          } else if (state is PlantFeedAppBarBlocStateLoaded) {
            if (state.graphData[0].data.length == 0 &&
                state.graphData[1].data.length == 0 &&
                state.graphData[2].data.length == 0 &&
                state.graphData[3].data.length == 0) {
              body = Fullscreen(
                title: 'Not enough data to display metrics yet',
                subtitle: 'try again in a few minutes',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                child: Container(),
                childFirst: false,
              );
            } else {
              body = _renderGraphs(context, state);
            }
          }
          return AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body);
        },
      ),
    );
  }

  Widget _renderGraphs(BuildContext context, PlantFeedAppBarBlocStateLoaded state) {
    String tempUnit = AppDB().getAppData().freedomUnits ? '°F' : '°C';
    DateTime metricDate = state.graphData[0].data[selectedGraphIndex ?? state.graphData[0].data.length - 1].time;
    String weightUnit = AppDB().getAppData().freedomUnits ? 'lb' : 'kg';
    String format = AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy HH:mm' : 'dd/MM/yyyy HH:mm';
    Widget dateText = Text('${DateFormat(format).format(metricDate)}',
        style: TextStyle(color: Color(0xFF494949), fontSize: 15, fontWeight: FontWeight.bold));
    List<charts.LineAnnotationSegment<Object>>? annotations;
    if (selectedGraphIndex != null) {
      annotations = [
        charts.LineAnnotationSegment(metricDate, charts.RangeAnnotationAxisType.domain,
            labelStyleSpec: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            color: charts.MaterialPalette.gray.shade500)
      ];
      dateText = Row(
        children: <Widget>[
          dateText,
          Expanded(
            child: Text(
              'tap to reset',
              style: TextStyle(color: Color(0xFF494949), decoration: TextDecoration.underline),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
    }
    Widget graphs = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white70,
        border: Border.all(color: Color(0xffdedede), width: 1),
      ),
      child: /*Stack(
        children: [*/
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: charts.TimeSeriesChart(
          state.graphData.where((gd) => !(disabledGraphs[state.graphData.indexOf(gd)] ?? false)).toList(),
          animate: false,
          behaviors: selectedGraphIndex != null
              ? [
                  charts.RangeAnnotation(annotations!),
                ]
              : null,
          customSeriesRenderers: [charts.PointRendererConfig(customRendererId: 'customPoint')],
          selectionModels: [
            new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: (charts.SelectionModel model) {
                  if (!model.hasAnySelection) {
                    return;
                  }
                  setState(() {
                    selectedGraphIndex = model.selectedDatum[0].index;
                  });
                }),
          ],
        ),
      ),
    );
    if (state.graphData[0].data.length < minCharPoints &&
        state.graphData[1].data.length < minCharPoints &&
        state.graphData[2].data.length < minCharPoints &&
        state.graphData[3].data.length < minCharPoints) {
      graphs = Stack(children: [
        graphs,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white60,
            border: Border.all(color: Color(0xffdedede), width: 1),
          ),
          child: Fullscreen(
            title: 'Still not enough data\nto show a graph',
            subtitle: 'try again in a few hours',
            fontSize: 20,
            fontWeight: FontWeight.normal,
            child: Container(),
            childFirst: false,
          ),
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 0, right: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                selectedGraphIndex = null;
              });
            },
            child: Padding(padding: const EdgeInsets.all(6.0), child: dateText),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Container(
              height: 60,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(width: 4),
                    _renderMetric(
                        Colors.green,
                        'Temp',
                        '${state.graphData[0].data[selectedGraphIndex ?? state.graphData[0].data.length - 1].metric.toInt()}$tempUnit',
                        '${TimeSeriesAPI.min(state.graphData[0].data).metric.toInt()}$tempUnit',
                        '${TimeSeriesAPI.max(state.graphData[0].data).metric.toInt()}$tempUnit', () {
                      setState(() {
                        disabledGraphs[0] = !(disabledGraphs[0] ?? false);
                      });
                    }, disabledGraphs[0] ?? false),
                    _renderMetric(
                        Colors.blue,
                        'Humi',
                        '${state.graphData[1].data[selectedGraphIndex ?? state.graphData[1].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[1].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[1].data).metric.toInt()}%', () {
                      setState(() {
                        disabledGraphs[1] = !(disabledGraphs[1] ?? false);
                      });
                    }, disabledGraphs[1] ?? false),
                    _renderMetric(
                        Colors.orange,
                        'VPD',
                        '${state.graphData[2].data[selectedGraphIndex ?? state.graphData[2].data.length - 1].metric / 40}',
                        '${TimeSeriesAPI.min(state.graphData[2].data).metric / 40}',
                        '${TimeSeriesAPI.max(state.graphData[2].data).metric / 40}', () {
                      setState(() {
                        disabledGraphs[2] = !(disabledGraphs[2] ?? false);
                      });
                    }, disabledGraphs[2] ?? false),
                    _renderMetric(
                        Colors.cyan,
                        'Ventilation',
                        '${state.graphData[4].data[selectedGraphIndex ?? state.graphData[4].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[4].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[4].data).metric.toInt()}%', () {
                      setState(() {
                        disabledGraphs[4] = !(disabledGraphs[4] ?? false);
                      });
                    }, disabledGraphs[4] ?? false),
                    state.graphData[3].data.length > 0 ? _renderMetric(
                        Color(0xffB3B634),
                        'Light',
                        '${state.graphData[3].data[selectedGraphIndex ?? state.graphData[3].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[3].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[3].data).metric.toInt()}%', () {
                      setState(() {
                        disabledGraphs[3] = !(disabledGraphs[3] ?? false);
                      });
                    }, disabledGraphs[3] ?? false) : _renderMetric(
                        Color(0xffB3B634),
                        'Light',
                        '0',
                        'n/a%',
                        'n/a%', () {
                      setState(() {
                        disabledGraphs[3] = !(disabledGraphs[3] ?? false);
                      });
                    }, disabledGraphs[3] ?? false),
                    _renderMetric(
                        Color(0xff595959),
                        'CO2',
                        '${state.graphData[5].data[selectedGraphIndex ?? state.graphData[5].data.length - 1].metric.toInt()}',
                        '${TimeSeriesAPI.min(state.graphData[5].data).metric.toInt()}',
                        '${TimeSeriesAPI.max(state.graphData[5].data).metric.toInt()}', () {
                      setState(() {
                        disabledGraphs[5] = !(disabledGraphs[5] ?? false);
                      });
                    }, disabledGraphs[5] ?? false),
                    _renderMetric(
                        Color(0xFF483581),
                        'Weight ($weightUnit)',
                        '${state.graphData[6].data[selectedGraphIndex ?? state.graphData[6].data.length - 1].metric.toStringAsFixed(3)}',
                        '${TimeSeriesAPI.min(state.graphData[6].data).metric.toStringAsFixed(3)}',
                        '${TimeSeriesAPI.max(state.graphData[6].data).metric.toStringAsFixed(3)}', () {
                      setState(() {
                        disabledGraphs[6] = !(disabledGraphs[6] ?? false);
                      });
                    }, disabledGraphs[6] ?? false),
                    Container(width: 4),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: graphs,
          ),
          Text("*VPD chart is experimental, please report any inconsistencies",
              style: TextStyle(fontSize: 9, color: Color(0xFF494949))),
        ],
      ),
    );
  }

  Widget _renderMetric(
      Color color, String name, String value, String min, String max, void Function() onTap, bool disabled) {
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Text(name, style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.bold)),
              Row(
                children: <Widget>[
                  Text(value == "0" ? "N/A" : value,
                      style: TextStyle(
                        color: color,
                        fontSize: value == "0" ? 20 : 30,
                        fontWeight: FontWeight.bold,
                      )),
                  value != "0"
                      ? Column(
                          children: <Widget>[
                            Text(max, style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.w300)),
                            Text(min, style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.w300)),
                          ],
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
