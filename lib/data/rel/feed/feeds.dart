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
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'feeds.g.dart';

class DeletedFeedsCompanion extends FeedsCompanion {
  DeletedFeedsCompanion(serverID) : super(serverID: serverID);
}

class Feeds extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 24)();
  BoolColumn get isNewsFeed => boolean().withDefault(Constant(false))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<FeedsCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true) {
      return DeletedFeedsCompanion(Value(map['id'] as String));
    }
    return FeedsCompanion(
        name: Value(map['name'] as String),
        isNewsFeed: Value(map['isNewsFeed'] as bool),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }

  static Future<Map<String, dynamic>> toMap(Feed feed) async {
    return {
      'id': feed.serverID,
      'name': feed.name,
      'isNewsFeed': feed.isNewsFeed,
    };
  }
}

class DeletedFeedEntriesCompanion extends FeedEntriesCompanion {
  DeletedFeedEntriesCompanion(serverID) : super(serverID: serverID);
}

class SkipFeedEntriesCompanion extends FeedEntriesCompanion {
  SkipFeedEntriesCompanion(serverID) : super(serverID: serverID);
}

@DataClassName("FeedEntry")
class FeedEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text().withLength(min: 1, max: 24)();
  BoolColumn get isNew => boolean().withDefault(Constant(false))();

  TextColumn get params => text().withDefault(Constant('{}'))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<FeedEntriesCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true) {
      return DeletedFeedEntriesCompanion(Value(map['id'] as String));
    }
    Feed feed;
    try {
      feed = await RelDB.get().feedsDAO.getFeedForServerID(map['feedID']);
    } catch (e) {
      return SkipFeedEntriesCompanion(Value(map['id'] as String));
    }
    return FeedEntriesCompanion(
        feed: Value(feed.id),
        date: Value(DateTime.parse(map['date'] as String).toLocal()),
        type: Value(map['type'] as String),
        isNew: Value(true),
        params: Value(map['params'] as String),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }

  static Future<Map<String, dynamic>> toMap(FeedEntry feedEntry) async {
    Feed feed = await RelDB.get().feedsDAO.getFeed(feedEntry.feed);
    if (feed.serverID == null) {
      Logger.throwError('Missing serverID for feed relation');
    }
    Map<String, dynamic> params = JsonDecoder().convert(feedEntry.params);
    if (params['previous'] != null && params['previous'] is int) {
      FeedMedia feedMedia = await RelDB.get().feedsDAO.getFeedMedia(params['previous']);
      if (feedMedia.serverID == null) {
        Logger.throwError('Missing serverID for feedMedia relation',
            data: {"feedEntry": feedEntry, "feedMedia": feedMedia});
      }
      params['previous'] = feedMedia.serverID;
    }
    return {
      'id': feedEntry.serverID,
      'feedID': feed.serverID,
      'date': feedEntry.date.toUtc().toIso8601String(),
      'type': feedEntry.type,
      'params': JsonEncoder().convert(params),
    };
  }
}

class FeedEntryDrafts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  TextColumn get type => text().withLength(min: 1, max: 24)();

  TextColumn get params => text().withDefault(Constant('{}'))();
}

class DeletedFeedMediasCompanion extends FeedMediasCompanion {
  DeletedFeedMediasCompanion(serverID) : super(serverID: serverID);
}

class SkipFeedMediasCompanion extends FeedMediasCompanion {
  SkipFeedMediasCompanion(serverID) : super(serverID: serverID);
}

class FeedMedias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  IntColumn get feedEntry => integer()();
  TextColumn get filePath => text()();
  TextColumn get thumbnailPath => text()();

  TextColumn get params => text().withDefault(Constant('{}'))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static Future<FeedMediasCompanion> fromMap(Map<String, dynamic> map) async {
    if (map['deleted'] == true) {
      return DeletedFeedMediasCompanion(Value(map['id'] as String));
    }
    FeedEntry feedEntry;
    Feed feed;
    try {
      feedEntry = await RelDB.get().feedsDAO.getFeedEntryForServerID(map['feedEntryID']);
      feed = await RelDB.get().feedsDAO.getFeed(feedEntry.feed);
    } catch (e) {
      return SkipFeedMediasCompanion(Value(map['id'] as String));
    }
    return FeedMediasCompanion(
        feed: Value(feed.id),
        feedEntry: Value(feedEntry.id),
        filePath: Value(map['filePath']),
        thumbnailPath: Value(map['thumbnailPath']),
        params: Value(map['params'] as String),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }

  static Future<Map<String, dynamic>> toMap(FeedMedia feedMedia) async {
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(feedMedia.feedEntry);
    if (feedEntry.serverID == null) {
      Logger.throwError('Missing serverID for feedEntry relation', data: {"feedMedia": feedMedia});
    }

    return {
      'id': feedMedia.serverID,
      'feedEntryID': feedEntry.serverID,
      'filePath': feedMedia.filePath,
      'thumbnailPath': feedMedia.thumbnailPath,
      'params': feedMedia.params,
    };
  }

  static String makeFilePath({String prefix = ''}) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return FeedMedias.makeRelativeFilePath('$prefix$timestamp');
  }

  static String makeRelativeFilePath(String fileName) {
    final String filePath = 'Pictures/sgl/$fileName';
    return filePath;
  }

  static String makeAbsoluteFilePath(String filePath) {
    return '${AppDB().documentPath}/$filePath';
  }

  // TODO check when createCompaion comes back
  // Temporary replacement for createCompaion (coming back in next release:/)
  static FeedMediasCompanion toCompanion(FeedMedia feedMedia) {
    return FeedMediasCompanion(
        feed: Value(feedMedia.feed),
        feedEntry: Value(feedMedia.feedEntry),
        filePath: Value(feedMedia.filePath),
        thumbnailPath: Value(feedMedia.thumbnailPath),
        params: Value(feedMedia.params),
        synced: Value(feedMedia.synced),
        serverID: Value(feedMedia.serverID));
  }
}

@UseDao(tables: [
  Feeds,
  FeedEntries,
  FeedEntryDrafts,
  FeedMedias
], queries: {
  'getPendingFeeds': '''
    select
      feeds.id,
      (select
        count(*)
        from feed_entries
        where is_new = true and feed_entries.feed = feeds.id
      ) as nNew
    from feeds where nNew > 0
  ''',
  'getNFeedEntriesWithType': '''
    select count(*) from feed_entries where type = ?
  ''',
})
class FeedsDAO extends DatabaseAccessor<RelDB> with _$FeedsDAOMixin {
  FeedsDAO(RelDB db) : super(db);

  Future<int> addFeed(FeedsCompanion feed) {
    return into(feeds).insert(feed);
  }

  Future updateFeed(FeedsCompanion feed) {
    return (update(feeds)..where((tbl) => tbl.id.equals(feed.id.value))).write(feed);
  }

  Future<Feed> getFeed(int feedID) {
    return (select(feeds)..where((f) => f.id.equals(feedID))).getSingle();
  }

  Future<Feed> getFeedForServerID(String serverID) {
    return (select(feeds)..where((f) => f.serverID.equals(serverID))).getSingle();
  }

  Future<List<Feed>> getUnsyncedFeeds() {
    return (select(feeds)..where((f) => f.synced.equals(false))).get();
  }

  Future deleteFeed(Feed feed) {
    return delete(feeds).delete(feed);
  }

  SimpleSelectStatement<FeedEntries, FeedEntry> _selectFeedEntries(int feedID, int limit, int offset) {
    return (select(feedEntries)
      ..where((fe) => fe.feed.equals(feedID))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
      ..limit(limit, offset: offset));
  }

  Future<List<FeedEntry>> getFeedEntries(int feedID, int limit, int offset) {
    return _selectFeedEntries(feedID, limit, offset).get();
  }

  Future<List<FeedEntry>> getAllFeedEntriesForFeed(int feedID) {
    return (select(feedEntries)..where((fe) => fe.feed.equals(feedID))).get();
  }

  Future<List<FeedEntry>> getAllFeedEntries() {
    return select(feedEntries).get();
  }

  Future<List<FeedEntry>> getFeedEntriesWithType(String type) {
    return (select(feedEntries)..where((fe) => fe.type.equals(type))).get();
  }

  Future<List<FeedEntry>> getFeedEntriesForFeedWithType(int feedID, String type) {
    return (select(feedEntries)
          ..where((fe) => fe.type.equals(type) & fe.feed.equals(feedID))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Stream<List<FeedEntry>> watchFeedEntriesForFeedWithType(int feedID, String type) {
    return (select(feedEntries)
          ..where((fe) => fe.type.equals(type) & fe.feed.equals(feedID))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<FeedEntry?> getLastFeedEntryForFeedWithType(int feedID, String type) {
    return (select(feedEntries)
          ..where((fe) => fe.type.equals(type) & fe.feed.equals(feedID))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<FeedEntry?> watchLastFeedEntryForFeedWithType(int feedID, String type) {
    return (select(feedEntries)
          ..where((fe) => fe.type.equals(type) & fe.feed.equals(feedID))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<FeedEntry>> watchFeedEntries(int feedID, int limit, int offset) {
    return _selectFeedEntries(feedID, limit, offset).watch();
  }

  Future<List<FeedEntry>> getEnvironmentFeedEntries(int feedID) {
    return (select(feedEntries)
          ..where((fe) =>
              fe.feed.equals(feedID) &
              fe.type.isIn(['FE_LIGHT', 'FE_VENTILATION', 'FE_SCHEDULE', 'FE_WATER', 'FE_TRANSPLANT']))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> addFeedEntry(FeedEntriesCompanion feedEntry) {
    return into(feedEntries).insert(feedEntry);
  }

  Future<FeedEntry> getFeedEntry(int feedEntryID) {
    return (select(feedEntries)..where((f) => f.id.equals(feedEntryID))).getSingle();
  }

  Stream<FeedEntry> watchFeedEntry(int feedEntryID) {
    return (select(feedEntries)..where((f) => f.id.equals(feedEntryID))).watchSingle();
  }

  Future<FeedEntry> getFeedEntryForServerID(String serverID) {
    return (select(feedEntries)..where((fe) => fe.serverID.equals(serverID))).getSingle();
  }

  Future<int> getNMeasures() {
    return getNFeedEntriesWithType('FE_MEASURE').getSingle();
  }

  Future<List<FeedEntry>> getUnsyncedFeedEntries() {
    return (select(feedEntries)
          ..where((f) => f.synced.equals(false))
          ..orderBy([(fe) => OrderingTerm(expression: fe.id, mode: OrderingMode.asc)]))
        .get();
  }

  Future updateFeedEntry(FeedEntriesCompanion feedEntry) {
    return (update(feedEntries)..where((tbl) => tbl.id.equals(feedEntry.id.value))).write(feedEntry);
  }

  Future deleteFeedEntry(FeedEntry feedEntry) {
    return delete(feedEntries).delete(feedEntry);
  }

  Future deleteFeedEntriesForFeed(int feedID) {
    return (delete(feedEntries)..where((fe) => fe.feed.equals(feedID))).go();
  }

  Future<FeedEntryDraft> getEntryDraft(int feedID, String type) {
    return (select(feedEntryDrafts)..where((fe) => fe.type.equals(type) & fe.feed.equals(feedID))).getSingle();
  }

  Future<int> addFeedEntryDraft(FeedEntryDraftsCompanion feedEntryDraft) {
    return into(feedEntryDrafts).insert(feedEntryDraft);
  }

  Future updateFeedEntryDraft(FeedEntryDraftsCompanion feedEntryDraft) {
    return (update(feedEntryDrafts)..where((fed) => fed.id.equals(feedEntryDraft.id.value))).write(feedEntryDraft);
  }

  Future deleteFeedEntryDraft(int feedEntryDraftID) {
    return (delete(feedEntryDrafts)..where((fed) => fed.id.equals(feedEntryDraftID))).go();
  }

  Future<int> addFeedMedia(FeedMediasCompanion feedMediaEntry) {
    return into(feedMedias).insert(feedMediaEntry);
  }

  Future updateFeedMedia(FeedMediasCompanion feedMedia) {
    return (update(feedMedias)..where((tbl) => tbl.id.equals(feedMedia.id.value))).write(feedMedia);
  }

  Future<List<FeedMedia>> getFeedMediasWithType(String feedType,
      {int? feedID, bool? synced, bool? feedEntrySynced}) async {
    JoinedSelectStatement query =
        select(feedMedias).join([leftOuterJoin(feedEntries, feedEntries.id.equalsExp(feedMedias.feedEntry))]);
    Expression<bool?> where = feedEntries.type.equals(feedType);
    if (feedID != null) {
      where &= feedEntries.feed.equals(feedID);
    }
    if (feedEntrySynced != null) {
      where &= feedEntries.synced.equals(feedEntrySynced);
    }
    if (synced != null) {
      where &= feedMedias.synced.equals(synced);
    }
    query.where(where);
    query.orderBy([OrderingTerm(expression: feedEntries.date, mode: OrderingMode.desc)]);
    return (await query.get()).map<FeedMedia>((e) => e.readTable(feedMedias)).toList();
  }

  Future<List<FeedMedia>> getOrphanedFeedMedias() async {
    JoinedSelectStatement query =
        select(feedMedias).join([leftOuterJoin(feedEntries, feedEntries.id.equalsExp(feedMedias.feedEntry))]);
    query.where(feedEntries.synced.equals(true) & feedMedias.synced.equals(false));
    query.orderBy([OrderingTerm(expression: feedEntries.date, mode: OrderingMode.desc)]);
    return (await query.get()).map<FeedMedia>((e) => e.readTable(feedMedias)).toList();
  }

  Future<List<FeedMedia>> getAllFeedMedias() {
    return (select(feedMedias)).get();
  }

  Future<List<FeedMedia>> getFeedMedias(int feedEntryID) {
    return (select(feedMedias)..where((f) => f.feedEntry.equals(feedEntryID))).get();
  }

  Stream<List<FeedMedia>> watchFeedMedias(int feedEntryID) {
    return (select(feedMedias)..where((f) => f.feedEntry.equals(feedEntryID))).watch();
  }

  Future<List<FeedMedia>> getUnsyncedFeedMedias(int feedEntryID) {
    return (select(feedMedias)..where((f) => f.feedEntry.equals(feedEntryID) & f.synced.equals(false))).get();
  }

  Future<FeedMedia> getFeedMedia(int feedMediaID) {
    return (select(feedMedias)..where((f) => f.id.equals(feedMediaID))).getSingle();
  }

  Stream<FeedMedia> watchLastFeedMedia(int feedID) {
    JoinedSelectStatement query =
        select(feedMedias).join([leftOuterJoin(feedEntries, feedEntries.id.equalsExp(feedMedias.feedEntry))]);
    query.where(feedEntries.feed.equals(feedID));
    query.orderBy([OrderingTerm(expression: feedEntries.date, mode: OrderingMode.desc)]);
    query.limit(1);
    return (query.watchSingle()).map((e) => e.readTable(feedMedias));
  }

  Stream<FeedMedia> watchFeedMedia(int feedMediaID) {
    return (select(feedMedias)..where((f) => f.id.equals(feedMediaID))).watchSingle();
  }

  Future<FeedMedia> getFeedMediaForServerID(String serverID) {
    return (select(feedMedias)..where((fe) => fe.serverID.equals(serverID))).getSingle();
  }

  Stream<FeedMedia> watchFeedMediaForServerID(String serverID) {
    return (select(feedMedias)..where((fe) => fe.serverID.equals(serverID))).watchSingle();
  }

  Future deleteFeedMedia(FeedMedia feedMedia) {
    return delete(feedMedias).delete(feedMedia);
  }

  Future deleteFeedMediasForFeed(int feedID) {
    return (delete(feedMedias)..where((fm) => fm.feed.equals(feedID))).go();
  }

  Future deleteFeedMediasForFeedEntry(int feedEntryID) {
    return (delete(feedMedias)..where((fm) => fm.feedEntry.equals(feedEntryID))).go();
  }
}
