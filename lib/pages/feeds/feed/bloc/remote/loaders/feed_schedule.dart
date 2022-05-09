/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/remote_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedScheduleLoader extends RemoteFeedEntryLoader {
  FeedScheduleLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future<FeedEntryStateLoaded> load(FeedEntryState state) async {
    state =
        FeedScheduleState(state, isRemoteState: true, socialState: (state.socialState as FeedEntrySocialStateLoaded));
    loadComments(state.socialState as FeedEntrySocialStateLoaded, state);
    return super.load(state);
  }

  FeedEntryState stateForFeedEntryMap(Map<String, dynamic> feedEntry) =>
      FeedScheduleState(super.stateForFeedEntryMap(feedEntry), isRemoteState: true);
}
