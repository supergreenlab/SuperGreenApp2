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

import 'package:moor/moor.dart';

part 'checklist.g.dart';

class Checklists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plant => integer()();

  TextColumn get settings => text().withDefault(Constant('{}'))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  // static Future<ChecklistsCompanion> fromMap(Map<String, dynamic> map) async {
  // }

  // static Future<Map<String, dynamic>> toMap(Checklist checklist) async {
  // }
}

class ChecklistSeeds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get checklist => integer()();

  BoolColumn get public => boolean().withDefault(Constant(false))();
  BoolColumn get repeat => boolean().withDefault(Constant(false))();
  TextColumn get title => text().withDefault(Constant(''))();
  TextColumn get description => text().withDefault(Constant(''))();

  TextColumn get conditions => text().withDefault(Constant('{}'))();
  TextColumn get actions => text().withDefault(Constant('{}'))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();
}