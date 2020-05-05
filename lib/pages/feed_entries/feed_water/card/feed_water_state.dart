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

class FeedWaterState {
  final double volume;
  final bool tooDry;
  final bool nutrient;

  FeedWaterState(this.volume, this.tooDry, this.nutrient);

  static Future<FeedWaterState> fromJSON(
      Map<String, dynamic> map) async {
    return FeedWaterState(
        map['volume'], map['tooDry'], map['nutrient']);
  }

  static Future<Map<String, dynamic>> toJSON(FeedWaterState state) async {
    return {
      'volume': state.volume,
      'tooDry': state.tooDry,
      'nutrient': state.nutrient,
    };
  }
}
