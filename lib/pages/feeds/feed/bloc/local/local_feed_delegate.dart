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

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_care.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_life_event.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_light.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_measure.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_media.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_nutrient_mix.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_products.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_schedule.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_timelapse.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_towelie_info.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_unknown.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_ventilation.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_water.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/local_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

abstract class LocalFeedBlocDelegate extends FeedBlocDelegate {
  late Function(FeedBlocEvent) add;
  final int feedID;
  final int? feedEntryID;
  Map<String, LocalFeedEntryLoader> loaders = {};
  late FeedUnknownLoader unknownLoader;
  StreamSubscription<FeedEntryInsertEvent>? insertSubscription;
  StreamSubscription<FeedEntryDeleteEvent>? deleteSubscription;

  final String? commentID;
  final String? replyTo;
  final List<String>? filters;

  LocalFeedBlocDelegate(this.feedID, {this.feedEntryID, this.commentID, this.replyTo, this.filters});

  Stream<FeedBlocState> onInitialLoad() async* {
    if (commentID != null) {
      FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(feedEntryID!);
      LocalFeedEntryLoader loader = loaderForType(feedEntry.type);
      FeedEntryStateLoaded feedEntryStateLoaded = await loader.load(loader.stateForFeedEntry(feedEntry));
      yield FeedBlocStateOpenComment(feedEntryStateLoaded, this.commentID!, this.replyTo);
    }
  }

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
      'FE_CLONING': FeedCareLoader(add),
      'FE_FIMMING': FeedCareLoader(add),
      'FE_BENDING': FeedCareLoader(add),
      'FE_TRANSPLANT': FeedCareLoader(add),
      'FE_VENTILATION': FeedVentilationLoader(add),
      'FE_WATER': FeedWaterLoader(add),
      'FE_TOWELIE_INFO': FeedTowelieInfoLoader(add),
      'FE_PRODUCTS': FeedProductsLoader(add),
      'FE_LIFE_EVENT': FeedLifeEventLoader(add),
      'FE_NUTRIENT_MIX': FeedNutrientMixLoader(add),
      'FE_TIMELAPSE': FeedTimelapseLoader(add),
    };
    insertSubscription = FeedEntryHelper.eventBus.on<FeedEntryInsertEvent>().listen((FeedEntryInsertEvent event) {
      FeedEntry feedEntry = event.feedEntry;
      if (feedEntry.feed != feedID) {
        return;
      }
      FeedEntryState newFirstEntry = loaderForType(feedEntry.type).stateForFeedEntry(feedEntry);
      add(FeedBlocEventAddedEntry(newFirstEntry));
    });
    deleteSubscription = FeedEntryHelper.eventBus.on<FeedEntryDeleteEvent>().listen((FeedEntryDeleteEvent event) {
      add(FeedBlocEventDeletedFeedEntry(event.feedEntry.id));
    });
  }

  @override
  LocalFeedEntryLoader loaderForType(String type) {
    FeedEntryLoader? loader = loaders[type];
    if (loader == null) {
      return unknownLoader;
    }
    return loader as LocalFeedEntryLoader;
  }

  @override
  Future<void> loadFeed() async {
    add(FeedBlocEventFeedLoaded(FeedState(AppDB().getAppData().jwt != null, AppDB().getAppData().storeGeo)));
  }

  @override
  Future<List<FeedEntryState>> loadEntries(int n, int offset, List<String>? filters) async {
    if (feedEntryID != null) {
      FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(feedEntryID!);
      LocalFeedEntryLoader loader = loaderForType(feedEntry.type);
      return [await loader.load(loader.stateForFeedEntry(feedEntry))];
    }
    List<FeedEntry> fe = await RelDB.get().feedsDAO.getFeedEntries(feedID, n, offset, filters);
    return fe.map<FeedEntryState>((fe) => loaderForType(fe.type).stateForFeedEntry(fe)).toList();
  }

  @override
  Future deleteFeedEntry(feedEntryID) async {
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(feedEntryID);
    await FeedEntryHelper.deleteFeedEntry(feedEntry);
  }

  @override
  Future forceSyncFeedEntry(feedEntryID) async {
    await FeedEntryHelper.updateFeedEntry(FeedEntriesCompanion(id: Value(feedEntryID), synced: Value(false)));
    List<FeedMedia> feedMedias = await RelDB.get().feedsDAO.getFeedMedias(feedEntryID);
    for (FeedMedia feedMedia in feedMedias) {
      await RelDB.get().feedsDAO.updateFeedMedia(FeedMediasCompanion(id: Value(feedMedia.id), synced: Value(false)));
    }
  }
  
  @override
  Future moveFeedEntry(feedEntryID, feedID) async {
    await FeedEntryHelper.updateFeedEntry(FeedEntriesCompanion(id: Value(feedEntryID), feed: Value(feedID), synced: Value(false)));
    List<FeedMedia> feedMedias = await RelDB.get().feedsDAO.getFeedMedias(feedEntryID);
    for (FeedMedia feedMedia in feedMedias) {
      await RelDB.get().feedsDAO.updateFeedMedia(FeedMediasCompanion(id: Value(feedMedia.id), synced: Value(false)));
    }
  }

  @override
  Future likeFeedEntry(FeedEntryState entry) async {
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(entry.feedEntryID);

    await BackendAPI().feedsAPI.likeFeedEntry(feedEntry.serverID!);
    FeedEntryLoader loader = this.loaderForType(entry.type);
    loader.loadSocialState(entry);
  }

  @override
  Future bookmarkFeedEntry(FeedEntryState entry) async {
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(entry.feedEntryID);

    await BackendAPI().feedsAPI.bookmarkFeedEntry(feedEntry.serverID!);
    FeedEntryLoader loader = this.loaderForType(entry.type);
    loader.loadSocialState(entry);
  }

  @override
  Stream<FeedBlocState> mapEventToState(FeedBlocEvent event) async* {}

  @override
  Future markAsRead(dynamic feedEntryID) async {
    await FeedEntryHelper.updateFeedEntry(FeedEntriesCompanion(id: Value(feedEntryID), isNew: Value(false)));
  }

  @override
  Future<void> close() async {
    List<Future> closePromises = [];
    for (FeedEntryLoader loader in loaders.values) {
      closePromises.add(loader.close());
    }
    Future.wait(closePromises);
    await insertSubscription?.cancel();
    await deleteSubscription?.cancel();
  }
}
