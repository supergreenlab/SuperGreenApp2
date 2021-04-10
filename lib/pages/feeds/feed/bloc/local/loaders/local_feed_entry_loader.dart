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
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class LocalFeedEntryLoader extends FeedEntryLoader {
  Map<dynamic, StreamSubscription<FeedEntryUpdateEvent>> subscriptions = {};

  LocalFeedEntryLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future<void> loadSocialState(FeedEntryState state) async {
    FeedEntry feedEntry = state.data as FeedEntry;
    FeedEntryState cached = cache[feedEntry.id];
    if (feedEntry.serverID != null) {
      Map<String, dynamic> socialMap = await BackendAPI().feedsAPI.fetchSocialForFeedEntry(feedEntry.serverID);
      FeedEntrySocialStateLoaded socialState = FeedEntrySocialStateLoaded.fromMap(socialMap);
      if (cached != null && cached.socialState is FeedEntrySocialStateLoaded) {
        socialState = socialState.copyWith(comments: (cached.socialState as FeedEntrySocialStateLoaded).comments);
      }
      onFeedEntryStateUpdated(state.copyWith(socialState: socialState));

      List<Comment> comments = [];

      if (socialState.nComments > 0) {
        comments = await BackendAPI()
            .feedsAPI
            .fetchCommentsForFeedEntry(feedEntry.serverID, offset: 0, limit: 2, rootCommentsOnly: true);
      }
      onFeedEntryStateUpdated(state.copyWith(socialState: socialState.copyWith(comments: comments)));
    }
  }

  @mustCallSuper
  void startListenEntryChanges(FeedEntryStateLoaded entry) {
    if (subscriptions[entry.feedEntryID] != null) {
      subscriptions[entry.feedEntryID].cancel();
    }
    subscriptions[entry.feedEntryID] =
        FeedEntryHelper.eventBus.on<FeedEntryUpdateEvent>().listen((FeedEntryUpdateEvent event) async {
      FeedEntry feedEntry = event.feedEntry;
      if (feedEntry == null) {
        return;
      }
      if (feedEntry.id != entry.feedEntryID) {
        return;
      }
      await updateFeedEntryState(feedEntry, forceNew: true);
    });
  }

  Future<void> updateFeedEntryState(FeedEntry feedEntry, {bool forceNew = false}) async {
    FeedEntryState newState = stateForFeedEntry(feedEntry, forceNew: forceNew);
    if (newState is FeedEntryStateNotLoaded) {
      newState = await load(newState);
    } else {
      loadSocialState(newState);
    }
    onFeedEntryStateUpdated(newState);
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

  FeedEntryState stateForFeedEntry(FeedEntry feedEntry, {bool forceNew = false}) {
    FeedEntrySocialState socialState = FeedEntrySocialStateNotLoaded();
    if (cache[feedEntry.id] != null) {
      if (!forceNew && cache[feedEntry.id].data == feedEntry) {
        return cache[feedEntry.id];
      }
      socialState = cache[feedEntry.id].socialState;
    }
    return FeedEntryStateNotLoaded(
        feedEntryID: feedEntry.id,
        feedID: feedEntry.feed,
        type: feedEntry.type,
        isNew: feedEntry.isNew,
        synced: feedEntry.synced,
        date: feedEntry.date,
        params: FeedEntriesParamHelpers.paramForFeedEntryType(feedEntry.type, feedEntry.params),
        data: feedEntry,
        socialState: socialState,
        showPlantInfos: false,
        isRemoteState: false,
        isBackedUp: feedEntry.serverID != null,
        shareLink: feedEntry.serverID != null ? '' : null);
  }
}
