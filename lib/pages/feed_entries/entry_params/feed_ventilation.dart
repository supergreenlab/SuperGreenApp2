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

class FeedVentilationParamsValues extends Equatable {
  final double blowerDay;
  final double blowerNight;

  FeedVentilationParamsValues(this.blowerDay, this.blowerNight);

  static FeedVentilationParamsValues fromJSON(Map<String, dynamic> map) {
    return FeedVentilationParamsValues(map['blowerDay'], map['blowerNight']);
  }

  static Map<String, dynamic> toJSON(FeedVentilationParamsValues p) {
    return {'blowerDay': p.blowerDay, 'blowerNight': p.blowerNight};
  }

  @override
  List<Object> get props => [blowerDay, blowerNight];
}

class FeedVentilationParams extends Equatable {
  final FeedVentilationParamsValues values;
  final FeedVentilationParamsValues initialValues;

  FeedVentilationParams(this.values, this.initialValues);

  static FeedVentilationParams fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedVentilationParams(
        FeedVentilationParamsValues.fromJSON(map['values']),
        FeedVentilationParamsValues.fromJSON(map['initialValues']));
  }

  static Map<String, dynamic> toJSON(FeedVentilationParams p) {
    return {
      'values': FeedVentilationParamsValues.toJSON(p.values),
      'initialValues': FeedVentilationParamsValues.toJSON(p.initialValues)
    };
  }

  @override
  List<Object> get props => [values, initialValues];
}
