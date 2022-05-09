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

import 'package:event_bus/event_bus.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedEntryInsertEvent {
  final FeedEntry feedEntry;

  FeedEntryInsertEvent(this.feedEntry);
}

class FeedEntryUpdateEvent {
  final FeedEntry? feedEntry;

  FeedEntryUpdateEvent(this.feedEntry);
}

class FeedEntryDeleteEvent {
  final FeedEntry feedEntry;

  FeedEntryDeleteEvent(this.feedEntry);
}

class FeedEntryHelper {
  static EventBus eventBus = EventBus(sync: true);

  static Future<int> addFeedEntry(FeedEntriesCompanion newFeedEntry) async {
    int feedEntryID = await RelDB.get().feedsDAO.addFeedEntry(newFeedEntry);
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(feedEntryID);
    eventBus.fire(FeedEntryInsertEvent(feedEntry));
    return feedEntryID;
  }

  static Future<void> updateFeedEntry(FeedEntriesCompanion newFeedEntry) async {
    await RelDB.get().feedsDAO.updateFeedEntry(newFeedEntry);
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(newFeedEntry.id.value);
    eventBus.fire(FeedEntryUpdateEvent(feedEntry));
  }

  static Future<void> deleteFeedEntry(FeedEntry feedEntry, {addDeleted: true}) async {
    await RelDB.get().feedsDAO.deleteFeedEntry(feedEntry);
    if (addDeleted && feedEntry.serverID != null) {
      await RelDB.get()
          .deletesDAO
          .addDelete(DeletesCompanion(serverID: Value(feedEntry.serverID!), type: Value('feedentries')));
    }

    List<FeedMedia> feedMedias = await RelDB.get().feedsDAO.getFeedMedias(feedEntry.id);
    for (FeedMedia feedMedia in feedMedias) {
      await FeedEntryHelper.deleteFeedMedia(feedMedia, addDeleted: addDeleted);
    }
    eventBus.fire(FeedEntryDeleteEvent(feedEntry));
  }

  static Future<void> deleteFeedMedia(FeedMedia feedMedia, {addDeleted: true}) async {
    try {
      await File(FeedMedias.makeAbsoluteFilePath(feedMedia.filePath)).delete();
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"filePath": feedMedia.filePath});
    }
    try {
      await File(FeedMedias.makeAbsoluteFilePath(feedMedia.thumbnailPath)).delete();
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"filePath": feedMedia.thumbnailPath});
    }
    await RelDB.get().feedsDAO.deleteFeedMedia(feedMedia);
    if (addDeleted && feedMedia.serverID != null) {
      await RelDB.get()
          .deletesDAO
          .addDelete(DeletesCompanion(serverID: Value(feedMedia.serverID!), type: Value('feedmedias')));
    }
  }

  static Future<void> deleteFeed(Feed feed, {addDeleted: true}) async {
    feed = await RelDB.get().feedsDAO.getFeed(feed.id);
    List<FeedEntry> feedEntries = await RelDB.get().feedsDAO.getAllFeedEntriesForFeed(feed.id);
    for (FeedEntry feedEntry in feedEntries) {
      await FeedEntryHelper.deleteFeedEntry(feedEntry, addDeleted: addDeleted);
    }
    await RelDB.get().feedsDAO.deleteFeed(feed);
    if (addDeleted && feed.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(DeletesCompanion(serverID: Value(feed.serverID!), type: Value('feeds')));
    }
  }
}
