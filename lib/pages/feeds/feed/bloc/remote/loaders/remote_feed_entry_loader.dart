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
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class RemoteFeedEntryLoader extends FeedEntryLoader {
  final Map<String, FeedEntryState> cache = {};

  RemoteFeedEntryLoader(Function(FeedBlocEvent) add) : super(add);

  @mustCallSuper
  Future<FeedEntryStateLoaded> load(FeedEntryState state) async {
    cache[state.feedEntryID] = state;
    return state;
  }

  Future<List<Comment>> fetchComments(FeedEntryState state) async {
    List<Comment> comments = await BackendAPI()
        .feedsAPI
        .fetchCommentsForFeedEntry(state.feedEntryID, n: 2);
    return comments;
  }

  void onFeedEntryStateUpdated(FeedEntryState state) {
    add(FeedBlocEventUpdatedEntry(state));
    cache[state.feedEntryID] = state;
  }

  @override
  Future update(FeedEntryState entry, FeedEntryParams params) async {}

  @override
  @mustCallSuper
  void startListenEntryChanges(FeedEntryStateLoaded entry) {}

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
    if (cache[feedEntryMap['id']] != null &&
        mapEquals(cache[feedEntryMap['id']].data, feedEntryMap)) {
      return cache[feedEntryMap['id']];
    }
    return FeedEntryStateNotLoaded(
        feedEntryID: feedEntryMap['id'],
        feedID: feedEntryMap['feedID'],
        type: feedEntryMap['type'],
        isNew: false,
        synced: true,
        date: DateTime.parse(feedEntryMap['date']),
        params: FeedEntriesParamHelpers.paramForFeedEntryType(
            feedEntryMap['type'], feedEntryMap['params']),
        remoteState: true,
        data: feedEntryMap,
        socialState: FeedEntrySocialStateLoaded(
            isLiked: feedEntryMap['isLiked'],
            nComments: feedEntryMap['nComments'],
            nLikes: feedEntryMap['nLikes'],
            comments: []));
  }
}
