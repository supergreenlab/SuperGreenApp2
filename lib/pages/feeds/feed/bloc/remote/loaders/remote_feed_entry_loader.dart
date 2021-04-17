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

import 'package:flutter/foundation.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/pages/feed_entries/common/media_state.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entries_param_helpers.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

abstract class RemoteFeedEntryLoader extends FeedEntryLoader {
  RemoteFeedEntryLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future<void> loadSocialState(FeedEntryState state) async {
    FeedEntryState cached = cache[state.feedEntryID];
    Map<String, dynamic> socialMap = await BackendAPI().feedsAPI.fetchSocialForFeedEntry(state.feedEntryID);
    FeedEntrySocialStateLoaded socialState = FeedEntrySocialStateLoaded.fromMap(socialMap);
    if (cached != null && cached.socialState is FeedEntrySocialStateLoaded) {
      socialState = socialState.copyWith(comments: (cached.socialState as FeedEntrySocialStateLoaded).comments);
    }
    onFeedEntryStateUpdated(state = state.copyWith(socialState: socialState));
    loadComments(socialState, state);
  }

  Future<void> loadComments(FeedEntrySocialStateLoaded socialState, FeedEntryState state) async {
    List<Comment> comments = [];

    if (socialState.nComments > 0) {
      comments = await BackendAPI()
          .feedsAPI
          .fetchCommentsForFeedEntry(state.feedEntryID, offset: 0, limit: 2, rootCommentsOnly: true);
    }
    onFeedEntryStateUpdated(state.copyWith(socialState: socialState.copyWith(comments: comments)));
  }

  @override
  @mustCallSuper
  void startListenEntryChanges(FeedEntryStateLoaded entry) async {
    await loadSocialState(entry);
  }

  @override
  @mustCallSuper
  Future<void> cancelListenEntryChanges(FeedEntryStateLoaded entry) async {}

  @override
  @mustCallSuper
  Future<void> close() async {}

  MediaState stateForFeedMediaMap(Map<String, dynamic> feedMediaMap) {
    return MediaState(
        feedMediaMap['id'],
        BackendAPI().feedsAPI.absoluteFileURL(feedMediaMap['filePath']),
        BackendAPI().feedsAPI.absoluteFileURL(feedMediaMap['thumbnailPath']),
        JsonDecoder().convert(feedMediaMap['params']),
        true);
  }

  FeedEntryState stateForFeedEntryMap(Map<String, dynamic> feedEntryMap) {
    FeedEntrySocialState socialState;
    if (cache[feedEntryMap['id']] != null) {
      if (mapEquals(cache[feedEntryMap['id']].data, feedEntryMap)) {
        return cache[feedEntryMap['id']];
      }
      socialState = cache[feedEntryMap['id']].socialState;
    } else {
      socialState = FeedEntrySocialStateLoaded.fromMap(feedEntryMap).copyWith(comments: []);
    }
    return FeedEntryStateNotLoaded(
        feedEntryID: feedEntryMap['id'],
        feedID: feedEntryMap['feedID'],
        type: feedEntryMap['type'],
        isNew: false,
        synced: true,
        date: DateTime.parse(feedEntryMap['date']),
        params: FeedEntriesParamHelpers.paramForFeedEntryType(feedEntryMap['type'], feedEntryMap['params']),
        plantID: feedEntryMap['plantID'],
        plantName: feedEntryMap['plantName'],
        plantSettings:
            feedEntryMap['plantSettings'] == null ? null : PlantSettings.fromJSON(feedEntryMap['plantSettings']),
        boxSettings: feedEntryMap['boxSettings'] == null ? null : BoxSettings.fromJSON(feedEntryMap['boxSettings']),
        followed: feedEntryMap['followed'],
        showPlantInfos: false,
        isRemoteState: true,
        isBackedUp: true,
        data: feedEntryMap,
        socialState: socialState);
  }
}
