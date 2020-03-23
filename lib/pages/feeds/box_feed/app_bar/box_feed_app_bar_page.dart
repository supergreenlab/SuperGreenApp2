import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:super_green_app/data/backend/time_series/time_series.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/app_bar/box_feed_app_bar_bloc.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class BoxFeedAppBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoxFeedAppBarBloc, BoxFeedAppBarBlocState>(
      builder: (BuildContext context, BoxFeedAppBarBlocState state) {
        Widget body;
        if (state is BoxFeedAppBarBlocStateInit) {
          body = FullscreenLoading(
            title: 'Loading..',
            textColor: Colors.white,
          );
        } else if (state is BoxFeedAppBarBlocStateLoaded) {
          if (state.graphData[0].data.length == 0 &&
              state.graphData[1].data.length == 0 &&
              state.graphData[2].data.length == 0) {
            body = Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white60,
                border: Border.all(color: Color(0xffdedede), width: 1),
              ),
              child: Fullscreen(
                title: 'Not enough data to display graphs yet',
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
        return AnimatedSwitcher(
            duration: Duration(milliseconds: 200), child: body);
      },
    );
  }

  Widget _renderGraphs(
      BuildContext context, BoxFeedAppBarBlocStateLoaded state) {
    Widget graphs = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white70,
        border: Border.all(color: Color(0xffdedede), width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Hero(
              tag: 'graphs',
              child: charts.TimeSeriesChart(state.graphData,
                  animate: false,
                  defaultRenderer: charts.LineRendererConfig(),
                  customSeriesRenderers: [
                    charts.PointRendererConfig(
                        customRendererId: 'customPoint')
                  ]),
            ),
          ),
          Positioned(
              bottom: 0,
              right: -3,
              child: IconButton(
                  icon: Icon(Icons.fullscreen, color: Colors.white70, size: 30),
                  onPressed: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToMetrics(state.box, state.graphData));
                  })),
        ],
      ),
    );
    if (state.graphData[0].data.length < 4 &&
        state.graphData[1].data.length < 4 &&
        state.graphData[2].data.length < 4) {
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
    String tempUnit = AppDB().getAppData().freedomUnits ? '°F' : '°C';
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _renderMetric(
                    Colors.green,
                    'Temp',
                    '${state.graphData[0].data[state.graphData[0].data.length - 1].metric.toInt()}$tempUnit',
                    '${TimeSeries.min(state.graphData[0].data).metric.toInt()}$tempUnit',
                    '${TimeSeries.max(state.graphData[0].data).metric.toInt()}$tempUnit'),
                _renderMetric(
                    Colors.blue,
                    'Humi',
                    '${state.graphData[1].data[state.graphData[1].data.length - 1].metric.toInt()}%',
                    '${TimeSeries.min(state.graphData[1].data).metric.toInt()}%',
                    '${TimeSeries.max(state.graphData[1].data).metric.toInt()}%'),
                _renderMetric(
                    Colors.yellow,
                    'Light',
                    '${state.graphData[2].data[state.graphData[2].data.length - 1].metric.toInt()}%',
                    '${TimeSeries.min(state.graphData[2].data).metric.toInt()}%',
                    '${TimeSeries.max(state.graphData[2].data).metric.toInt()}%'),
              ],
            ),
          ),
          Expanded(
            child: graphs,
          ),
        ],
      ),
    );
  }

  Widget _renderMetric(
      Color color, String name, String value, String min, String max) {
    return Column(
      children: <Widget>[
        Text(name, style: TextStyle(color: Colors.white)),
        Row(
          children: <Widget>[
            Text(value,
                style: TextStyle(
                  color: color,
                  fontSize: 30,
                )),
            Column(
              children: <Widget>[
                Text(max, style: TextStyle(color: Colors.white)),
                Text(min, style: TextStyle(color: Colors.white)),
              ],
            )
          ],
        )
      ],
    );
  }
}
