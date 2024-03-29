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

import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_care.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_life_event.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_light.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_measure.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_media.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_nutrient_mix.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_schedule.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_timelapse.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_unknown.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_ventilation.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/feed_water.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/loaders/remote_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class RemoteFeedBlocDelegate extends FeedBlocDelegate {
  late Function(FeedBlocEvent) add;
  Map<String, RemoteFeedEntryLoader> loaders = {};
  late FeedUnknownLoader unknownLoader;

  // TODO this shouldn't be there
  final String? feedEntryID;
  final String? commentID;
  final String? replyTo;

  RemoteFeedBlocDelegate({this.feedEntryID, this.commentID, this.replyTo});

  Stream<FeedBlocState> onInitialLoad() async* {
    // TODO this shouldn't be there
    if (commentID != null) {
      Map<String, dynamic> entryMap = await BackendAPI().feedsAPI.publicFeedEntry(feedEntryID!);
      RemoteFeedEntryLoader feedEntryLoader = loaderForType(entryMap['type']);
      FeedEntryStateLoaded feedEntry = await feedEntryLoader.load(feedEntryLoader.stateForFeedEntryMap(entryMap));
      yield FeedBlocStateOpenComment(feedEntry, this.commentID!, this.replyTo);
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
      'FE_LIFE_EVENT': FeedLifeEventLoader(add),
      'FE_NUTRIENT_MIX': FeedNutrientMixLoader(add),
      'FE_TIMELAPSE': FeedTimelapseLoader(add),
    };
  }

  @override
  RemoteFeedEntryLoader loaderForType(String type) {
    FeedEntryLoader? loader = loaders[type];
    if (loader == null) {
      return unknownLoader;
    }
    return loader as RemoteFeedEntryLoader;
  }

  @override
  Future deleteFeedEntry(feedEntryID) async {}
    @override
  Future forceSyncFeedEntry(feedEntryID) async {}
    @override
  Future moveFeedEntry(feedEntryID, feedID) async {}

  @override
  Future likeFeedEntry(FeedEntryState entry) async {
    await BackendAPI().feedsAPI.likeFeedEntry(entry.feedEntryID);
    FeedEntryLoader loader = this.loaderForType(entry.type);
    loader.loadSocialState(entry);
  }

  @override
  Future bookmarkFeedEntry(FeedEntryState entry) async {
    await BackendAPI().feedsAPI.bookmarkFeedEntry(entry.feedEntryID);
    FeedEntryLoader loader = this.loaderForType(entry.type);
    loader.loadSocialState(entry);
  }

  @override
  Stream<FeedBlocState> mapEventToState(FeedBlocEvent event) async* {}

  @override
  Future markAsRead(dynamic feedEntryID) async {}

  @override
  Future<void> close() async {}
}
