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

import 'package:equatable/equatable.dart';

class AlertsSettings extends Equatable {
  final int minTempDay;
  final int maxTempDay;

  final int minTempNight;
  final int maxTempNight;

  final int minHumiDay;
  final int maxHumiDay;

  final int minHumiNight;
  final int maxHumiNight;

  AlertsSettings(
      {this.minTempDay,
      this.maxTempDay,
      this.minTempNight,
      this.maxTempNight,
      this.minHumiDay,
      this.maxHumiDay,
      this.minHumiNight,
      this.maxHumiNight});

  Map<String, dynamic> toMap() {
    return {
      "minTempDay": minTempDay,
      "maxTempDay": maxTempDay,
      "minTempNight": minTempNight,
      "maxTempNight": maxTempNight,
      "minHumiDay": minHumiDay,
      "maxHumiDay": maxHumiDay,
      "minHumiNight": minHumiNight,
      "maxHumiNight": maxHumiNight,
    };
  }

  factory AlertsSettings.fromMap(Map<String, dynamic> map) {
    return AlertsSettings(
      minTempDay: map['minTempDay'],
      maxTempDay: map['maxTempDay'],
      minTempNight: map['minTempNight'],
      maxTempNight: map['maxTempNight'],
      minHumiDay: map['minHumiDay'],
      maxHumiDay: map['maxHumiDay'],
      minHumiNight: map['minHumiNight'],
      maxHumiNight: map['maxHumiNight'],
    );
  }

  AlertsSettings copyWith(
      {minTempDay, maxTempDay, minTempNight, maxTempNight, minHumiDay, maxHumiDay, minHumiNight, maxHumiNight}) {
    return AlertsSettings(
      minTempDay: minTempDay ?? this.minTempDay,
      maxTempDay: maxTempDay ?? this.maxTempDay,
      minTempNight: minTempNight ?? this.minTempNight,
      maxTempNight: maxTempNight ?? this.maxTempNight,
      minHumiDay: minHumiDay ?? this.minHumiDay,
      maxHumiDay: maxHumiDay ?? this.maxHumiDay,
      minHumiNight: minHumiNight ?? this.minHumiNight,
      maxHumiNight: maxHumiNight ?? this.maxHumiNight,
    );
  }

  @override
  List<Object> get props => [
        this.minTempDay,
        this.maxTempDay,
        this.minTempNight,
        this.maxTempNight,
        this.minHumiDay,
        this.maxHumiDay,
        this.minHumiNight,
        this.maxHumiNight
      ];
}
