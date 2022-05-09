/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class AppBarMetric extends StatelessWidget {
  final Widget icon;
  final String? value;
  final String? unit;
  final double unitSize;
  final Color color;

  const AppBarMetric({Key? key, required this.icon, this.value, this.unit, this.unitSize = 20, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          child: icon,
          alignment: Alignment.bottomLeft,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value == null ? 'N/A' : value!,
                style: TextStyle(
                  color: color,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            unit != null
                ? Text(unit!,
                    style: TextStyle(
                      fontSize: unitSize,
                      color: color,
                    ))
                : Container(),
          ],
        )
      ],
    );
  }
}

class AppBarBoxMetricsPage extends StatelessWidget {
  const AppBarBoxMetricsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBarMetricsBloc, AppBarMetricsBlocState>(
        listener: (BuildContext context, AppBarMetricsBlocState state) {
          if (state is AppBarMetricsBlocStateLoaded) {}
        },
        child: BlocBuilder<AppBarMetricsBloc, AppBarMetricsBlocState>(
            bloc: BlocProvider.of<AppBarMetricsBloc>(context),
            builder: (BuildContext context, AppBarMetricsBlocState state) {
              if (state is AppBarMetricsBlocStateInit) {
                return _renderLoading(context, state);
              } else if (state is AppBarMetricsBlocStateNoDevice) {
                return _renderNoDevice(context, state);
              }
              return _renderLoaded(context, state as AppBarMetricsBlocStateLoaded);
            }));
  }

  Widget _renderNoDevice(BuildContext context, AppBarMetricsBlocStateNoDevice state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _renderMetrics(24, 56, 11, 453, 45),
        ),
        Container(
          color: Colors.white.withAlpha(220),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No sensor yet',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xff909090),
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderLoading(BuildContext context, AppBarMetricsBlocStateInit state) {
    return FullscreenLoading();
  }

  Widget _renderLoaded(BuildContext context, AppBarMetricsBlocStateLoaded state) {
    AppBarMetricsParamsController metrics = state.metrics;
    return _renderMetrics(metrics.temp.ivalue, metrics.humidity.ivalue, metrics.vpd?.ivalue.toDouble(),
        metrics.co2?.ivalue, metrics.weight?.ivalue.toDouble());
  }

  Widget _renderMetrics(int temp, int humidity, double? vpd, int? co2, double? weight) {
    List<Widget> widgets = [
      AppBarMetric(
          icon: SvgPicture.asset('assets/app_bar/icon_temperature.svg', height: 35),
          value: '$temp',
          unit: '°',
          unitSize: 30,
          color: Color(0xFF3BB30B)),
      AppBarMetric(
          icon: SvgPicture.asset(
            'assets/app_bar/icon_humidity.svg',
            height: 30,
          ),
          value: '$humidity',
          unit: '%',
          color: Color(0xFFD7352B)),
      AppBarMetric(
          icon: SvgPicture.asset('assets/app_bar/icon_vpd.svg'),
          value: vpd == null || vpd == 0 ? 'n/a' : '${vpd / 10.0}',
          color: Color(0xFF115D87)),
    ];
    widgets.add(AppBarMetric(
        icon: SvgPicture.asset('assets/app_bar/icon_co2.svg'),
        value: co2 == null || co2 == 0 ? 'n/a' : '$co2',
        unit: 'ppm',
        unitSize: 14,
        color: Color(0xFF595959)));
    widgets.add(AppBarMetric(
        icon: SvgPicture.asset('assets/app_bar/icon_weight.svg'),
        value: weight == null || weight == 0 ? 'n/a' : '${weight / 10.0}',
        unit: 'kg',
        color: Color(0xFF483581)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }
}