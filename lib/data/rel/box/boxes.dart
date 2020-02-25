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

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'boxes.g.dart';

@DataClassName("Box")
class Boxes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  IntColumn get device => integer().nullable()();
  IntColumn get deviceBox => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get settings => text().withDefault(Constant('{}'))();
}

@UseDao(tables: [Boxes])
class BoxesDAO extends DatabaseAccessor<RelDB> with _$BoxesDAOMixin {
  BoxesDAO(RelDB db) : super(db);

  Future<Box> getBox(int id) {
    return (select(boxes)..where((b) => b.id.equals(id))).getSingle();
  }

  Stream<Box> watchBox(int id) {
    return (select(boxes)..where((b) => b.id.equals(id))).watchSingle();
  }

  Future<int> addBox(BoxesCompanion box) {
    return into(boxes).insert(box);
  }

  Future updateBox(int boxID, BoxesCompanion box) {
    return (update(boxes)..where((b) => b.id.equals(boxID))).write(box);
  }

  Stream<List<Box>> watchBoxes() {
    return select(boxes).watch();
  }

  Map<String, dynamic> boxSettings(Box box) {
    final Map<String, dynamic> settings = JsonDecoder().convert(box.settings);
    return {
      'schedule': settings['schedule'] ?? 'VEG',
      'schedules': {
        'VEG': {
          'ON_HOUR': settings['VEG_ON_HOUR'] ?? 3,
          'OFF_HOUR': settings['VEG_OFF_HOUR'] ?? 21,
        },
        'BLOOM': {
          'ON_HOUR': settings['BLOOM_ON_HOUR'] ?? 6,
          'OFF_HOUR': settings['BLOOM_OFF_HOUR'] ?? 18,
        },
        'AUTO': {
          'ON_HOUR': settings['AUTO_ON_HOUR'] ?? 0,
          'OFF_HOUR': settings['AUTO_OFF_HOUR'] ?? 0,
        },
      }
    };
  }
}
