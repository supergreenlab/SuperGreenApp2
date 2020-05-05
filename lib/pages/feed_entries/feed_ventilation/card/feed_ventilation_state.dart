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

class FeedVentilationStateValues {
  final double blowerDay;
  final double blowerNight;

  FeedVentilationStateValues(this.blowerDay, this.blowerNight);
}

class FeedVentilationState {
  final FeedVentilationStateValues values;
  final FeedVentilationStateValues initialValues;

  FeedVentilationState(this.values, this.initialValues);

  static Future<FeedVentilationState> fromJSON(Map<String, dynamic> map) async {
    return FeedVentilationState(
        FeedVentilationStateValues(
            map['values']['blowerDay'], map['values']['blowerNight']),
        FeedVentilationStateValues(map['initialValues']['blowerDay'],
            map['initialValues']['blowerNight']));
  }

  static Future<Map<String, dynamic>> toJSON(
      FeedVentilationState state) async {
    return {
      'values': {
        'blowerDay': state.values.blowerDay,
        'blowerNight': state.values.blowerNight,
      },
      'initialValues': {
        'blowerDay': state.initialValues.blowerDay,
        'blowerNight': state.initialValues.blowerNight,
      },
    };
  }
}
