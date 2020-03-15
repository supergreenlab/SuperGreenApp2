import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
          body = FullscreenLoading(title: 'Loading..');
        } else if (state is BoxFeedAppBarBlocStateLoaded) {
          body = _renderGraphs(context, state);
          if (state.graphData[0].data.length < 4 &&
              state.graphData[1].data.length < 4 &&
              state.graphData[2].data.length < 4) {
            body = Stack(children: [
              body,
              Container(
                color: Colors.white60,
                child: Fullscreen(
                  title: 'Not enough data to display yet',
                  subtitle: 'try again in a few minutes',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  child: Container(),
                  childFirst: false,
                ),
              ),
            ]);
          }
        }
        return AnimatedSwitcher(
            duration: Duration(milliseconds: 200), child: body);
      },
    );
  }

  Widget _renderGraphs(
      BuildContext context, BoxFeedAppBarBlocStateLoaded state) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white24),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, left: 4.5, right: 4.5, bottom: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _renderMetric(
                    Colors.green,
                    'Temp',
                    '${state.graphData[0].data[state.graphData[0].data.length-1].metric.toInt()}°',
                    '${this._min(state.graphData[0].data).metric.toInt()}°',
                    '${this._max(state.graphData[0].data).metric.toInt()}°'),
                _renderMetric(
                    Colors.blue,
                    'Humi',
                    '${state.graphData[1].data[state.graphData[1].data.length-1].metric.toInt()}%',
                    '${this._min(state.graphData[1].data).metric.toInt()}%',
                    '${this._max(state.graphData[1].data).metric.toInt()}%'),
                _renderMetric(
                    Colors.yellow,
                    'Light',
                    '${state.graphData[2].data[state.graphData[2].data.length-1].metric.toInt()}%',
                    '${this._min(state.graphData[2].data).metric.toInt()}%',
                    '${this._max(state.graphData[2].data).metric.toInt()}%'),
              ],
            ),
            Expanded(
              child: charts.TimeSeriesChart(state.graphData,
                  animate: false,
                  defaultRenderer: charts.LineRendererConfig(),
                  customSeriesRenderers: [
                    charts.PointRendererConfig(customRendererId: 'customPoint')
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderMetric(
      Color color, String name, String value, String min, String max) {
    return Column(
      children: <Widget>[
        Text(name),
        Row(
          children: <Widget>[
            Text(value,
                style: TextStyle(
                  color: color,
                  fontSize: 30,
                )),
            Column(
              children: <Widget>[
                Text(max, style: TextStyle(color: Color(0xff787878))),
                Text(min, style: TextStyle(color: Color(0xff787878))),
              ],
            )
          ],
        )
      ],
    );
  }

  Metric _min(List<Metric> values) {
    return values.reduce((acc, v) => acc.metric < v.metric ? acc : v);
  }

  Metric _max(List<Metric> values) {
    return values.reduce((acc, v) => acc.metric > v.metric ? acc : v);
  }
}
