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

class DeletedChecklistsCompanion extends ChecklistsCompanion {
  DeletedChecklistsCompanion(serverID) : super(serverID: serverID);
}

class SkipChecklistsCompanion extends ChecklistsCompanion {
  SkipChecklistsCompanion(serverID) : super(serverID: serverID);
}

class Checklists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plant => integer()();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<ChecklistsCompanion> fromMap(Map<String, dynamic> map) async {
    Plant plant;
    try {
      plant = await RelDB.get().plantsDAO.getPlantForServerID(map['plantID']);
    } catch (e) {
      return SkipChecklistsCompanion(Value(map['id'] as String));
    }
    return ChecklistsCompanion(
      plant: Value(plant.id),
      serverID: Value(map['id']),
      synced: Value(true),
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

class DeletedChecklistSeedsCompanion extends ChecklistSeedsCompanion {
  DeletedChecklistSeedsCompanion(serverID) : super(serverID: serverID);
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

  TextColumn get checklistServerID => text().withLength(min: 36, max: 36).nullable()();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<ChecklistSeedsCompanion> fromMap(Map<String, dynamic> map) async {
    Checklist checklist;
    try {
      checklist = await RelDB.get().checklistsDAO.getChecklistForServerID(map['checklistID']);
    } catch (e) {
      return SkipChecklistSeedsCompanion(Value(map['id'] as String));
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
      checklistServerID: Value(map['checklistID'] as String),
      synced: Value(true),
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

class DeletedChecklistLogsCompanion extends ChecklistLogsCompanion {
  DeletedChecklistLogsCompanion(serverID) : super(serverID: serverID);
}

class SkipChecklistLogsCompanion extends ChecklistLogsCompanion {
  SkipChecklistLogsCompanion(serverID) : super(serverID: serverID);
}

class ChecklistLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get checklistSeed => integer()();
  IntColumn get checklist => integer()();

  TextColumn get action => text().withDefault(Constant('{}'))();

  BoolColumn get checked => boolean().withDefault(Constant(false))();
  BoolColumn get skipped => boolean().withDefault(Constant(false))();

  DateTimeColumn get date => dateTime()();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<ChecklistLogsCompanion> fromMap(Map<String, dynamic> map) async {
    Checklist checklist;
    try {
      checklist = await RelDB.get().checklistsDAO.getChecklistForServerID(map['checklistID']);
    } catch (e) {
      return SkipChecklistLogsCompanion(Value(map['id'] as String));
    }

    ChecklistSeed checklistSeed;
    try {
      checklistSeed =
          await RelDB.get().checklistsDAO.getChecklistSeedForServerIDs(map['checklistSeedID'], map['checklistID']);
    } catch (e) {
      return SkipChecklistLogsCompanion(Value(map['id'] as String));
    }
    return ChecklistLogsCompanion(
      checklistSeed: Value(checklistSeed.id),
      checklist: Value(checklist.id),
      date: Value(DateTime.parse(map['cat'] as String).toLocal()),
      checked: Value(map['checked']),
      skipped: Value(map['skipped']),
      action: Value(map['action']),
      serverID: Value(map['id'] as String),
      synced: Value(true),
    );
  }

  static Future<Map<String, dynamic>> toMap(ChecklistLog checklistLog) async {
    return {
      'id': checklistLog.serverID,
      'checked': checklistLog.checked,
      'skipped': checklistLog.skipped,
    };
  }
}

@DriftAccessor(tables: [
  Checklists,
  ChecklistSeeds,
  ChecklistLogs,
])
class ChecklistsDAO extends DatabaseAccessor<RelDB> with _$ChecklistsDAOMixin {
  ChecklistsDAO(RelDB db) : super(db);

  Future<int> addChecklist(ChecklistsCompanion checklist) {
    return into(checklists).insert(checklist);
  }

  Future<int> addChecklistSeed(ChecklistSeedsCompanion checklistSeed) {
    return into(checklistSeeds).insert(checklistSeed);
  }

  Future<int> addChecklistLog(ChecklistLogsCompanion checklistLog) {
    return into(checklistLogs).insert(checklistLog);
  }

  Future<Checklist> getChecklistForPlant(int plantID) {
    return (select(checklists)..where((p) => p.plant.equals(plantID))).getSingle();
  }

  Stream<Checklist> watchChecklistForPlant(int plantID) {
    return (select(checklists)..where((p) => p.plant.equals(plantID))).watchSingle();
  }

  Future<Checklist> getChecklist(int id) {
    return (select(checklists)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<ChecklistSeed> getChecklistSeed(int id) {
    return (select(checklistSeeds)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<ChecklistLog> getChecklistLogForServerID(String serverID) {
    return (select(checklistLogs)..where((cks) => cks.serverID.equals(serverID))).getSingle();
  }

  Future<Checklist> getChecklistForServerID(String serverID) {
    return (select(checklists)..where((cks) => cks.serverID.equals(serverID))).getSingle();
  }

  Future<ChecklistSeed> getChecklistSeedForServerIDs(String serverID, String checklistServerID) {
    return (select(checklistSeeds)
          ..where((cks) => cks.serverID.equals(serverID) & cks.checklistServerID.equals(checklistServerID)))
        .getSingle();
  }

  Future<List<ChecklistSeed>> getChecklistSeeds(int checklistID) {
    return (select(checklistSeeds)..where((p) => p.checklist.equals(checklistID))).get();
  }

  Future<List<ChecklistLog>> getChecklistLogs(int checklistID, { int limit=0, int offset=0 }) {
    var query = (select(checklistLogs)..where((p) => p.checklist.equals(checklistID))..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]));
    if (limit != 0) {
      query = query..limit(limit, offset: offset);
    }
    return query.get();
  }

  Stream<List<ChecklistLog>> watchChecklistLogs(int checklistID) {
    return (select(checklistLogs)..where((p) => p.checklist.equals(checklistID))).watch();
  }

  Future updateChecklistSeed(ChecklistSeedsCompanion checklistSeed) {
    return (update(checklistSeeds)..where((tbl) => tbl.id.equals(checklistSeed.id.value))).write(checklistSeed);
  }

  Future updateChecklist(ChecklistsCompanion checklist) {
    return (update(checklists)..where((tbl) => tbl.id.equals(checklist.id.value))).write(checklist);
  }

  Future updateChecklistLog(ChecklistLogsCompanion checklistLog) {
    return (update(checklistLogs)..where((tbl) => tbl.id.equals(checklistLog.id.value))).write(checklistLog);
  }

  Stream<List<ChecklistSeed>> watchChecklistSeeds(int checklistID) {
    return (select(checklistSeeds)..where((p) => p.checklist.equals(checklistID))).watch();
  }

  Future<List<ChecklistLog>> getUnsyncedChecklistLogs() {
    return (select(checklistLogs)..where((b) => b.synced.equals(false))).get();
  }

  Future<List<Checklist>> getUnsyncedChecklists() {
    return (select(checklists)..where((b) => b.synced.equals(false))).get();
  }

  Future<List<ChecklistSeed>> getUnsyncedChecklistSeeds() {
    return (select(checklistSeeds)..where((b) => b.synced.equals(false))).get();
  }

  Future deleteChecklist(Checklist checklist) {
    return delete(checklists).delete(checklist);
  }

  Future deleteChecklistSeed(ChecklistSeed checklistSeed) {
    return delete(checklistSeeds).delete(checklistSeed);
  }

  Future deleteChecklistLog(ChecklistLog checklistLog) {
    return delete(checklistLogs).delete(checklistLog);
  }
}
