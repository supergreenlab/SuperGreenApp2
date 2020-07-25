/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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

import 'dart:convert';

import 'package:equatable/equatable.dart';

const DEFAULT_SCHEDULES = {
  'VEG': {
    'ON_HOUR': 3,
    'ON_MIN': 0,
    'OFF_HOUR': 21,
    'OFF_MIN': 0,
  },
  'BLOOM': {
    'ON_HOUR': 6,
    'ON_MIN': 0,
    'OFF_HOUR': 18,
    'OFF_MIN': 0,
  },
  'AUTO': {
    'ON_HOUR': 0,
    'ON_MIN': 0,
    'OFF_HOUR': 0,
    'OFF_MIN': 0,
  },
};

class BoxSettings extends Equatable {
  final String schedule;
  final Map<String, dynamic> schedules;

  final int width;
  final int height;
  final int depth;

  BoxSettings(this.width, this.height, this.depth,
      {this.schedule = 'VEG', this.schedules = DEFAULT_SCHEDULES});

  factory BoxSettings.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return BoxSettings.fromMap(map);
  }

  factory BoxSettings.fromMap(Map<String, dynamic> map) {
    return BoxSettings(
      map['width'],
      map['height'],
      map['depth'],
      schedule: map['schedule'],
      schedules: map['schedules'],
    );
  }

  String toJSON() {
    return JsonEncoder().convert({
      'schedule': schedule,
      'schedules': schedules,
      'width': width,
      'height': height,
      'depth': depth,
    });
  }

  @override
  List<Object> get props => [schedule, schedules, width, height, depth];

  BoxSettings copyWith(
          {String schedule,
          Map<String, dynamic> schedules,
          int width,
          int height,
          int depth}) =>
      BoxSettings(
        width ?? this.width,
        height ?? this.height,
        depth ?? this.depth,
        schedule: schedule ?? this.schedule,
        schedules: schedules ?? this.schedules,
      );
}
