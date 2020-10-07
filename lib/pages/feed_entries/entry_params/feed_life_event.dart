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

import 'package:flutter/foundation.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class FeedLifeEventParams extends FeedEntryParams {
  final PlantPhases phase;

  FeedLifeEventParams(this.phase);

  factory FeedLifeEventParams.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedLifeEventParams(
        PlantPhases.values.firstWhere((p) => describeEnum(p) == map['phase']));
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({
      'phase': describeEnum(phase),
    });
  }

  @override
  List<Object> get props => [phase];
}
