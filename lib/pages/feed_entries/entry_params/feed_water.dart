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

import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';

class FeedWaterParams extends FeedEntryParams {
  final double volume;
  final bool tooDry;
  final bool nutrient;
  final double ph;
  final double ec;
  final double tds;
  final String message;

  FeedWaterParams(this.volume, this.tooDry, this.nutrient, this.ph, this.ec,
      this.tds, this.message);

  FeedWaterParams copyWith(String message) => FeedWaterParams(this.volume,
      this.tooDry, this.nutrient, this.ph, this.ec, this.tds, message);

  factory FeedWaterParams.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedWaterParams(map['volume'], map['tooDry'], map['nutrient'],
        map['ph'], map['ec'], map['tds'], map['message']);
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({
      'volume': volume,
      'tooDry': tooDry,
      'nutrient': nutrient,
      'ph': ph,
      'ec': ec,
      'tds': tds,
      'message': message,
    });
  }

  @override
  List<Object> get props => [volume, tooDry, nutrient, ph, ec, tds, message];
}
