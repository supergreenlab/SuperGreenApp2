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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/data/assets/metrics.dart';
import 'package:uuid/uuid.dart';

abstract class ChecklistCondition extends Equatable {
  final String type;

  bool get valid => !props.contains(null) && !props.contains('');
  String get asSentence => '$type';

  ChecklistCondition({required this.type});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }

  String toJSON() => json.encode(toMap());

  List<Object?> get props => [
        type,
      ];

  static List<ChecklistCondition> fromMapArray(List<dynamic> maps) {
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
      case 'timer':
        return ChecklistConditionTimer.fromMap(params);
      default:
        throw UnimplementedError('Condition type $type is not implemented');
    }
  }
}

class ChecklistConditionMetric extends ChecklistCondition {
  static const String TYPE = 'metric';

  final String id;
  final String? key;
  final bool inRange;
  final double? min;
  final double? max;
  final int? duration;
  final String durationUnit;
  final bool daysInRow;
  final int? nDaysInRow;

  bool get valid {
    if (key == null || duration == null) {
      return false;
    }
    if (min == null && max == null) {
      return false;
    }
    if (daysInRow && nDaysInRow == null) {
      return false;
    }
    return true;
  }

  String get asSentence {
    if (!valid) {
      return super.asSentence;
    }
    String str = 'If ${LabMetricNames[key!]!} is ';
    if (inRange) {
      if (min != null && max != null) {
        double div = 1;
        if (key == 'VPD') {
          div = 10;
        }
        str += 'between ${min! / div} and ${max! / div} ';
      } else if (min != null) {
        str += 'above ${min!} ';
      } else if (max != null) {
        str += 'below ${max!} ';
      }
    } else {
      if (min != null && max != null) {
        str += 'out of the range ${min!} < ${max!} ';
      } else if (min != null) {
        str += 'below ${min!} ';
      } else if (max != null) {
        str += 'above ${max!} ';
      }
    }
    str += 'for ${duration!} ${durationUnit.toLowerCase()}';
    if (daysInRow && nDaysInRow != null) {
      str += ' over ${nDaysInRow!} consecutive days.';
    }
    return str;
  }

  ChecklistConditionMetric({
    required this.id,
    this.key,
    this.inRange = true,
    this.min,
    this.max,
    this.duration,
    this.durationUnit = 'HOURS',
    this.daysInRow = false,
    this.nDaysInRow,
  }) : super(
          type: TYPE,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    var params = {
      'id': id,
      'key': key,
      'inRange': inRange,
      'min': min,
      'max': max,
      'duration': duration,
      'durationUnit': durationUnit,
      'daysInRow': daysInRow,
      'nDaysInRow': nDaysInRow,
    };
    map.addAll({
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [
        id,
        type,
        key,
        inRange,
        min,
        max,
        duration,
        durationUnit,
        daysInRow,
        nDaysInRow,
      ];

  static ChecklistConditionMetric fromMap(Map<String, dynamic> map) {
    double? min;
    if (map['min'] != null && map['min'] is int) {
      min = (map['min'] as int).toDouble();
    } else {
      min = map['min'];
    }
    double? max;
    if (map['max'] != null && map['max'] is int) {
      max = (map['max'] as int).toDouble();
    } else {
      max = map['max'];
    }
    return ChecklistConditionMetric(
      id: map['id'] ?? Uuid().v4(),
      key: map['key'],
      inRange: map['inRange'] ?? false,
      min: min,
      max: max,
      duration: map['duration'],
      durationUnit: map['durationUnit'],
      daysInRow: map['daysInRow'] ?? false,
      nDaysInRow: map['nDaysInRow'],
    );
  }

  ChecklistConditionMetric copyWith({
    String? key,
    bool? inRange,
    double? min,
    bool? clearMin,
    double? max,
    bool? clearMax,
    int? duration,
    String? durationUnit,
    bool? daysInRow,
    int? nDaysInRow,
  }) {
    return ChecklistConditionMetric(
      id: id,
      key: key ?? this.key,
      inRange: inRange ?? this.inRange,
      min: clearMin == true ? null : (min ?? this.min),
      max: clearMax == true ? null : (max ?? this.max),
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
      daysInRow: daysInRow ?? this.daysInRow,
      nDaysInRow: nDaysInRow ?? this.nDaysInRow,
    );
  }
}

class ChecklistConditionAfterCard extends ChecklistCondition {
  static const String TYPE = 'after_card';

  final String id;
  final String? entryType;
  final int? duration;
  final String durationUnit;

  String get asSentence =>
      'If last "${FeedEntryNames[entryType!]!}" diary entry is ${duration!} ${durationUnit.toLowerCase()} old.';

  ChecklistConditionAfterCard({
    required this.id,
    this.entryType,
    this.duration,
    this.durationUnit = 'DAYS',
  }) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    var params = {
      'id': id,
      'entryType': entryType,
      'duration': duration,
      'durationUnit': durationUnit,
    };
    map.addAll({
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [
        id,
        type,
        entryType,
        duration,
        durationUnit,
      ];

  static ChecklistConditionAfterCard fromMap(Map<String, dynamic> map) {
    return ChecklistConditionAfterCard(
      id: map['id'] ?? Uuid().v4(),
      entryType: map['entryType'],
      duration: map['duration'],
      durationUnit: map['durationUnit'],
    );
  }

  ChecklistConditionAfterCard copyWith({
    String? entryType,
    int? duration,
    String? durationUnit = 'DAYS',
  }) {
    return ChecklistConditionAfterCard(
      id: id,
      entryType: entryType ?? this.entryType,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }
}

class ChecklistConditionAfterPhase extends ChecklistCondition {
  static const String TYPE = 'after_phase';

  final String id;
  final String? phase;
  final int? duration;
  final String durationUnit;

  String get asSentence => 'If plant is ${PlantPhaseNames[phase!]!} since ${duration!} ${durationUnit.toLowerCase()}.';

  ChecklistConditionAfterPhase({
    required this.id,
    this.phase,
    this.duration,
    this.durationUnit = 'DAYS',
  }) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    var params = {
      'id': id,
      'phase': phase,
      'duration': duration,
      'durationUnit': durationUnit,
    };
    map.addAll({
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [
        type,
        phase,
        duration,
        durationUnit,
      ];

  static ChecklistConditionAfterPhase fromMap(Map<String, dynamic> map) {
    return ChecklistConditionAfterPhase(
      id: map['id'] ?? Uuid().v4(),
      phase: map['phase'],
      duration: map['duration'],
      durationUnit: map['durationUnit'],
    );
  }

  ChecklistConditionAfterPhase copyWith({
    String? phase,
    int? duration,
    String? durationUnit = 'DAYS',
  }) {
    return ChecklistConditionAfterPhase(
      id: id,
      phase: phase ?? this.phase,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }
}

class ChecklistConditionTimer extends ChecklistCondition {
  static const String TYPE = 'timer';

  final String id;
  final DateTime? date;

  final bool repeat;
  final int? repeatDuration;
  final String durationUnit;

  String get asSentence {
    String str = 'Trigger on ${DateFormat.yMMMMEEEEd().format(date!)} at ${DateFormat.Hm().format(date!)}';
    if (repeat) {
      str += ' then repeat every ${repeatDuration!} ${durationUnit.toLowerCase()}.';
    }
    return str;
  }

  bool get valid {
    if (date == null) {
      return false;
    }
    if (repeat && repeatDuration == null) {
      return false;
    }
    return true;
  }

  ChecklistConditionTimer({
    required this.id,
    this.date,
    this.repeat = false,
    this.repeatDuration,
    this.durationUnit = 'DAYS',
  }) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    var params = {
      'id': id,
      'date': date!.toUtc().toIso8601String(),
      'repeat': repeat,
      'repeatDuration': repeatDuration,
      'durationUnit': durationUnit,
    };
    map.addAll({
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [
        id,
        type,
        date,
        repeat,
        repeatDuration,
        durationUnit,
      ];

  static ChecklistConditionTimer fromMap(Map<String, dynamic> map) {
    return ChecklistConditionTimer(
      id: map['id'] ?? Uuid().v4(),
      date: DateTime.parse(map['date'] as String).toLocal(),
      repeat: map['repeat'] ?? false,
      repeatDuration: map['repeatDuration'],
      durationUnit: map['durationUnit'],
    );
  }

  ChecklistConditionTimer copyWith({
    DateTime? date,
    bool? repeat,
    int? repeatDuration,
    String? durationUnit,
  }) {
    return ChecklistConditionTimer(
      id: id,
      date: date ?? this.date,
      repeat: repeat ?? this.repeat,
      repeatDuration: repeatDuration ?? this.repeatDuration,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }
}
