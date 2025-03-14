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
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';

class FeedVentilationParamsValues extends Equatable {
  final int? fanRefSource;
  final int? fanRefMin;
  final int? fanRefMax;
  final int? fanMin;
  final int? fanMax;

  final int? blowerRefSource;
  final int? blowerRefMin;
  final int? blowerRefMax;
  final int? blowerMin;
  final int? blowerMax;

  // legacy params
  final int? blowerDay;
  final int? blowerNight;

  FeedVentilationParamsValues({
    this.fanRefSource,
    this.fanRefMin,
    this.fanRefMax,
    this.fanMin,
    this.fanMax,
    this.blowerRefSource,
    this.blowerRefMin,
    this.blowerRefMax,
    this.blowerMin,
    this.blowerMax,
    this.blowerDay,
    this.blowerNight,
  });

  factory FeedVentilationParamsValues.fromMap(Map<String, dynamic> map) {
    return FeedVentilationParamsValues(
        fanRefSource: map['fanRefSource'],
        fanRefMin: map['fanRefMin'],
        fanRefMax: map['fanRefMax'],
        fanMin: map['fanMin'],
        fanMax: map['fanMax'],
        blowerRefSource: map['blowerRefSource'],
        blowerRefMin: map['blowerRefMin'],
        blowerRefMax: map['blowerRefMax'],
        blowerMin: map['blowerMin'],
        blowerMax: map['blowerMax'],
        blowerDay: map['blowerDay'],
        blowerNight: map['blowerNight']);
  }

  Map<String, dynamic> toMap() {
    return {
      'fanRefSource': fanRefSource,
      'fanRefMin': fanRefMin,
      'fanRefMax': fanRefMax,
      'fanMin': fanMin,
      'fanMax': fanMax,
      'blowerRefSource': blowerRefSource,
      'blowerRefMin': blowerRefMin,
      'blowerRefMax': blowerRefMax,
      'blowerMin': blowerMin,
      'blowerMax': blowerMax,
      'blowerDay': blowerDay,
      'blowerNight': blowerNight
    };
  }

  @override
  List<Object?> get props =>
      [fanRefSource, fanRefMin, fanRefMax, fanMin, fanMax, blowerRefSource, blowerRefMin, blowerRefMax, blowerMin, blowerMax, blowerDay, blowerNight];
}

class FeedVentilationParams extends FeedEntryParams {
  final FeedVentilationParamsValues values;
  final FeedVentilationParamsValues initialValues;

  FeedVentilationParams(this.values, this.initialValues);

  factory FeedVentilationParams.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedVentilationParams(
        FeedVentilationParamsValues.fromMap(map['values']), FeedVentilationParamsValues.fromMap(map['initialValues']));
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({'values': values.toMap(), 'initialValues': initialValues.toMap()});
  }

  @override
  List<Object> get props => [values, initialValues];
}
