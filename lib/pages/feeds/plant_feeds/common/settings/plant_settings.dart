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
import 'package:tuple/tuple.dart';

enum PlantPhases { GERMINATING, VEGGING, BLOOMING, DRYING, CURING }

class PlantSettings extends Equatable {
  final String plantType;
  final bool isSingle;

  final String strain;
  final String seedbank;

  final DateTime germinationDate;
  final DateTime veggingStart;
  final DateTime bloomingStart;
  final DateTime dryingStart;
  final DateTime curingStart;
  final String medium;

  PlantSettings(
    this.plantType,
    this.isSingle,
    this.strain,
    this.seedbank,
    this.germinationDate,
    this.veggingStart,
    this.bloomingStart,
    this.dryingStart,
    this.curingStart,
    this.medium,
  );

  Tuple3<PlantPhases, DateTime, Duration> phaseAt(DateTime date) {
    if (curingStart != null && curingStart.isBefore(date)) {
      return Tuple3<PlantPhases, DateTime, Duration>(
          PlantPhases.CURING, curingStart, date.difference(curingStart));
    } else if (dryingStart != null && dryingStart.isBefore(date)) {
      return Tuple3<PlantPhases, DateTime, Duration>(
          PlantPhases.DRYING, dryingStart, date.difference(dryingStart));
    } else if (bloomingStart != null && bloomingStart.isBefore(date)) {
      return Tuple3<PlantPhases, DateTime, Duration>(
          PlantPhases.BLOOMING, bloomingStart, date.difference(bloomingStart));
    } else if (veggingStart != null && veggingStart.isBefore(date)) {
      return Tuple3<PlantPhases, DateTime, Duration>(
          PlantPhases.VEGGING, veggingStart, date.difference(veggingStart));
    } else if (germinationDate != null && germinationDate.isBefore(date)) {
      return Tuple3<PlantPhases, DateTime, Duration>(PlantPhases.GERMINATING,
          germinationDate, date.difference(germinationDate));
    }
    return null;
  }

  DateTime dateForPhase(PlantPhases phase) {
    if (phase == PlantPhases.GERMINATING) {
      return germinationDate;
    } else if (phase == PlantPhases.VEGGING) {
      return veggingStart;
    } else if (phase == PlantPhases.BLOOMING) {
      return bloomingStart;
    } else if (phase == PlantPhases.DRYING) {
      return dryingStart;
    } else if (phase == PlantPhases.CURING) {
      return curingStart;
    }
    return null;
  }

  PlantSettings setDateForPhase(PlantPhases phase, DateTime date) {
    if (phase == PlantPhases.GERMINATING) {
      return this.copyWith(germinationDate: date);
    } else if (phase == PlantPhases.VEGGING) {
      return this.copyWith(veggingStart: date);
    } else if (phase == PlantPhases.BLOOMING) {
      return this.copyWith(bloomingStart: date);
    } else if (phase == PlantPhases.DRYING) {
      return this.copyWith(dryingStart: date);
    } else if (phase == PlantPhases.CURING) {
      return this.copyWith(curingStart: date);
    }
    return this;
  }

  factory PlantSettings.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return PlantSettings.fromMap(map);
  }

  factory PlantSettings.fromMap(Map<String, dynamic> map) {
    return PlantSettings(
      map['plantType'],
      map['isSingle'],
      map['strain'],
      map['seedBank'],
      map['germinationDate'] == null
          ? null
          : DateTime.parse(map['germinationDate'] as String).toLocal(),
      map['veggingStart'] == null
          ? null
          : DateTime.parse(map['veggingStart'] as String).toLocal(),
      map['bloomingStart'] == null
          ? null
          : DateTime.parse(map['bloomingStart'] as String).toLocal(),
      map['dryingStart'] == null
          ? null
          : DateTime.parse(map['dryingStart'] as String).toLocal(),
      map['curingStart'] == null
          ? null
          : DateTime.parse(map['curingStart'] as String).toLocal(),
      map['medium'],
    );
  }

  String toJSON() {
    return JsonEncoder().convert({
      'plantType': plantType,
      'isSingle': isSingle,
      'strain': strain,
      'seedBank': seedbank,
      'germinationDate': germinationDate == null
          ? null
          : germinationDate.toUtc().toIso8601String(),
      'veggingStart':
          veggingStart == null ? null : veggingStart.toUtc().toIso8601String(),
      'bloomingStart': bloomingStart == null
          ? null
          : bloomingStart.toUtc().toIso8601String(),
      'dryingStart':
          dryingStart == null ? null : dryingStart.toUtc().toIso8601String(),
      'curingStart':
          curingStart == null ? null : curingStart.toUtc().toIso8601String(),
      'medium': medium,
    });
  }

  @override
  List<Object> get props => [
        plantType,
        isSingle,
        strain,
        seedbank,
        germinationDate,
        veggingStart,
        bloomingStart,
        dryingStart,
        curingStart,
        medium,
      ];

  PlantSettings copyWith(
          {String plantType,
          bool isSingle,
          String strain,
          String seedbank,
          DateTime germinationDate,
          DateTime veggingStart,
          DateTime bloomingStart,
          DateTime dryingStart,
          DateTime curingStart,
          String medium}) =>
      PlantSettings(
        plantType ?? this.plantType,
        isSingle ?? this.isSingle,
        strain ?? this.strain,
        seedbank ?? this.seedbank,
        germinationDate ?? this.germinationDate,
        veggingStart ?? this.veggingStart,
        bloomingStart ?? this.bloomingStart,
        dryingStart ?? this.dryingStart,
        curingStart ?? this.curingStart,
        medium ?? this.medium,
      );
}
