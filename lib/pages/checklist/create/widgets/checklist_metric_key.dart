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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';

class ChecklistMetricKey extends StatelessWidget {

  final String? metricKey;
  final Function(String type) onChange;

  const ChecklistMetricKey({Key? key, required this.onChange, required this.metricKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tuple3<String, String, String>> choices = [
      Tuple3('TEMP', 'assets/app_bar/icon_temperature.svg', 'Temperature'),
      Tuple3('HUMI', 'assets/app_bar/icon_humidity.svg', 'Humidity'),
      Tuple3('CO2', 'assets/app_bar/icon_co2.svg', 'CO2'),
      Tuple3('CO2', 'assets/app_bar/icon_vpd.svg', 'VPD'),
      Tuple3('WEIGHT', 'assets/app_bar/icon_weight.svg', 'Weight'),
      Tuple3('WATERING_LEFT', 'assets/app_bar/icon_watering.svg', 'Watering left'),
    ];
    return DropdownButton<String?>(
      hint: Text('Select metric'),
      value: metricKey,
      onChanged: (String? value) {
        onChange(value == null ? '' : value);
      },
      items: choices.map<DropdownMenuItem<String>>((c) {
        return DropdownMenuItem<String>(
          value: c.item1,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(c.item2),
              ),
              Text(c.item3),
            ],
          ),
        );
      }).toList(),
    );
  }
}
