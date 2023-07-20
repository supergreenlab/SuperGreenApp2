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

import 'package:drift/drift.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'checklists.g.dart';

class Checklists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plant => integer()();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<ChecklistsCompanion> fromMap(Map<String, dynamic> map) async {
    Plant plant = await RelDB.get().plantsDAO.getPlant(map['plantID']);
    return ChecklistsCompanion(
      plant: Value(plant.id),
      serverID: Value(map['id']),
    );
  }

  static Future<Map<String, dynamic>> toMap(Checklist checklist) async {
    Plant plant = await RelDB.get().plantsDAO.getPlant(checklist.plant);
    return {
      'id': checklist.serverID,
      'plantID': plant.serverID,
    };
  }
}

class SkipChecklistSeedsCompanion extends ChecklistSeedsCompanion {
  SkipChecklistSeedsCompanion(serverID) : super(serverID: serverID);
}

class ChecklistSeeds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get checklist => integer()();

  TextColumn get title => text().withDefault(Constant(''))();
  TextColumn get description => text().withDefault(Constant(''))();

  BoolColumn get public => boolean().withDefault(Constant(false))();
  BoolColumn get repeat => boolean().withDefault(Constant(false))();

  BoolColumn get active => boolean().withDefault(Constant(false))();

  TextColumn get conditions => text().withDefault(Constant('{}'))();
  TextColumn get actions => text().withDefault(Constant('{}'))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<ChecklistSeedsCompanion> fromMap(Map<String, dynamic> map) async {
    Checklist checklist;
    try {
      checklist = await RelDB.get().checklistsDAO.getChecklist(map['checklistID']);
    } catch(e) {
      return SkipChecklistSeedsCompanion(map['id'] as String);
    }
    return ChecklistSeedsCompanion(
      checklist: Value(checklist.id),
      public: Value(map['public']),
      repeat: Value(map['repeat']),
      title: Value(map['title']),
      description: Value(map['description']),
      conditions: Value(map['conditions']),
      actions: Value(map['actions']),
      serverID: Value(map['id'] as String),
    );
  }

  static Future<Map<String, dynamic>> toMap(ChecklistSeed checklistSeed) async {
    Checklist checklist = await RelDB.get().checklistsDAO.getChecklist(checklistSeed.checklist);
    return {
      'id': checklistSeed.serverID,
      'checklistID': checklist.serverID,
      'public': checklistSeed.public,
      'repeat': checklistSeed.repeat,
      'title': checklistSeed.title,
      'description': checklistSeed.description,
      'conditions': checklistSeed.conditions,
      'actions': checklistSeed.actions,
    };
  }
}

@DriftAccessor(tables: [
  Checklists,
  ChecklistSeeds,
])
class ChecklistsDAO extends DatabaseAccessor<RelDB> with _$ChecklistsDAOMixin {
  ChecklistsDAO(RelDB db) : super(db);

  Future<int> addChecklist(ChecklistsCompanion checklist) {
    return into(checklists).insert(checklist);
  }

  Future<Checklist> getChecklistForPlant(int plantID) {
    return (select(checklists)..where((p) => p.plant.equals(plantID))).getSingle();
  }

  Future<Checklist> getChecklist(int id) {
    return (select(checklists)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<List<ChecklistSeed>> getChecklistSeeds(int checklistID) {
    return (select(checklistSeeds)..where((p) => p.checklist.equals(checklistID))).get();
  }

  Future updateChecklistSeed(ChecklistSeedsCompanion checklistSeed) {
    return (update(checklistSeeds)..where((tbl) => tbl.id.equals(checklistSeed.id.value))).write(checklistSeed);
  }
}
