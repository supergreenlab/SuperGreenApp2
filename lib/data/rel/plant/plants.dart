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
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'plants.g.dart';

class DeletedPlantsCompanion extends PlantsCompanion {
  DeletedPlantsCompanion(serverID) : super(serverID: serverID);
}

class Plants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  IntColumn get box => integer()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  // TODO remove the single param, it's moved to the settings json string
  BoolColumn get single => boolean().withDefault(Constant(false))();
  BoolColumn get public => boolean().withDefault(Constant(false))();
  BoolColumn get alerts => boolean().withDefault(Constant(true))();

  TextColumn get settings => text().withDefault(Constant('{}'))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<PlantsCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true || map['archived'] == true) {
      return DeletedPlantsCompanion(Value(map['id'] as String));
    }
    Feed feed = await RelDB.get().feedsDAO.getFeedForServerID(map['feedID']);
    Box box = await RelDB.get().plantsDAO.getBoxForServerID(map['boxID']);
    return PlantsCompanion(
        feed: Value(feed.id),
        box: Value(box.id),
        name: Value(map['name'] as String),
        single: Value(map['single'] as bool),
        public: Value(map['public'] as bool),
        alerts: Value(map['alertsEnabled'] as bool),
        settings: Value(map['settings'] as String),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }

  static Future<Map<String, dynamic>> toMap(Plant plant) async {
    Feed feed = await RelDB.get().feedsDAO.getFeed(plant.feed);
    if (feed.serverID == null) {
      Logger.throwError('Missing serverID for feed relation', data: {"plant": plant});
    }
    Box box = await RelDB.get().plantsDAO.getBox(plant.box);
    if (box.serverID == null) {
      Logger.throwError('Missing serverID for box relation', data: {"box": box});
    }

    return {
      'id': plant.serverID,
      'feedID': feed.serverID,
      'boxID': box.serverID,
      'name': plant.name,
      'single': plant.single,
      'public': plant.public,
      'alertsEnabled': plant.alerts,
      'settings': plant.settings,
    };
  }
}

class DeletedBoxesCompanion extends BoxesCompanion {
  DeletedBoxesCompanion(serverID) : super(serverID: serverID);
}

@DataClassName("Box")
class Boxes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer().nullable()();
  IntColumn get device => integer().nullable()();
  IntColumn get deviceBox => integer().nullable()();
  IntColumn get screenDevice => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get settings => text().withDefault(Constant('{}'))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<BoxesCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true) {
      return DeletedBoxesCompanion(Value(map['id'] as String));
    }
    int? deviceID;
    if (map['deviceID'] != null) {
      Device device = await RelDB.get().devicesDAO.getDeviceForServerID(map['deviceID']);
      deviceID = device.id;
    }

    int? screenDeviceID;
    if (map['screenDeviceID'] != null) {
      Device device = await RelDB.get().devicesDAO.getDeviceForServerID(map['screenDeviceID']);
      screenDeviceID = device.id;
    }

    int? feedID;
    if (map['feedID'] != null) {
      Feed feed = await RelDB.get().feedsDAO.getFeedForServerID(map['feedID']);
      feedID = feed.id;
    }
    return BoxesCompanion(
        feed: Value(feedID),
        device: Value(deviceID),
        deviceBox: Value(map['deviceBox'] as int?),
        screenDevice: Value(screenDeviceID),
        name: Value(map['name'] as String),
        settings: Value(map['settings'] as String),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }

  static Future<Map<String, dynamic>> toMap(Box box) async {
    Map<String, dynamic> obj = {
      'id': box.serverID,
      'name': box.name,
      'settings': box.settings,
      'feedID': null,
      'deviceID': null,
      'screenDeviceID': null,
    };
    if (box.device != null) {
      late Device device;
      try {
        device = await RelDB.get().devicesDAO.getDevice(box.device!);
      } catch (e) {
        Logger.throwError('Missing serverID for device relation', data: {"box": box, "device": box.device});
      }
      obj['deviceID'] = device.serverID;
      obj['deviceBox'] = box.deviceBox;
    }
    if (box.screenDevice != null) {
      late Device device;
      try {
        device = await RelDB.get().devicesDAO.getDevice(box.screenDevice!);
      } catch (e) {
        Logger.throwError('Missing serverID for device relation', data: {"box": box, "device": box.device});
      }
      obj['screenDeviceID'] = device.serverID;
    }
    if (box.feed != null) {
      Feed feed = await RelDB.get().feedsDAO.getFeed(box.feed!);
      if (feed.serverID == null) {
        Logger.throwError('Missing serverID for feed relation', data: {"box": box, "feed": feed});
      }
      obj['feedID'] = feed.serverID;
    }
    return obj;
  }
}

class ChartCaches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get box => integer()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  DateTimeColumn get date => dateTime()();

  TextColumn get values => text().withDefault(Constant('[]'))();
}

class DeletedTimelapsesCompanion extends TimelapsesCompanion {
  DeletedTimelapsesCompanion(serverID) : super(serverID: serverID);
}

class Timelapses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plant => integer()();

  TextColumn get type => text().withDefault(Constant('dropbox')).withLength(min: 1, max: 32)();
  TextColumn get settings => text().withDefault(Constant('{}'))();

  // TODO: remove those fields
  TextColumn get ssid => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get password => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get controllerID => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get rotate => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get name => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get strain => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get dropboxToken => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get uploadName => text().withLength(min: 1, max: 64).nullable()();
  // /TODO

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<TimelapsesCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true) {
      return DeletedTimelapsesCompanion(Value(map['id'] as String));
    }
    Plant plant = await RelDB.get().plantsDAO.getPlantForServerID(map['plantID']);
    return TimelapsesCompanion(
      plant: Value(plant.id),
      type: Value(map['type']),
      settings: Value(map['settings']),
      synced: Value(true),
      serverID: Value(map['id'] as String),
    );
  }

  static Future<Map<String, dynamic>> toMap(Timelapse timelapse) async {
    Plant plant = await RelDB.get().plantsDAO.getPlant(timelapse.plant);
    if (plant.serverID == null) {
      Logger.throwError('Missing serverID for plant relation', data: {"timelapse": timelapse, "plant": plant});
    }
    return {
      'id': timelapse.serverID,
      'plantID': plant.serverID,
      'type': timelapse.type,
      'settings': timelapse.settings,
    };
  }
}

@DriftAccessor(tables: [
  Plants,
  Boxes,
  ChartCaches,
  Timelapses,
], queries: {
  'nPlants': 'SELECT COUNT(*) FROM plants',
  'nBoxes': 'SELECT COUNT(*) FROM boxes',
  'nTimelapses': 'SELECT COUNT(*) FROM timelapses WHERE plant = ?',
  'nPlantsInBox': 'SELECT COUNT(*) FROM plants WHERE box = ?',
})
class PlantsDAO extends DatabaseAccessor<RelDB> with _$PlantsDAOMixin {
  PlantsDAO(RelDB db) : super(db);

  Future<Plant> getPlant(int id) {
    return (select(plants)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<Plant> getPlantForServerID(String serverID) {
    return (select(plants)..where((p) => p.serverID.equals(serverID))).getSingle();
  }

  Future<Plant> getLastPlant() {
    return (select(plants)
          ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])
          ..limit(1))
        .getSingle();
  }

  Future<List<Plant>> getPlants() {
    return (select(plants)..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])).get();
  }

  Stream<List<Plant>> watchPlants() {
    return (select(plants)..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])).watch();
  }

  Future<List<Plant>> getUnsyncedPlants() {
    return (select(plants)..where((p) => p.synced.equals(false))).get();
  }

  Future<List<Plant>> getPlantsInBox(int boxID) {
    return (select(plants)..where((p) => p.box.equals(boxID))).get();
  }

  Future<Plant> getPlantWithFeed(int feedID) {
    return (select(plants)..where((p) => p.feed.equals(feedID))).getSingle();
  }

  Stream<Plant> watchPlant(int id) {
    return (select(plants)..where((p) => p.id.equals(id))).watchSingle();
  }

  Future<int> addPlant(PlantsCompanion plant) {
    return into(plants).insert(plant);
  }

  Future updatePlant(PlantsCompanion plant) {
    return (update(plants)..where((p) => p.id.equals(plant.id.value))).write(plant);
  }

  Future deletePlant(Plant plant) {
    return delete(plants).delete(plant);
  }

  Future<Box> getBox(int id) {
    return (select(boxes)..where((b) => b.id.equals(id))).getSingle();
  }

  Future<Box> getBoxForServerID(String serverID) {
    return (select(boxes)..where((b) => b.serverID.equals(serverID))).getSingle();
  }

  Future<Box> getBoxWithFeed(int feedID) {
    return (select(boxes)..where((p) => p.feed.equals(feedID))).getSingle();
  }

  Future<List<Box>> getBoxes() {
    return (select(boxes)..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])).get();
  }

  Future<List<Box>> getUnsyncedBoxes() {
    return (select(boxes)..where((b) => b.synced.equals(false))).get();
  }

  Stream<List<Box>> watchBoxes() {
    return (select(boxes)..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])).watch();
  }

  Stream<Box> watchBox(int id) {
    return (select(boxes)..where((b) => b.id.equals(id))).watchSingle();
  }

  Future<int> addBox(BoxesCompanion box) {
    return into(boxes).insert(box);
  }

  Future updateBox(BoxesCompanion box) {
    return (update(boxes)..where((b) => b.id.equals(box.id.value))).write(box);
  }

  Future deleteBox(Box box) {
    return delete(boxes).delete(box);
  }

  Future cleanDeviceIDs(int deviceID) {
    return (update(boxes)..where((b) => b.device.equals(deviceID)))
        .write(BoxesCompanion(device: Value(null), synced: Value(false)));
  }

  Future<int> addChartCache(ChartCachesCompanion chartCache) {
    return into(chartCaches).insert(chartCache);
  }

  Future<ChartCache?> getChartCache(int boxID, String name) async {
    List<ChartCache> cs = await (select(chartCaches)..where((c) => c.box.equals(boxID) & c.name.equals(name))).get();
    if (cs.length == 0) {
      return null;
    }
    return cs[0];
  }

  Stream<ChartCache> watchChartCache(int boxID, String name) {
    return (select(chartCaches)..where((c) => c.box.equals(boxID) & c.name.equals(name))).watchSingle();
  }

  Future deleteChartCacheForBox(int boxID) {
    return (delete(chartCaches)..where((cc) => cc.box.equals(boxID))).go();
  }

  Future deleteChartCache(ChartCache chartCache) {
    return delete(chartCaches).delete(chartCache);
  }

  Future<List<Timelapse>> getTimelapses(int plantID) {
    return (select(timelapses)..where((t) => t.plant.equals(plantID))).get();
  }

  Future<List<Timelapse>> getAllTimelapses() {
    return select(timelapses).get();
  }

  Future<Timelapse> getTimelapse(int timelapseID) {
    return (select(timelapses)..where((t) => t.id.equals(timelapseID))).getSingle();
  }

  Future<Timelapse> getTimelapseForServerID(String serverID) {
    return (select(timelapses)..where((t) => t.serverID.equals(serverID))).getSingle();
  }

  Future<List<Timelapse>> getUnsyncedTimelapses() {
    return (select(timelapses)..where((b) => b.synced.equals(false))).get();
  }

  Future<int> addTimelapse(TimelapsesCompanion timelapse) {
    return into(timelapses).insert(timelapse);
  }

  Future updateTimelapse(TimelapsesCompanion timelapse) {
    return (update(timelapses)..where((t) => t.id.equals(timelapse.id.value))).write(timelapse);
  }

  Future deleteTimelapse(Timelapse timelapse) {
    return delete(timelapses).delete(timelapse);
  }
}
