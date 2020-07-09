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

class PlantSettings extends Equatable {
  final String phase;
  final String plantType;
  final bool isSingle;

  final String strain;
  final String seedbank;

  final DateTime veggingStart;
  final DateTime bloomingStart;
  final String medium;

  PlantSettings(
    this.phase,
    this.plantType,
    this.isSingle,
    this.strain,
    this.seedbank,
    this.veggingStart,
    this.bloomingStart,
    this.medium,
  );

  factory PlantSettings.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return PlantSettings(
      map['phase'],
      map['plantType'],
      map['isSingle'],
      map['strain'],
      map['seedBank'],
      map['veggingStart'],
      map['bloomingStart'],
      map['medium'],
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
    });
  }

  @override
  List<Object> get props => [
        phase,
        plantType,
        isSingle,
        strain,
        seedbank,
        veggingStart,
        bloomingStart,
        medium,
      ];
  
  PlantSettings copyWith({
    String phase,
    String plantType,
    bool isSingle,
    String strain,
    String seedbank,
    String veggingStart,
    String bloomingStart,
    String medium
  }) => PlantSettings(
    phase ?? this.phase,
    plantType ?? this.plantType,
    isSingle ?? this.isSingle,
    strain ?? this.strain,
    seedbank ?? this.seedbank,
    veggingStart ?? this.veggingStart,
    bloomingStart ?? this.bloomingStart,
    medium ?? this.medium,
  );
}