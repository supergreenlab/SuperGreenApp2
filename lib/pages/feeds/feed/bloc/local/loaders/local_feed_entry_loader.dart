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

import 'package:flutter/foundation.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entries_param_helpers.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class LocalFeedEntryLoader extends FeedEntryLoader {
  final Map<int, FeedEntryState> cache = {};

  Map<dynamic, StreamSubscription<FeedEntryUpdateEvent>> subscriptions = {};

  LocalFeedEntryLoader(Function(FeedBlocEvent) add) : super(add);

  @mustCallSuper
  Future<FeedEntryStateLoaded> load(FeedEntryState state) async {
    cache[state.feedEntryID] = state;
    return state;
  }

  Future<void> loadSocialState(FeedEntryState state) async {
    FeedEntry feedEntry = state.data as FeedEntry;
    if (feedEntry.serverID != null) {
      Map<String, dynamic> socialMap = await BackendAPI()
          .feedsAPI
          .fetchSocialForFeedEntry(feedEntry.serverID);
      FeedEntrySocialStateLoaded socialState =
          FeedEntrySocialStateLoaded.fromMap(socialMap);
      onFeedEntryStateUpdated(state.copyWithSocialState(socialState));

      List<Comment> comments = await BackendAPI()
          .feedsAPI
          .fetchCommentsForFeedEntry(feedEntry.serverID,
              offset: 0, n: 2, rootCommentsOnly: true);
      onFeedEntryStateUpdated(
          state.copyWithSocialState(socialState.copyWith(comments: comments)));
    }
  }

  @override
  Future update(FeedEntryState entry, FeedEntryParams params) async {}

  @mustCallSuper
  void startListenEntryChanges(FeedEntryStateLoaded entry) {
    if (subscriptions[entry.feedEntryID] != null) {
      subscriptions[entry.feedEntryID].cancel();
    }
    subscriptions[entry.feedEntryID] = FeedEntryHelper.eventBus
        .on<FeedEntryUpdateEvent>()
        .listen((FeedEntryUpdateEvent event) async {
      FeedEntry feedEntry = event.feedEntry;
      if (feedEntry == null) {
        return;
      }
      if (feedEntry.id != entry.feedEntryID) {
        return;
      }
      await updateFeedEntryState(feedEntry);
    });
  }

  Future<void> updateFeedEntryState(FeedEntry feedEntry) async {
    FeedEntryState newState = stateForFeedEntry(feedEntry);
    if (newState is FeedEntryStateNotLoaded) {
      newState = await load(newState);
    }
    onFeedEntryStateUpdated(newState);
  }

  void onFeedEntryStateUpdated(FeedEntryState state) {
    add(FeedBlocEventUpdatedEntry(state));
    cache[state.feedEntryID] = state;
  }

  @mustCallSuper
  Future<void> cancelListenEntryChanges(FeedEntryStateLoaded entry) async {
    if (subscriptions[entry.feedEntryID] == null) {
      return;
    }
    await subscriptions[entry.feedEntryID].cancel();
    subscriptions.remove(entry.feedEntryID);
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    List<Future> promises = [];
    for (StreamSubscription<FeedEntryUpdateEvent> sub in subscriptions.values) {
      promises.add(sub.cancel());
    }
    Future.wait(promises);
  }

  FeedEntryState stateForFeedEntry(FeedEntry feedEntry) {
    if (cache[feedEntry.id] != null && cache[feedEntry.id].data == feedEntry) {
      return cache[feedEntry.id];
    }
    return FeedEntryStateNotLoaded(
        feedEntryID: feedEntry.id,
        feedID: feedEntry.feed,
        type: feedEntry.type,
        isNew: feedEntry.isNew,
        synced: feedEntry.synced,
        date: feedEntry.date,
        params: FeedEntriesParamHelpers.paramForFeedEntryType(
            feedEntry.type, feedEntry.params),
        data: feedEntry,
        socialState: FeedEntrySocialStateNotLoaded());
  }
}
