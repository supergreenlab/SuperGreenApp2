import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/graphs/metrics_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class MetricsPage extends StatefulWidget {
  @override
  _MetricsPageState createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  bool _showTemp = true;
  bool _showHumi = true;
  bool _showLight = true;
  int _fromTime =
      DateTime.now().add(Duration(hours: -72)).millisecondsSinceEpoch ~/ 1000;
  int _toTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Map<String, String> _titles = {
    'FE_LIGHT': 'Light change',
    'FE_VENTILATION': 'Ventilation change',
    'FE_SCHEDULE': 'Schedule change',
    'FE_WATER': 'Watering',
    'FE_TRANSPLANT': 'Transplant',
  };

  Map<String, String> _icons = {
    'FE_LIGHT': 'assets/feed_card/icon_dimming.svg',
    'FE_VENTILATION': 'assets/feed_card/icon_blower.svg',
    'FE_SCHEDULE': 'assets/feed_card/icon_schedule.svg',
    'FE_WATER': 'assets/feed_card/icon_watering.svg',
    'FE_TRANSPLANT': 'assets/feed_card/icon_transplant.svg',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricsBloc, MetricsBlocState>(
        bloc: BlocProvider.of<MetricsBloc>(context),
        builder: (BuildContext context, MetricsBlocState state) {
          Widget body;
          List annotations;
          if (state is MetricsBlocStateInit) {
            body = FullscreenLoading(title: 'Loading..');
          } else if (state is MetricsBlocStateLoaded) {
            annotations = state.entries
                .map(
                  (e) => charts.LineAnnotationSegment(
                      e.date, charts.RangeAnnotationAxisType.domain,
                      startLabel: _titles[e.type],
                      labelStyleSpec: charts.TextStyleSpec(
                          color: charts.MaterialPalette.white),
                      color: charts.MaterialPalette.gray.shade500),
                )
                .toList();

            body = DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(
                          icon: Icon(Icons.show_chart, color: Colors.black),
                        ),
                        Tab(
                          icon: Icon(Icons.table_chart, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _renderMetrics(context, state),
                        _renderEvents(context, state),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: SGLAppBar(
              'Metrics',
              backgroundColor: Color(0xff063047),
              titleColor: Colors.white,
              iconColor: Colors.white,
            ),
            body: Column(
              children: <Widget>[
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xff063047),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 5),
                            color: Colors.black12,
                            blurRadius: 5)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'graphs',
                        child: charts.TimeSeriesChart(
                          state.graphData,
                          animate: false,
                          behaviors:
                              annotations != null && annotations.length > 0
                                  ? [
                                      charts.RangeAnnotation(annotations),
                                    ]
                                  : null,
                          customSeriesRenderers: [
                            charts.PointRendererConfig(
                                customRendererId: 'customPoint')
                          ],
                          domainAxis: charts.DateTimeAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.white),
                                  lineStyle: charts.LineStyleSpec(
                                      color: charts.MaterialPalette.white))),
                          primaryMeasureAxis: charts.NumericAxisSpec(
                              renderSpec: charts.GridlineRendererSpec(
                                  labelStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.white),
                                  lineStyle: charts.LineStyleSpec(
                                      color: charts.MaterialPalette.white))),
                        ),
                      ),
                    )),
                Expanded(child: body),
              ],
            ),
          );
        });
  }

  Widget _renderMetrics(BuildContext context, MetricsBlocStateLoaded state) {
    return Column(
      children: [
        _renderOptionCheckbx(context, 'Temperature', (value) {
          setState(() {
            _showTemp = value;
            BlocProvider.of<MetricsBloc>(context).add(
                MetricsBlocEventChartParams(
                    _showTemp, _showHumi, _showLight, _fromTime, _toTime));
          });
        }, _showTemp),
        _renderOptionCheckbx(context, 'Humidity', (value) {
          setState(() {
            _showHumi = value;
            BlocProvider.of<MetricsBloc>(context).add(
                MetricsBlocEventChartParams(
                    _showTemp, _showHumi, _showLight, _fromTime, _toTime));
          });
        }, _showHumi),
        _renderOptionCheckbx(context, 'Light', (value) {
          setState(() {
            _showLight = value;
            BlocProvider.of<MetricsBloc>(context).add(
                MetricsBlocEventChartParams(
                    _showTemp, _showHumi, _showLight, _fromTime, _toTime));
          });
        }, _showLight),
      ],
    );
  }

  Widget _renderEvents(BuildContext context, MetricsBlocStateLoaded state) {
    return ListView.builder(
        itemCount: state.entries.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            leading: SvgPicture.asset(_icons[state.entries[i].type]),
            title: Text(_titles[state.entries[i].type]),
            subtitle: FeedCardDate(state.entries[i]),
          );
        });
  }

  Widget _renderOptionCheckbx(
      BuildContext context, String text, Function(bool) onChanged, bool value) {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        InkWell(
          onTap: () {
            onChanged(!value);
          },
          child: MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ),
      ],
    );
  }
}
