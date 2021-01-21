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
import 'package:super_green_app/pages/feed_entries/common/media_state.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entries_param_helpers.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class RemoteFeedEntryLoader extends FeedEntryLoader {
  RemoteFeedEntryLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future update(FeedEntryState entry, FeedEntryParams params) async {}

  @mustCallSuper
  void startListenEntryChanges(FeedEntryStateLoaded entry) {}

  @mustCallSuper
  Future<void> cancelListenEntryChanges(FeedEntryStateLoaded entry) async {}

  @mustCallSuper
  @override
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
    return FeedEntryStateNotLoaded(
        feedEntryMap['id'],
        feedEntryMap['feedID'],
        feedEntryMap['type'],
        false,
        true,
        DateTime.parse(feedEntryMap['date']),
        FeedEntriesParamHelpers.paramForFeedEntryType(
            feedEntryMap['type'], feedEntryMap['params']),
        remoteState: true,
        data: feedEntryMap);
  }
}
