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

class FeedMeasureParams extends FeedEntryParams {
  final String? message;
  final int? time;
  final dynamic previous;

  FeedMeasureParams(this.message, this.time, this.previous);

  FeedMeasureParams copyWith(String message) => FeedMeasureParams(message, this.time, this.previous);

  factory FeedMeasureParams.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedMeasureParams(map['message'], map['time'], map['previous']);
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({'message': message, 'time': time, 'previous': previous});
  }

  @override
  List<Object?> get props => [message, time, previous];
}
