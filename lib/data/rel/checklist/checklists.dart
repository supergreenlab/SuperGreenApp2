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

class ChecklistCollections extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get checklist => integer()();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();

  TextColumn get title => text().withDefault(Constant(''))();
  TextColumn get description => text().withDefault(Constant(''))();
  TextColumn get category => text().withDefault(Constant(''))();

  static Future<ChecklistCollectionsCompanion> fromMap(Map<String, dynamic> map) async {
    return ChecklistCollectionsCompanion(
      serverID: Value(map['id']),
      title: Value(map['title']),
      description: Value(map['description']),
      category: Value(map['category']),
    );
  }
}

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
    if (map['deleted'] == true) {
      return DeletedChecklistsCompanion(Value(map['id'] as String));
    }

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
  DeletedChecklistSeedsCompanion(serverID, checklistServerID)
      : super(serverID: serverID, checklistServerID: checklistServerID);
}

class SkipChecklistSeedsCompanion extends ChecklistSeedsCompanion {
  SkipChecklistSeedsCompanion(serverID, checklistServerID)
      : super(serverID: serverID, checklistServerID: checklistServerID);
}

class ChecklistSeeds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get checklist => integer()();
  IntColumn get collection => integer().nullable()();

  TextColumn get title => text().withDefault(Constant(''))();
  TextColumn get description => text().withDefault(Constant(''))();
  TextColumn get category => text().withDefault(Constant(''))();

  BoolColumn get fast => boolean().withDefault(Constant(false))();
  BoolColumn get public => boolean().withDefault(Constant(false))();
  BoolColumn get repeat => boolean().withDefault(Constant(false))();
  BoolColumn get mine => boolean().withDefault(Constant(true))();

  TextColumn get conditions => text().withDefault(Constant('[]'))();
  TextColumn get exitConditions => text().withDefault(Constant('[]'))();
  TextColumn get actions => text().withDefault(Constant('[]'))();

  TextColumn get checklistServerID => text().withLength(min: 36, max: 36).nullable()();
  TextColumn get checklistCollectionServerID => text().withLength(min: 36, max: 36).nullable()();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<ChecklistSeedsCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true) {
      return DeletedChecklistSeedsCompanion(Value(map['id'] as String), Value(map['checklistID'] as String));
    }
    Checklist checklist;
    try {
      checklist = await RelDB.get().checklistsDAO.getChecklistForServerID(map['checklistID']);
    } catch (e) {
      return SkipChecklistSeedsCompanion(Value(map['id'] as String), Value(map['checklistID'] as String));
    }
    return ChecklistSeedsCompanion(
      checklist: Value(checklist.id),
      fast: Value(map['fast']),
      public: Value(map['public']),
      repeat: Value(map['repeat']),
      mine: Value(map['mine']),
      title: Value(map['title']),
      description: Value(map['description']),
      category: Value(map['category']),
      conditions: Value(map['conditions']),
      exitConditions: Value(map['exitConditions']),
      actions: Value(map['actions']),
      serverID: Value(map['id'] as String),
      checklistServerID: Value(map['checklistID'] as String),
      checklistCollectionServerID: Value(map['collectionID'] as String),
      synced: Value(true),
    );
  }

  static Future<Map<String, dynamic>> toMap(ChecklistSeed checklistSeed) async {
    Checklist checklist = await RelDB.get().checklistsDAO.getChecklist(checklistSeed.checklist);
    return {
      'id': checklistSeed.serverID,
      'checklistID': checklist.serverID,
      'fast': checklistSeed.fast,
      'public': checklistSeed.public,
      'repeat': checklistSeed.repeat,
      'title': checklistSeed.title,
      'description': checklistSeed.description,
      'category': checklistSeed.category,
      'conditions': checklistSeed.conditions,
      'exitConditions': checklistSeed.exitConditions,
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

  BoolColumn get noRepeat => boolean().withDefault(Constant(false))();
  BoolColumn get checked => boolean().withDefault(Constant(false))();
  BoolColumn get skipped => boolean().withDefault(Constant(false))();

  DateTimeColumn get date => dateTime()();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<ChecklistLogsCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true || map['checked'] || map['skipped']) {
      return DeletedChecklistLogsCompanion(Value(map['id'] as String));
    }

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
      'noRepeat': checklistLog.noRepeat,
    };
  }
}

@DriftAccessor(tables: [
  Checklists,
  ChecklistSeeds,
  ChecklistLogs,
  ChecklistCollections,
], queries: {
  'getNLogs': '''
    select count(*) from checklist_logs where checked=false and skipped=false and checklist=?
  ''',
  'getNLogsTotal': '''
    select count(*) from checklist_logs where checked=false and skipped=false
  ''',
  'getNLogsPerPlants': '''
    select
      checklists.plant,
      (select
        count(*)
        from checklist_logs
        where checked=false and skipped=false and checklist_logs.checklist = checklists.id
      ) as nPending
    from checklists where nPending > 0
  '''
})
class ChecklistsDAO extends DatabaseAccessor<RelDB> with _$ChecklistsDAOMixin {
  ChecklistsDAO(RelDB db) : super(db);

  Future<int> addChecklist(ChecklistsCompanion checklist) {
    return into(checklists).insert(checklist);
  }

  Future<int> addChecklistCollection(ChecklistCollectionsCompanion checklistCollection) {
    return into(checklistCollections).insert(checklistCollection);
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

  Future<ChecklistCollection> getChecklistCollection(int id) {
    return (select(checklistCollections)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<ChecklistCollection> getChecklistCollectionForServerID(Checklist checklist, String id) {
    return (select(checklistCollections)..where((p) => p.serverID.equals(id) & p.checklist.equals(checklist.id)))
        .getSingle();
  }

  Future<List<ChecklistCollection>> getChecklistCollectionsForChecklist(Checklist checklist) {
    return (select(checklistCollections)..where((p) => p.checklist.equals(checklist.id))).get();
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

  Future<List<ChecklistLog>> getChecklistLogsForChecklistSeed(ChecklistSeed checklistSeed) {
    return (select(checklistLogs)..where((cks) => cks.checklistSeed.equals(checklistSeed.id))).get();
  }

  Future<List<ChecklistLog>> getActiveChecklistLogsForChecklistSeed(ChecklistSeed checklistSeed) {
    return (select(checklistLogs)
          ..where((cks) =>
              cks.checklistSeed.equals(checklistSeed.id) & cks.checked.equals(false) & cks.skipped.equals(false)))
        .get();
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
    return (select(checklistSeeds)
          ..where((p) => p.checklist.equals(checklistID))
          ..orderBy([
            (t) => OrderingTerm(expression: t.mine, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<List<ChecklistLog>> getChecklistLogs(int checklistID, {int limit = 0, int offset = 0}) {
    var query = (select(checklistLogs)
      ..where((p) => p.checklist.equals(checklistID) & p.checked.equals(false) & p.skipped.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]));
    if (limit != 0) {
      query = query..limit(limit, offset: offset);
    }
    return query.get();
  }

  Future<List<ChecklistCollection>> getChecklistCollections(int checklistID) {
    return (select(checklistCollections)..where((p) => p.checklist.equals(checklistID))).get();
  }

  Stream<List<ChecklistLog>> watchAllChecklistLogs() {
    return (select(checklistLogs)..where((p) => p.checked.equals(false) & p.skipped.equals(false))).watch();
  }

  Stream<List<ChecklistLog>> watchChecklistLogs(int checklistID) {
    return (select(checklistLogs)
          ..where((p) => p.checklist.equals(checklistID) & p.checked.equals(false) & p.skipped.equals(false)))
        .watch();
  }

  Stream<List<ChecklistCollection>> watchCollections(int checklistID) {
    return (select(checklistCollections)..where((p) => p.checklist.equals(checklistID))).watch();
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

  Stream<List<Checklist>> watchChecklist(int checklistID) {
    return (select(checklists)..where((p) => p.id.equals(checklistID))).watch();
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

  Future<int> getNPendingLogsTotal(Checklist checklist) {
    return getNLogsTotal().getSingle();
  }

  Future<int> getNPendingLogs(Checklist checklist) {
    return getNLogs(checklist.id).getSingle();
  }
}
