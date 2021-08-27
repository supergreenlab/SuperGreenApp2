// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$FeedsDAOMixin on DatabaseAccessor<RelDB> {
  $FeedsTable get feeds => attachedDatabase.feeds;
  $FeedEntriesTable get feedEntries => attachedDatabase.feedEntries;
  $FeedEntryDraftsTable get feedEntryDrafts => attachedDatabase.feedEntryDrafts;
  $FeedMediasTable get feedMedias => attachedDatabase.feedMedias;
  Selectable<GetPendingFeedsResult> getPendingFeeds() {
    return customSelect(
        'select\n      feeds.id,\n      (select\n        count(*)\n        from feed_entries\n        where is_new = true and feed_entries.feed = feeds.id\n      ) as nNew\n    from feeds where nNew > 0',
        variables: [],
        readsFrom: {
          feeds,
          feedEntries,
        }).map((QueryRow row) {
      return GetPendingFeedsResult(
        id: row.read<int>('id'),
        nNew: row.read<int>('nNew'),
      );
    });
  }

  Selectable<int> getNFeedEntriesWithType(String var1) {
    return customSelect('select count(*) from feed_entries where type = ?',
        variables: [
          Variable<String>(var1)
        ],
        readsFrom: {
          feedEntries,
        }).map((QueryRow row) => row.read<int>('count(*)'));
  }
}

class GetPendingFeedsResult {
  final int id;
  final int nNew;
  GetPendingFeedsResult({
    @required this.id,
    @required this.nNew,
  });
}
