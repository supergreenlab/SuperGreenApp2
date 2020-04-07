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

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'feeds.g.dart';

class Feeds extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 24)();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static FeedsCompanion fromJSON(Map<String, dynamic> map) {
    return FeedsCompanion(
        name: Value(map['name'] as String),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }
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

  static FeedEntriesCompanion fromJSON(Map<String, dynamic> map) {
    return FeedEntriesCompanion(
        date: Value(DateTime.parse(map['date'] as String)),
        type: Value(map['type'] as String),
        isNew: Value(true),
        params: Value(map['params'] as String),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }
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

  static FeedMediasCompanion fromJSON(Map<String, dynamic> map) {
    return FeedMediasCompanion(
        params: Value(map['params'] as String),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }
}

@UseDao(tables: [
  Feeds,
  FeedEntries,
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
    return (update(feeds)..where((tbl) => tbl.id.equals(feed.id.value)))
        .write(feed);
  }

  Future<Feed> getFeed(int feedID) {
    return (select(feeds)..where((f) => f.id.equals(feedID))).getSingle();
  }

  Future<Feed> getFeedForServerID(String serverID) {
    return (select(feeds)..where((f) => f.serverID.equals(serverID)))
        .getSingle();
  }

  Future<List<Feed>> getUnsyncedFeeds() {
    return (select(feeds)..where((f) => f.synced.equals(false))).get();
  }

  Future deleteFeed(Feed feed) {
    return delete(feeds).delete(feed);
  }

  SimpleSelectStatement<FeedEntries, FeedEntry> _selectEntries(int feedID) {
    return (select(feedEntries)
      ..where((fe) => fe.feed.equals(feedID))
      ..orderBy(
          [(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]));
  }

  Future<List<FeedEntry>> getEntries(int feedID) {
    return _selectEntries(feedID).get();
  }

  Stream<List<FeedEntry>> watchEntries(int feedID) {
    return _selectEntries(feedID).watch();
  }

  Future<List<FeedEntry>> getEnvironmentEntries(int feedID) {
    return (select(feedEntries)
          ..where((fe) =>
              fe.feed.equals(feedID) &
              fe.type.isIn([
                'FE_LIGHT',
                'FE_VENTILATION',
                'FE_SCHEDULE',
                'FE_WATER',
                'FE_TRANSPLANT'
              ]))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<int> addFeedEntry(FeedEntriesCompanion feedEntry) {
    return into(feedEntries).insert(feedEntry);
  }

  Future<FeedEntry> getFeedEntry(int feedEntryID) {
    return (select(feedEntries)..where((f) => f.id.equals(feedEntryID)))
        .getSingle();
  }

  Future<FeedEntry> getFeedEntryForServerID(String serverID) {
    return (select(feedEntries)..where((fe) => fe.serverID.equals(serverID)))
        .getSingle();
  }

  Future<int> getNMeasures() {
    return getNFeedEntriesWithType('FE_MEASURE').getSingle();
  }

  Future<List<FeedEntry>> getUnsyncedFeedEntries() {
    return (select(feedEntries)..where((f) => f.synced.equals(false))).get();
  }

  Future updateFeedEntry(FeedEntriesCompanion feedEntry) {
    return (update(feedEntries)
          ..where((tbl) => tbl.id.equals(feedEntry.id.value)))
        .write(feedEntry);
  }

  Future deleteFeedEntry(FeedEntry feedEntry) {
    return delete(feedEntries).delete(feedEntry);
  }

  Future deleteFeedEntriesForFeed(int feedID) {
    return (delete(feedEntries)..where((fe) => fe.feed.equals(feedID))).go();
  }

  Future<int> addFeedMedia(FeedMediasCompanion feedMediaEntry) {
    return into(feedMedias).insert(feedMediaEntry);
  }

  Future updateFeedMedia(FeedMediasCompanion feedMedia) {
    return (update(feedMedias)
          ..where((tbl) => tbl.id.equals(feedMedia.id.value)))
        .write(feedMedia);
  }

  Future<List<FeedMedia>> getFeedMediasWithType(
      int feedID, String feedType) async {
    JoinedSelectStatement<FeedMedias, FeedMedia> query = select(feedMedias)
        .join([
      leftOuterJoin(feedEntries, feedEntries.id.equalsExp(feedMedias.feedEntry))
    ]);
    query.where(
        feedEntries.feed.equals(feedID) & feedEntries.type.equals(feedType));
    query.orderBy(
        [OrderingTerm(expression: feedEntries.date, mode: OrderingMode.desc)]);
    return (await query.get())
        .map<FeedMedia>((e) => e.readTable(feedMedias))
        .toList();
  }

  Future<List<FeedMedia>> getFeedMedias(int feedEntryID) {
    return (select(feedMedias)..where((f) => f.feedEntry.equals(feedEntryID)))
        .get();
  }

  Future<List<FeedMedia>> getUnsyncedFeedMedias() {
    return (select(feedMedias)..where((f) => f.synced.equals(false))).get();
  }

  Future<FeedMedia> getFeedMedia(int feedMediaID) {
    return (select(feedMedias)..where((f) => f.id.equals(feedMediaID)))
        .getSingle();
  }

  Future<FeedMedia> getFeedMediaForServerID(String serverID) {
    return (select(feedMedias)..where((fe) => fe.serverID.equals(serverID)))
        .getSingle();
  }

  Future deleteFeedMedia(FeedMedia feedMedia) {
    return delete(feedMedias).delete(feedMedia);
  }

  Future deleteFeedMediasForFeed(int feedID) {
    return (delete(feedMedias)..where((fm) => fm.feed.equals(feedID))).go();
  }

  Future deleteFeedMediasForFeedEntry(int feedEntryID) {
    return (delete(feedMedias)..where((fm) => fm.feedEntry.equals(feedEntryID)))
        .go();
  }
}
