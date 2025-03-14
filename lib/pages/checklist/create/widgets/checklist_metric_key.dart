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
import 'package:super_green_app/data/assets/metrics.dart';

class ChecklistMetricKey extends StatelessWidget {

  final String? metricKey;
  final Function(String type) onChange;

  const ChecklistMetricKey({Key? key, required this.onChange, required this.metricKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> choices = [
      TEMP,
      HUMI,
      CO2,
      VPD,
      WEIGHT,
      WATERING_LEFT,
    ];
    return DropdownButton<String?>(
      hint: Text('Select metric'),
      value: metricKey,
      onChanged: (String? value) {
        onChange(value == null ? '' : value);
      },
      items: choices.map<DropdownMenuItem<String>>((c) {
        return DropdownMenuItem<String>(
          value: c,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset(LabMetricIcons[c]!),
              ),
              Text(LabMetricNames[c]!),
            ],
          ),
        );
      }).toList(),
    );
  }
}
