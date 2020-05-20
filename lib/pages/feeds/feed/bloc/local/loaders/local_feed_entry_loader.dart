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

import 'package:super_green_app/data/local/feed_entry_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entries_param_helpers.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class LocalFeedEntryLoader extends FeedEntryLoader {
  Map<dynamic, StreamSubscription<FeedEntryUpdateEvent>> subscriptions = {};

  LocalFeedEntryLoader(Function(FeedBlocEvent) add) : super(add);

  void startListenEntryChanges(FeedEntryStateLoaded entry) {
    if (subscriptions[entry.feedEntryID] != null) {
      subscriptions[entry.feedEntryID].cancel();
    }
    subscriptions[entry.feedEntryID] = FeedEntryHelper.eventBus
        .on<FeedEntryUpdateEvent>()
        .listen((FeedEntryUpdateEvent event) async {
      FeedEntry feedEntry = event.feedEntry;
      if (feedEntry.id != entry.feedEntryID) {
        return;
      }
      FeedEntryStateNotLoaded newState = FeedEntryStateNotLoaded(
          feedEntry.id,
          feedEntry.feed,
          feedEntry.type,
          feedEntry.isNew,
          feedEntry.synced,
          feedEntry.date,
          FeedEntriesParamHelpers.paramForFeedEntryType(
              feedEntry.type, feedEntry.params));
      add(FeedBlocEventUpdatedEntry(await load(newState)));
    });
  }

  void cancelListenEntryChanges(FeedEntryStateLoaded entry) {
    if (subscriptions[entry.feedEntryID] == null) {
      return;
    }
    subscriptions[entry.feedEntryID].cancel();
    subscriptions.remove(entry.feedEntryID);
  }

  @override
  Future<void> close() async {
    List<Future> promises = [];
    for (StreamSubscription<FeedEntryUpdateEvent> sub in subscriptions.values) {
      promises.add(sub.cancel());
    }
    Future.wait(promises);
  }
}
