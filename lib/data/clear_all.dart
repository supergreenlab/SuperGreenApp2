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

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class ClearAllState {
  final int nItems;
  final int totalItems;

  ClearAllState(this.nItems, this.totalItems);
}

class ClearAll {
  static Stream<ClearAllState> clear() async* {
    yield ClearAllState(0, 0);
    List<FeedMedia> feedMedias = await RelDB.get().feedsDAO.getAllFeedMedias();
    yield ClearAllState(0, feedMedias.length * 2);
    int i = 0;
    for (FeedMedia feedMedia in feedMedias) {
      try {
        await File(FeedMedias.makeAbsoluteFilePath(feedMedia.filePath)).delete();
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"filePath": feedMedia.filePath});
      }
      yield ClearAllState(++i, feedMedias.length * 2);
      try {
        await File(FeedMedias.makeAbsoluteFilePath(feedMedia.thumbnailPath)).delete();
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"filePath": feedMedia.thumbnailPath});
      }
      yield ClearAllState(++i, feedMedias.length * 2);
    }

    try {
      await RelDB.get().close();
      await File(FeedMedias.makeAbsoluteFilePath('db.sqlite')).delete();
      RelDB.get().reconnect();
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"filePath": 'db.sqlite'});
    }
    try {
      await AppDB().clearData();
    } catch (e, trace) {
      Logger.logError(e, trace);
    }

    try {
      await Logger.clearLogs();
    } catch (e, trace) {
      Logger.logError(e, trace);
    }
  }

  static Stream<ClearAllState> clearServerIDs() async* {
    List<FeedMedia> feedMedias = await RelDB.get().feedsDAO.getAllFeedMedias();
    int i = 0;
    yield ClearAllState(0, feedMedias.length);
    i = 0;
    for (FeedMedia feedMedia in feedMedias) {
      await RelDB.get().feedsDAO.updateFeedMedia(feedMedia.toCompanion(true).copyWith(serverID: Value(null), synced: Value(false)));
      yield ClearAllState(++i, feedMedias.length);
    }
    List<FeedEntry> feedEntries = await RelDB.get().feedsDAO.getAllFeedEntries();
    i = 0;
    yield ClearAllState(0, feedEntries.length);
    for (FeedEntry feedEntry in feedEntries) {
      await RelDB.get().feedsDAO.updateFeedEntry(feedEntry.toCompanion(true).copyWith(serverID: Value(null), synced: Value(false)));
      yield ClearAllState(++i, feedEntries.length);
    }

    List<Feed> feeds = await RelDB.get().feedsDAO.getAllFeeds();
    i = 0;
    yield ClearAllState(0, feeds.length);
    for (Feed feed in feeds) {
      await RelDB.get().feedsDAO.updateFeed(feed.toCompanion(true).copyWith(serverID: Value(null), synced: Value(false)));
      yield ClearAllState(++i, feeds.length);
    }

    List<Plant> plants = await RelDB.get().plantsDAO.getPlants();
    i = 0;
    yield ClearAllState(0, plants.length);
    for (Plant plant in plants) {
      await RelDB.get().plantsDAO.updatePlant(plant.toCompanion(true).copyWith(serverID: Value(null), synced: Value(false)));
      yield ClearAllState(++i, plants.length);
    }

    List<Timelapse> timelapses = await RelDB.get().plantsDAO.getAllTimelapses();
    i = 0;
    yield ClearAllState(0, timelapses.length);
    for (Timelapse timelapse in timelapses) {
      await RelDB.get().plantsDAO.updateTimelapse(timelapse.toCompanion(true).copyWith(serverID: Value(null), synced: Value(false)));
      yield ClearAllState(++i, timelapses.length);
    }

    List<Box> boxes = await RelDB.get().plantsDAO.getBoxes();
    i = 0;
    yield ClearAllState(0, boxes.length);
    for (Box box in boxes) {
      await RelDB.get().plantsDAO.updateBox(box.toCompanion(true).copyWith(serverID: Value(null), synced: Value(false)));
      yield ClearAllState(++i, boxes.length);
    }

    List<Device> devices = await RelDB.get().devicesDAO.getDevices();
    i = 0;
    yield ClearAllState(0, devices.length);
    for (Device device in devices) {
      await RelDB.get().devicesDAO.updateDevice(device.toCompanion(true).copyWith(serverID: Value(null), synced: Value(false)));
      yield ClearAllState(++i, devices.length);
    }

    await RelDB.get().deletesDAO.removeDeletes(await RelDB.get().deletesDAO.getDeletes());
  }
}
