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

part 'plants.g.dart';

class Plants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  IntColumn get device => integer().nullable()();
  IntColumn get deviceBox => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get settings => text().withDefault(Constant('{}'))();
}

class ChartCaches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plant => integer()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  DateTimeColumn get date => dateTime()();

  TextColumn get values => text().withDefault(Constant('[]'))();
}

class Timelapses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plant => integer()();
  TextColumn get ssid => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get password => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get controllerID =>
      text().withLength(min: 1, max: 64).nullable()();
  TextColumn get rotate => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get name => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get strain => text().withLength(min: 1, max: 64).nullable()();
  TextColumn get dropboxToken =>
      text().withLength(min: 1, max: 64).nullable()();
  TextColumn get uploadName => text().withLength(min: 1, max: 64).nullable()();
}

@UseDao(tables: [
  Plants,
  ChartCaches,
  Timelapses,
], queries: {
  'nPlants': 'SELECT COUNT(*) FROM plants',
  'nTimelapses': 'SELECT COUNT(*) FROM timelapses WHERE plant = ?',
})
class PlantsDAO extends DatabaseAccessor<RelDB> with _$PlantsDAOMixin {
  PlantsDAO(RelDB db) : super(db);

  Future<Plant> getPlant(int id) {
    return (select(plants)..where((p) => p.id.equals(id))).getSingle();
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

  Future updatePlant(int plantID, PlantsCompanion plant) {
    return (update(plants)..where((b) => b.id.equals(plantID))).write(plant);
  }

  Future cleanDeviceIDs(int deviceID) {
    return (update(plants)..where((b) => b.device.equals(deviceID))).write(PlantsCompanion(device: Value(null)));
  }

  Stream<List<Plant>> watchPlants() {
    return select(plants).watch();
  }

  Future<int> addChartCache(ChartCachesCompanion chartCache) {
    return into(chartCaches).insert(chartCache);
  }

  Future<ChartCache> getChartCache(int plantID, String name) async {
    List<ChartCache> cs = await (select(chartCaches)
          ..where((c) => c.plant.equals(plantID) & c.name.equals(name)))
        .get();
    if (cs.length == 0) {
      return null;
    }
    return cs[0];
  }

  Stream<ChartCache> watchChartCache(int plantID, String name) {
    return (select(chartCaches)
          ..where((c) => c.plant.equals(plantID) & c.name.equals(name)))
        .watchSingle();
  }

  Future deleteChartCacheForPlant(int plantID) {
    return (delete(chartCaches)..where((cc) => cc.plant.equals(plantID))).go();
  }

  Future deleteChartCache(ChartCache chartCache) {
    return delete(chartCaches).delete(chartCache);
  }

  Future<List<Timelapse>> getTimelapses(int plantID) {
    return (select(timelapses)..where((t) => t.plant.equals(plantID))).get();
  }

  Future<int> addTimelapse(TimelapsesCompanion timelapse) {
    return into(timelapses).insert(timelapse);
  }

  // TODO move this to the kv store, separate from the plant concept
  Map<String, dynamic> plantSettings(Plant plant) {
    final Map<String, dynamic> settings = JsonDecoder().convert(plant.settings);
    // TODO make actual enums or constants
    return {
      'nPlants': 1,
      'phase': 'VEG', // VEG or BLOOM
      'plantType': 'PHOTO', // PHOTO or AUTO
      'schedule':
          settings['schedule'] ?? 'VEG', // Any of the schedule keys below
      'schedules': {
        'VEG': {
          'ON_HOUR': settings['VEG_ON_HOUR'] ?? 3,
          'ON_MIN': settings['VEG_ON_MIN'] ?? 0,
          'OFF_HOUR': settings['VEG_OFF_HOUR'] ?? 21,
          'OFF_MIN': settings['VEG_OFF_MIN'] ?? 0,
        },
        'BLOOM': {
          'ON_HOUR': settings['BLOOM_ON_HOUR'] ?? 6,
          'ON_MIN': settings['BLOOM_ON_MIN'] ?? 0,
          'OFF_HOUR': settings['BLOOM_OFF_HOUR'] ?? 18,
          'OFF_MIN': settings['BLOOM_OFF_MIN'] ?? 0,
        },
        'AUTO': {
          'ON_HOUR': settings['AUTO_ON_HOUR'] ?? 0,
          'ON_MIN': settings['AUTO_ON_MIN'] ?? 0,
          'OFF_HOUR': settings['AUTO_OFF_HOUR'] ?? 0,
          'OFF_MIN': settings['AUTO_OFF_MIN'] ?? 0,
        },
      }
    };
  }
}
