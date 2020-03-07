// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$FeedsDAOMixin on DatabaseAccessor<RelDB> {
  $FeedsTable get feeds => db.feeds;
  $FeedEntriesTable get feedEntries => db.feedEntries;
  $FeedMediasTable get feedMedias => db.feedMedias;
  GetPendingFeedsResult _rowToGetPendingFeedsResult(QueryRow row) {
    return GetPendingFeedsResult(
      id: row.readInt('id'),
      nNew: row.readInt('nNew'),
    );
  }

  Selectable<GetPendingFeedsResult> getPendingFeeds() {
    return customSelectQuery(
        'select\n      feeds.id,\n      (select\n        count(*)\n        from feed_entries\n        where is_new = true and feed_entries.feed = feeds.id\n      ) as nNew\n    from feeds where nNew > 0',
        variables: [],
        readsFrom: {feeds, feedEntries}).map(_rowToGetPendingFeedsResult);
  }
}

class GetPendingFeedsResult {
  final int id;
  final int nNew;
  GetPendingFeedsResult({
    this.id,
    this.nNew,
  });
}
