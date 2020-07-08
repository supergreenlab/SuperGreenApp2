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

class PlantInfosSettings extends Equatable {
  final String phase;
  final String plantType;
  final bool isSingle;

  final String strain;
  final String seedbank;

  final DateTime veggingStart;
  final DateTime bloomingStart;
  final String medium;
  final int width;
  final int height;
  final int depth;

  PlantInfosSettings(this.phase, this.plantType, this.isSingle, this.strain, this.seedbank, this.veggingStart, this.bloomingStart,
      this.medium, this.width, this.height, this.depth);

  factory PlantInfosSettings.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return PlantInfosSettings(
      map['phase'],
      map['plantType'],
      map['isSingle'],
      map['strain'],
      map['seedBank'],
      map['veggingStart'],
      map['bloomingStart'],
      map['medium'],
      map['width'],
      map['height'],
      map['depth'],
    );
  }

  String toJSON() {
    return JsonEncoder().convert({
      'phase': phase,
      'plantType': plantType,
      'isSingle': isSingle,
      'strain': strain,
      'seedBank': seedbank,
      'veggingStart': veggingStart,
      'bloomingStart': bloomingStart,
      'medium': medium,
      'width': width,
      'height': height,
      'depth': depth,
    });
  }

  @override
  List<Object> get props =>
      [phase, plantType, isSingle, veggingStart, bloomingStart, medium, width, height, depth];
}
