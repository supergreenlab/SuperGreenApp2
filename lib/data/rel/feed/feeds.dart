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
}

@DataClassName("FeedEntry")
class FeedEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text().withLength(min: 1, max: 24)();
  BoolColumn get isNew => boolean().withDefault(Constant(false))();

  TextColumn get params => text().withDefault(Constant('{}'))();
}

class FeedMedias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feedEntry => integer()();
  TextColumn get filePath => text()();
  TextColumn get thumbnailPath => text()();

  TextColumn get params => text().withDefault(Constant('{}'))();
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
})
class FeedsDAO extends DatabaseAccessor<RelDB> with _$FeedsDAOMixin {
  FeedsDAO(RelDB db) : super(db);

  Future<int> addFeed(FeedsCompanion feed) {
    return into(feeds).insert(feed);
  }

  Future<Feed> getFeed(int feedID) {
    return (select(feeds)..where((f) => f.id.equals(feedID))).getSingle();
  }

  Future<List<FeedEntry>> getEntries(int feedID) {
    return (select(feedEntries)
          ..where((fe) => fe.feed.equals(feedID))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Stream<List<FeedEntry>> watchEntries(int feedID) {
    return (select(feedEntries)
          ..where((fe) => fe.feed.equals(feedID))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<int> addFeedEntry(FeedEntriesCompanion feedEntry) {
    return into(feedEntries).insert(feedEntry);
  }

  Future updateFeedEntry(FeedEntriesCompanion feedEntry) {
    return update(feedEntries).replace(feedEntry);
  }

  Future<int> addFeedMedia(FeedMediasCompanion feedMediaEntry) {
    return into(feedMedias).insert(feedMediaEntry);
  }

  Future<List<FeedMedia>> getFeedMedias(int feedEntryID) {
    return (select(feedMedias)..where((f) => f.feedEntry.equals(feedEntryID)))
        .get();
  }
}
