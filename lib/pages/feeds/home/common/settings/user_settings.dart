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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 37)
class UserSettings {
  @HiveField(0)
  int timeOffset = 0;
  @HiveField(1)
  int preferredNotificationHour = 18;
  @HiveField(3)
  bool freedomUnits = false;
  @HiveField(4)
  String? userID;

  UserSettings({this.timeOffset = 0, this.preferredNotificationHour = 18, this.freedomUnits=false, this.userID});

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      userID: map['userID'],
      timeOffset: map['timeOffset'],
      preferredNotificationHour: map['preferredNotificationHour'],
      freedomUnits: map['freedomUnits'],
    );
  }

  factory UserSettings.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return UserSettings.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'timeOffset': timeOffset,
      'preferredNotificationHour': preferredNotificationHour,
      'freedomUnits': freedomUnits,
    };
  }

  String toJSON() {
    return JsonEncoder().convert(toMap());
  }
}
