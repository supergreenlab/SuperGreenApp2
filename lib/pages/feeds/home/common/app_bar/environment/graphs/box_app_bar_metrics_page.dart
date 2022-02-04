import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
              textColor: Colors.white,
            );
          } else if (state is PlantFeedAppBarBlocStateLoaded) {
            if (state.graphData[0].data.length == 0 &&
                state.graphData[1].data.length == 0 &&
                state.graphData[2].data.length == 0 &&
                state.graphData[3].data.length == 0) {
              body = Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white60,
                  border: Border.all(color: Color(0xffdedede), width: 1),
                ),
                child: Fullscreen(
                  title: 'Not enough data to display metrics yet',
                  subtitle: 'try again in a few minutes',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  child: Container(),
                  childFirst: false,
                ),
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
    String format = AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy HH:mm' : 'dd/MM/yyyy HH:mm';
    Widget dateText = Text('${DateFormat(format).format(metricDate)}',
        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold));
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
              style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
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
        child: Hero(
          tag: 'graphs',
          child: charts.TimeSeriesChart(
            state.graphData,
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
      ),
      /*Positioned(
              bottom: 0,
              right: -3,
              child: IconButton(
                  icon: Icon(Icons.fullscreen, color: Colors.white70, size: 30),
                  onPressed: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToMetrics(state.graphData, plant: state.plant, box: state.box));
                  })),*/
      // ],
      // ),
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
                        '${TimeSeriesAPI.max(state.graphData[0].data).metric.toInt()}$tempUnit'),
                    _renderMetric(
                        Colors.blue,
                        'Humi',
                        '${state.graphData[1].data[selectedGraphIndex ?? state.graphData[1].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[1].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[1].data).metric.toInt()}%'),
                    _renderMetric(
                        Colors.orange,
                        'VPD',
                        '${state.graphData[2].data[selectedGraphIndex ?? state.graphData[2].data.length - 1].metric / 40}',
                        '${TimeSeriesAPI.min(state.graphData[2].data).metric / 40}',
                        '${TimeSeriesAPI.max(state.graphData[2].data).metric / 40}'),
                    _renderMetric(
                        Colors.cyan,
                        'Ventilation',
                        '${state.graphData[4].data[selectedGraphIndex ?? state.graphData[4].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[4].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[4].data).metric.toInt()}%'),
                    _renderMetric(
                        Colors.yellow,
                        'Light',
                        '${state.graphData[3].data[selectedGraphIndex ?? state.graphData[3].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[3].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[3].data).metric.toInt()}%'),
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
              style: TextStyle(fontSize: 9, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _renderMetric(Color color, String name, String value, String min, String max) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Text(name, style: TextStyle(color: Colors.white)),
          Row(
            children: <Widget>[
              Text(value,
                  style: TextStyle(
                    color: color,
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  )),
              Column(
                children: <Widget>[
                  Text(max, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                  Text(min, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
