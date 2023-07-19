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
  String params;

  ChecklistCondition({required this.type, required this.params});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'params': params,
    };
  }

  String toJSON() => json.encode(toMap());

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
  String key;
  bool inRange;
  double min;
  double max;
  int duration;
  String durationUnit;

  ChecklistConditionMetric({
    required this.key,
    required this.inRange,
    required this.min,
    required this.max,
    required this.duration,
    required this.durationUnit,
  }) : super(type: 'metric', params: '');

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
}

class ChecklistConditionAfterCard extends ChecklistCondition {
  String type;
  int duration;
  String durationUnit;

  ChecklistConditionAfterCard({
    required this.type,
    required this.duration,
    required this.durationUnit,
  }) : super(type: type, params: '');

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'type': type,
      'duration': duration,
      'durationUnit': durationUnit,
    });
    return map;
  }

  static ChecklistConditionAfterCard fromMap(Map<String, dynamic> map) {
    return ChecklistConditionAfterCard(
      type: map['type'],
      duration: map['duration'],
      durationUnit: map['durationUnit'],
    );
  }
}

class ChecklistConditionAfterPhase extends ChecklistCondition {
  String phase;
  int duration;
  String durationUnit;

  ChecklistConditionAfterPhase({
    required this.phase,
    required this.duration,
    required this.durationUnit,
  }) : super(type: 'after_phase', params: '');

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
}