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
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/common/deletes.dart';
import 'package:super_green_app/data/rel/plant/plants.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_measure.dart';

part 'rel_db.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [
  Devices,
  Modules,
  Params,
  Plants,
  Boxes,
  ChartCaches,
  Timelapses,
  Feeds,
  FeedEntries,
  FeedEntryDrafts,
  FeedMedias,
  Deletes,
], daos: [
  DevicesDAO,
  PlantsDAO,
  FeedsDAO,
  DeletesDAO,
])
class RelDB extends _$RelDB {
  static RelDB _instance;

  factory RelDB.get() {
    if (_instance == null) {
      _instance = RelDB();
    }
    return _instance;
  }

  RelDB() : super(_openConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        for (int i = from; i < to; ++i) {
          await runMigrator(m, i);
        }
      }, beforeOpen: (OpeningDetails details) async {
        if (!details.hadUpgrade) {
          return;
        }
        for (int i = details.versionBefore; i < details.versionNow; ++i) {
          await runDataChange(i);
        }
      });

  Future<void> runMigrator(Migrator m, int fromVersion) async {
    if (fromVersion == 1) {
      await m.addColumn(plants, plants.box);
      await m.addColumn(plants, plants.single);
      await m.createTable(boxes);
      await m.issueCustomQuery(
          "insert into boxes (name, device, device_box, settings) select name, device, device_box, id as settings from plants");
    } else if (fromVersion == 2) {
      await m.addColumn(feeds, feeds.isNewsFeed);
    } else if (fromVersion == 3) {
      await m.addColumn(devices, devices.isSetup);
    } else if (fromVersion == 5) {
      await m.createTable(feedEntryDrafts);
    } else if (fromVersion == 6) {
      await m.createTable(deletes);
    } else if (fromVersion == 7) {
      await m.addColumn(plants, plants.public);
    }
  }

  Future<void> runDataChange(int fromVersion) async {
    if (fromVersion == 1) {
      List<Box> tmpBoxes = await plantsDAO.getBoxes();

      for (int i = 0; i < tmpBoxes.length; ++i) {
        Plant plant = await plantsDAO.getPlant(int.parse(tmpBoxes[i].settings));
        await plantsDAO.updatePlant(
            PlantsCompanion(id: Value(plant.id), box: Value(tmpBoxes[i].id)));
        await plantsDAO.updateBox(
            BoxesCompanion(id: Value(tmpBoxes[i].id), settings: Value('{}')));
      }
    } else if (fromVersion == 2) {
      Feed feed = await feedsDAO.getFeed(1);
      await feedsDAO.updateFeed(
          FeedsCompanion(id: Value(feed.id), isNewsFeed: Value(true)));
    } else if (fromVersion == 3) {
      List<Plant> plants = await plantsDAO.getPlants();
      for (int i = 0; i < plants.length; ++i) {
        Map<String, dynamic> settings = jsonDecode(plants[i].settings);
        settings['isSingle'] = plants[i].single;
        plantsDAO.updatePlant(PlantsCompanion(
            id: Value(plants[i].id), settings: Value(jsonEncode(settings))));
      }
    } else if (fromVersion == 4) {
      List<FeedMedia> feedMedias = await feedsDAO.getAllFeedMedias();
      for (int i = 0; i < feedMedias.length; ++i) {
        FeedMedia feedMedia = feedMedias[i];
        String filePath =
            FeedMedias.makeRelativeFilePath(basename(feedMedia.filePath));
        String thumbnailPath =
            FeedMedias.makeRelativeFilePath(basename(feedMedia.thumbnailPath));
        await feedsDAO.updateFeedMedia(FeedMediasCompanion(
          id: Value(feedMedia.id),
          filePath: Value(filePath),
          thumbnailPath: Value(thumbnailPath),
        ));
      }
    } else if (fromVersion == 5) {
      List<FeedEntry> measures =
          await feedsDAO.getFeedEntriesWithType('FE_MEASURE');
      for (FeedEntry measure in measures) {
        try {
          FeedMeasureParams params = FeedMeasureParams.fromJSON(measure.params);
          if (params.previous == null) {
            continue;
          }
          FeedMedia previous;
          if (params.previous is String) {
            previous = await feedsDAO.getFeedMediaForServerID(params.previous);
          } else {
            previous = await feedsDAO.getFeedMedia(params.previous);
          }
          FeedEntry previousEntry =
              await feedsDAO.getFeedEntry(previous.feedEntry);
          await feedsDAO.updateFeedEntry(FeedEntriesCompanion(
            id: Value(measure.id),
            synced: Value(false),
            params: Value(FeedMeasureParams(
                    params.message,
                    measure.date.difference(previousEntry.date).inSeconds,
                    params.previous)
                .toJSON()),
          ));
        } catch (e) {
          Logger.log(e);
        }
      }
    } else if (fromVersion == 6) {
      List<Device> devices = await devicesDAO.getDevices();
      for (Device device in devices) {
        if (device.synced == true && device.serverID == null) {
          await devicesDAO.updateDevice(
              DevicesCompanion(id: Value(device.id), synced: Value(false)));
        }
      }
    } else if (fromVersion == 8) {
      List<FeedMedia> feedMedias = await feedsDAO.getAllFeedMedias();
      List<int> mp4Header = [
        0x00,
        0x00,
        0x00,
        0x18,
        0x66,
        0x74,
        0x79,
        0x70,
        0x6D,
        0x70,
        0x34,
        0x32
      ];
      for (int i = 0; i < feedMedias.length; ++i) {
        FeedMedia feedMedia = feedMedias[i];
        if (feedMedia.filePath.indexOf('.') != -1) {
          continue;
        }
        try {
          String filePath = FeedMedias.makeAbsoluteFilePath(feedMedia.filePath);
          String thumbnailPath =
              FeedMedias.makeAbsoluteFilePath(feedMedia.thumbnailPath);
          List<int> header = (await File(filePath).openRead(0, 12).toList())
              .reduce((value, element) => value..addAll(element));
          if (listEquals(header, mp4Header)) {
            File(filePath).renameSync('$filePath.mp4');
            File(thumbnailPath).renameSync('$thumbnailPath.jpg');
            await feedsDAO.updateFeedMedia(FeedMediasCompanion(
              id: Value(feedMedia.id),
              filePath: Value('${feedMedia.filePath}.mp4'),
              thumbnailPath: Value('${feedMedia.thumbnailPath}.jpg'),
            ));
          } else {
            File(filePath).renameSync('$filePath.jpg');
            File(thumbnailPath).renameSync('$thumbnailPath.jpg');
            await feedsDAO.updateFeedMedia(FeedMediasCompanion(
              id: Value(feedMedia.id),
              filePath: Value('${feedMedia.filePath}.jpg'),
              thumbnailPath: Value('${feedMedia.thumbnailPath}.jpg'),
            ));
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }
}
