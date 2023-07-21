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

abstract class ChecklistCondition {
  String type;

  ChecklistCondition({required this.type});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'params': toJSON(),
    };
  }

  String toJSON() => json.encode(toMap());

  static List<ChecklistCondition> fromMapArray(List<Map<String, dynamic>> maps) {
    return maps.map<ChecklistCondition>((m) => ChecklistCondition.fromMap(m)).toList();
  }

  static ChecklistCondition fromMap(Map<String, dynamic> map) {
    var type = map['type'] as String;
    var params = jsonDecode(map['params']) as Map<String, dynamic>;

    switch (type) {
      case 'metric':
        return ChecklistConditionMetric.fromMap(params);
      case 'after_card':
        return ChecklistConditionAfterCard.fromMap(params);
      case 'after_phase':
        return ChecklistConditionAfterPhase.fromMap(params);
      default:
        throw UnimplementedError('Condition type $type is not implemented');
    }
  }
}

class ChecklistConditionMetric extends ChecklistCondition {
  static const String TYPE = 'metric';

  String? key;
  bool? inRange;
  double? min;
  double? max;
  int? duration;
  String? durationUnit;

  ChecklistConditionMetric({
    this.key,
    this.inRange,
    this.min,
    this.max,
    this.duration,
    this.durationUnit,
  }) : super(
          type: TYPE,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'key': key,
      'inRange': inRange,
      'min': min,
      'max': max,
      'duration': duration,
      'durationUnit': durationUnit,
    });
    return map;
  }

  static ChecklistConditionMetric fromMap(Map<String, dynamic> map) {
    return ChecklistConditionMetric(
      key: map['key'],
      inRange: map['inRange'],
      min: map['min'],
      max: map['max'],
      duration: map['duration'],
      durationUnit: map['durationUnit'],
    );
  }

  ChecklistConditionMetric copyWith({
    String? key,
    bool? inRange,
    double? min,
    double? max,
    int? duration,
    String? durationUnit,
  }) {
    return ChecklistConditionMetric(
      key: key ?? this.key,
      inRange: inRange ?? this.inRange,
      min: min ?? this.min,
      max: max ?? this.max,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }
}

class ChecklistConditionAfterCard extends ChecklistCondition {
  static const String TYPE = 'metric';

  String? entryType;
  int? duration;
  String? durationUnit;

  ChecklistConditionAfterCard({
    this.entryType,
    this.duration,
    this.durationUnit,
  }) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'entryType': entryType,
      'duration': duration,
      'durationUnit': durationUnit,
    });
    return map;
  }

  static ChecklistConditionAfterCard fromMap(Map<String, dynamic> map) {
    return ChecklistConditionAfterCard(
      entryType: map['entryType'],
      duration: map['duration'],
      durationUnit: map['durationUnit'],
    );
  }

  ChecklistConditionAfterCard copyWith({
    String? entryType,
    int? duration,
    String? durationUnit,
  }) {
    return ChecklistConditionAfterCard(
      entryType: entryType ?? this.entryType,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }
}

class ChecklistConditionAfterPhase extends ChecklistCondition {
  static const String TYPE = 'after_phase';

  String? phase;
  int? duration;
  String? durationUnit;

  ChecklistConditionAfterPhase({
    this.phase,
    this.duration,
    this.durationUnit,
  }) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'phase': phase,
      'duration': duration,
      'durationUnit': durationUnit,
    });
    return map;
  }

  static ChecklistConditionAfterPhase fromMap(Map<String, dynamic> map) {
    return ChecklistConditionAfterPhase(
      phase: map['phase'],
      duration: map['duration'],
      durationUnit: map['durationUnit'],
    );
  }

  ChecklistConditionAfterPhase copyWith({
    String? phase,
    int? duration,
    String? durationUnit,
  }) {
    return ChecklistConditionAfterPhase(
      phase: phase ?? this.phase,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }
}

class ChecklistConditionTimer extends ChecklistCondition {
  static const String TYPE = 'timer';

  DateTime? date;

  ChecklistConditionTimer({
    this.date,
  }) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'date': date
    });
    return map;
  }

  static ChecklistConditionTimer fromMap(Map<String, dynamic> map) {
    return ChecklistConditionTimer(
      date: map['date'],
    );
  }

  ChecklistConditionTimer copyWith({
    DateTime? date,
  }) {
    return ChecklistConditionTimer(
      date: date ?? this.date,
    );
  }
}