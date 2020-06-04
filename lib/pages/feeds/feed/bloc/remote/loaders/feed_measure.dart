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

import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/pages/feed_entries/common/media_state.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_measure.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/remote_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedMeasureLoader extends RemoteFeedEntryLoader {
  FeedMeasureLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future<FeedEntryStateLoaded> load(FeedEntryState state) async {
    List<dynamic> feedMediasMap =
        await FeedsAPI().publicFeedMediasForFeedEntry(state.feedEntryID);
    MediaState currentMedia = stateForFeedMediaMap(feedMediasMap[0]);
    MediaState previousMedia;
    if ((state.params as FeedMeasureParams).previous is String) {
      String previous = (state.params as FeedMeasureParams).previous;
      if (previous != null) {
        Map<String, dynamic> previousMediaMap =
            await FeedsAPI().publicFeedMedia(previous);
        previousMedia = stateForFeedMediaMap(previousMediaMap);
      }
    }
    return FeedMeasureState(state, currentMedia, previousMedia, remoteState: true);
  }
}
