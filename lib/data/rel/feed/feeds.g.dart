// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds.dart';

// ignore_for_file: type=lint
mixin _$FeedsDAOMixin on DatabaseAccessor<RelDB> {
  $FeedsTable get feeds => attachedDatabase.feeds;
  $FeedEntriesTable get feedEntries => attachedDatabase.feedEntries;
  $FeedEntryDraftsTable get feedEntryDrafts => attachedDatabase.feedEntryDrafts;
  $FeedMediasTable get feedMedias => attachedDatabase.feedMedias;
  Selectable<GetPendingFeedsResult> getPendingFeeds() {
    return customSelect(
        'SELECT feeds.id, (SELECT count(*) FROM feed_entries WHERE is_new = TRUE AND feed_entries.feed = feeds.id) AS nNew FROM feeds WHERE nNew > 0',
        variables: [],
        readsFrom: {
          feeds,
          feedEntries,
        }).map((QueryRow row) => GetPendingFeedsResult(
          id: row.read<int>('id'),
          nNew: row.read<int>('nNew'),
        ));
  }

  Selectable<int> getNFeedEntriesWithType(String var1) {
    return customSelect(
        'SELECT count(*) AS _c0 FROM feed_entries WHERE type = ?1',
        variables: [
          Variable<String>(var1)
        ],
        readsFrom: {
          feedEntries,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }
}

class GetPendingFeedsResult {
  final int id;
  final int nNew;
  GetPendingFeedsResult({
    required this.id,
    required this.nNew,
  });
}
