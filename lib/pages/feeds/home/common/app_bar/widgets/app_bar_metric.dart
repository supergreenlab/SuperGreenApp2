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

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class BoxMetrics extends Equatable {
  final Param? temp;
  final Param? humidity;
  final Param? vpd;
  final Param? co2;
  final Param? weight;
  final DateTime? lastWatering;

  BoxMetrics({this.temp, this.humidity, this.vpd, this.co2, this.weight, this.lastWatering});

  @override
  List<Object?> get props => [temp, humidity, vpd, co2, weight, lastWatering];

  BoxMetrics copyWith({Param? temp, Param? humidity, Param? vpd, Param? co2, Param? weight, DateTime? lastWatering}) {
    return BoxMetrics(
      temp: temp ?? this.temp,
      humidity: humidity ?? this.humidity,
      vpd: vpd ?? this.vpd,
      co2: co2 ?? this.co2,
      weight: weight ?? this.weight,
    );
  }
}

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
                  fontSize: 40,
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

class AppBarBoxMetrics extends StatelessWidget {
  final BoxMetrics metrics;

  const AppBarBoxMetrics({Key? key, required this.metrics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppBarMetric(
            icon: SvgPicture.asset('assets/app_bar/icon_temperature.svg', height: 35),
            value: metrics.temp == null ? 'n/a' : '${metrics.temp!.ivalue}',
            unit: '°',
            unitSize: 30,
            color: Color(0xFF3BB30B)),
        AppBarMetric(
            icon: SvgPicture.asset('assets/app_bar/icon_humidity.svg'),
            value: metrics.humidity == null ? 'n/a' : '${metrics.humidity!.ivalue}',
            unit: '%',
            color: Color(0xFFD7352B)),
        AppBarMetric(
            icon: SvgPicture.asset('assets/app_bar/icon_vpd.svg'),
            value: metrics.vpd == null ? 'n/a' : '${metrics.vpd!.ivalue}',
            color: Color(0xFF115D87)),
        AppBarMetric(
            icon: SvgPicture.asset('assets/app_bar/icon_co2.svg'),
            value: metrics.co2 == null ? 'n/a' : '${metrics.co2!.ivalue}',
            unit: 'ppm',
            unitSize: 14,
            color: Color(0xFF595959)),
        AppBarMetric(
            icon: SvgPicture.asset('assets/app_bar/icon_weight.svg'),
            value: metrics.weight == null ? 'n/a' : '${metrics.weight!.ivalue}',
            unit: 'kg',
            color: Color(0xFF3BB30B)),
      ],
    );
  }
}
