import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/graphs/metrics_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class MetricsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricsBloc, MetricsBlocState>(
        bloc: BlocProvider.of<MetricsBloc>(context),
        builder: (BuildContext context, MetricsBlocState state) {
          Widget body;
          if (state is MetricsBlocStateInit) {
            body = FullscreenLoading(title: 'Loading..');
          } else if (state is MetricsBlocStateLoaded) {
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
                        Text('Show/hide metrics'),
                        Text('Show events'),
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
              elevation: 10,
            ),
            body: Column(
              children: <Widget>[
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white70,
                      border: Border.all(color: Color(0xffdedede), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'graphs',
                        child: charts.TimeSeriesChart(state.graphData,
                            animate: false,
                            defaultRenderer: charts.LineRendererConfig(),
                            behaviors: [
                              charts.RangeAnnotation([
                                new charts.LineAnnotationSegment(
                                    DateTime.now().add(Duration(hours: -24)), charts.RangeAnnotationAxisType.domain,
                                    startLabel: 'Domain 1', color: charts.MaterialPalette.gray.shade500),
                              ])
                            ],
                            customSeriesRenderers: [
                              charts.PointRendererConfig(
                                  customRendererId: 'customPoint')
                            ]),
                      ),
                    )),
                Expanded(child: body),
              ],
            ),
          );
        });
  }
}
