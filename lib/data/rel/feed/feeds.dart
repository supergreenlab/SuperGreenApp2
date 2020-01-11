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

  TextColumn get params => text()();
}

@UseDao(tables: [Feeds, FeedEntries])
class FeedsDAO extends DatabaseAccessor<RelDB> with _$FeedsDAOMixin {

  FeedsDAO(RelDB db) : super(db);

  Future<int> addFeed(FeedsCompanion feed) {
    return into(feeds).insert(feed);
  }

  Future<Feed> getFeed(int feedID) {
    return (select(feeds)..where((f) => f.id.equals(feedID))).getSingle();
  }
  
  Stream<List<FeedEntry>> watchEntries(int feedID) {
    return (select(feedEntries)..where((fe) => fe.feed.equals(feedID))).watch();
  }

  Future<int> addFeedEntry(FeedEntriesCompanion feedEntry) {
    return into(feedEntries).insert(feedEntry);
  }
}