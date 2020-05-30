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

import 'dart:async';
import 'dart:convert';

import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/common/media_state.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_measure.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/local_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedMeasureLoader extends LocalFeedEntryLoader {
  Map<dynamic, StreamSubscription<FeedMedia>> _previousStreams = {};
  Map<dynamic, StreamSubscription<List<FeedMedia>>> _currentStreams = {};

  FeedMeasureLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future<FeedEntryStateLoaded> load(FeedEntryState state) async {
    FeedMeasureParams params = state.params;
    MediaState previous;
    RelDB db = RelDB.get();
    if (params.previous != null) {
      FeedMedia previousMedia;
      if (params.previous is int) {
        previousMedia = await db.feedsDAO.getFeedMedia(params.previous);
      } else if (params.previous is String) {
        previousMedia =
            await db.feedsDAO.getFeedMediaForServerID(params.previous);
      }
      previous = MediaState(
          previousMedia.id,
          FeedMedias.makeAbsoluteFilePath(previousMedia.filePath),
          FeedMedias.makeAbsoluteFilePath(previousMedia.thumbnailPath),
          JsonDecoder().convert(previousMedia.params),
          previousMedia.synced);
    }

    List<FeedMedia> currentMedia =
        await db.feedsDAO.getFeedMedias(state.feedEntryID);
    MediaState current = MediaState(
        currentMedia[0].id,
        FeedMedias.makeAbsoluteFilePath(currentMedia[0].filePath),
        FeedMedias.makeAbsoluteFilePath(currentMedia[0].thumbnailPath),
        JsonDecoder().convert(currentMedia[0].params),
        currentMedia[0].synced);
    return FeedMeasureState(state, current, previous);
  }

  void startListenEntryChanges(FeedEntryStateLoaded entry) {
    super.startListenEntryChanges(entry);
    FeedMeasureParams params = entry.params;
    RelDB db = RelDB.get();
    if (params.previous is int) {
      _previousStreams[entry.feedEntryID] =
          db.feedsDAO.watchFeedMedia(params.previous).listen((_) async {
        FeedEntry feedEntry =
            await RelDB.get().feedsDAO.getFeedEntry(entry.feedEntryID);
        await updateFeedEntryState(feedEntry);
      });
    } else if (params.previous is String) {
      _previousStreams[entry.feedEntryID] = db.feedsDAO
          .watchFeedMediaForServerID(params.previous)
          .listen((_) async {
        FeedEntry feedEntry =
            await RelDB.get().feedsDAO.getFeedEntry(entry.feedEntryID);
        await updateFeedEntryState(feedEntry);
      });
    }
    _currentStreams[entry.feedEntryID] =
        db.feedsDAO.watchFeedMedias(entry.feedEntryID).listen((_) async {
      FeedEntry feedEntry =
          await RelDB.get().feedsDAO.getFeedEntry(entry.feedEntryID);
      await updateFeedEntryState(feedEntry);
    });
  }

  Future<void> cancelListenEntryChanges(FeedEntryStateLoaded entry) async {
    super.cancelListenEntryChanges(entry);
    if (_previousStreams[entry.feedEntryID] != null) {
      await _previousStreams[entry.feedEntryID].cancel();
      _previousStreams.remove(entry.feedEntryID);
    }
    if (_currentStreams[entry.feedEntryID] != null) {
      await _currentStreams[entry.feedEntryID].cancel();
      _currentStreams.remove(entry.feedEntryID);
    }
  }

  Future<void> close() async {
    super.close();
    List<Future> promises = [];
    for (StreamSubscription<FeedMedia> sub in _previousStreams.values) {
      promises.add(sub.cancel());
    }
    for (StreamSubscription<List<FeedMedia>> sub in _currentStreams.values) {
      promises.add(sub.cancel());
    }
    Future.wait(promises);
  }
}
