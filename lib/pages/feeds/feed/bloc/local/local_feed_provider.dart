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

import 'package:moor/moor.dart';
import 'package:super_green_app/data/helpers/feed_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_care.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_life_event.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_light.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_measure.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_media.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_products.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_schedule.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_towelie_info.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_unknown.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_ventilation.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_water.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/local_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

class LocalFeedBlocProvider extends FeedBlocProvider {
  Function(FeedBlocEvent) add;
  final int feedID;
  Map<String, LocalFeedEntryLoader> loaders = {};
  FeedUnknownLoader unknownLoader;
  StreamSubscription<FeedEntryInsertEvent> insertSubscription;
  StreamSubscription<FeedEntryDeleteEvent> deleteSubscription;

  LocalFeedBlocProvider(this.feedID);

  @override
  Future init(Function(FeedBlocEvent) add) async {
    this.add = add;
    unknownLoader = FeedUnknownLoader(add);
    loaders = {
      'FE_LIGHT': FeedLightLoader(add),
      'FE_MEDIA': FeedMediaLoader(add),
      'FE_MEASURE': FeedMeasureLoader(add),
      'FE_SCHEDULE': FeedScheduleLoader(add),
      'FE_TOPPING': FeedCareLoader(add),
      'FE_DEFOLIATION': FeedCareLoader(add),
      'FE_FIMMING': FeedCareLoader(add),
      'FE_BENDING': FeedCareLoader(add),
      'FE_TRANSPLANT': FeedCareLoader(add),
      'FE_VENTILATION': FeedVentilationLoader(add),
      'FE_WATER': FeedWaterLoader(add),
      'FE_TOWELIE_INFO': FeedTowelieInfoLoader(add),
      'FE_PRODUCTS': FeedProductsLoader(add),
      'FE_LIFE_EVENT': FeedLifeEventLoader(add),
    };
    insertSubscription = FeedEntryHelper.eventBus
        .on<FeedEntryInsertEvent>()
        .listen((FeedEntryInsertEvent event) {
      FeedEntry feedEntry = event.feedEntry;
      if (feedEntry.feed != feedID) {
        return;
      }
      FeedEntryState newFirstEntry =
          loaderForType(feedEntry.type).stateForFeedEntry(feedEntry);
      add(FeedBlocEventAddedEntry(newFirstEntry));
    });
    deleteSubscription = FeedEntryHelper.eventBus
        .on<FeedEntryDeleteEvent>()
        .listen((FeedEntryDeleteEvent event) {
      add(FeedBlocEventDeletedFeedEntry(event.feedEntry.id));
    });
  }

  @override
  LocalFeedEntryLoader loaderForType(String type) {
    FeedEntryLoader loader = loaders[type];
    if (loader == null) {
      return unknownLoader;
    }
    return loader;
  }

  @override
  void loadFeed() {
    add(FeedBlocEventFeedLoaded(FeedState(AppDB().getAppData().storeGeo)));
  }

  @override
  Future<List<FeedEntryState>> loadEntries(int n, int offset) async {
    List<FeedEntry> fe =
        await RelDB.get().feedsDAO.getFeedEntries(feedID, n, offset);
    return fe
        .map<FeedEntryState>(
            (fe) => loaderForType(fe.type).stateForFeedEntry(fe))
        .toList();
  }

  @override
  Future deleteFeedEntry(feedEntryID) async {
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(feedEntryID);
    await FeedEntryHelper.deleteFeedEntry(feedEntry);
  }

  @override
  Future markAsRead(dynamic feedEntryID) async {
    await FeedEntryHelper.updateFeedEntry(
        FeedEntriesCompanion(id: Value(feedEntryID), isNew: Value(false)));
  }

  @override
  Future<void> close() async {
    List<Future> closePromises = [];
    for (FeedEntryLoader loader in loaders.values) {
      closePromises.add(loader.close());
    }
    Future.wait(closePromises);
    await insertSubscription.cancel();
    await deleteSubscription.cancel();
  }
}
