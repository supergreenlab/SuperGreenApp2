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

import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';

class FeedScheduleParams extends FeedEntryParams {
  final String schedule;
  final Map<String, dynamic> schedules;
  final String initialSchedule;
  final Map<String, dynamic> initialSchedules;

  FeedScheduleParams(this.schedule, this.schedules, this.initialSchedule, this.initialSchedules);

  factory FeedScheduleParams.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedScheduleParams(map['schedule'], map['schedules'], map['initialSchedule'], map['initialSchedules']);
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({
      'schedule': schedule,
      'schedules': schedules,
      'initialSchedule': initialSchedule,
      'initialSchedules': initialSchedules,
    });
  }

  @override
  List<Object> get props => [schedule, schedules, initialSchedule, initialSchedules];
}
