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

import 'package:hive/hive.dart' as hive;
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/remote_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class RemotePlantFeedBlocDelegate extends RemoteFeedBlocDelegate {
  late FeedState feedState;
  StreamSubscription<hive.BoxEvent>? appDataStream;

  final String plantID;
  RemotePlantFeedBlocDelegate(this.plantID, String? feedEntryID, String? commentID, String? replyTo)
      : super(feedEntryID: feedEntryID, commentID: commentID, replyTo: replyTo);

  @override
  FeedEntryState postProcess(FeedEntryState state) {
    return state.copyWith(shareLink: 'https://supergreenlab.com/public/plant?id=$plantID&feid=${state.feedEntryID}', plantSettings: (feedState as PlantFeedState).plantSettings, boxSettings: (feedState as PlantFeedState).boxSettings);
  }

  @override
  Future<List<FeedEntryState>> loadEntries(int n, int offset, List<String>? filters) async {
    if (feedEntryID != null) {
      Map<String, dynamic> entryMap = await BackendAPI().feedsAPI.publicFeedEntry(feedEntryID!);
      return [loaderForType(entryMap['type']).stateForFeedEntryMap(entryMap)];
    }
    List<dynamic> entriesMap = await BackendAPI().feedsAPI.publicPlantFeedEntries(plantID, n, offset, filters: filters);
    return entriesMap.map<FeedEntryState>((dynamic em) {
      Map<String, dynamic> entryMap = em;
      return loaderForType(entryMap['type']).stateForFeedEntryMap(entryMap);
    }).toList();
  }

  @override
  Future<void> loadFeed() async {
    Map<String, dynamic> plant = await BackendAPI().feedsAPI.publicPlant(plantID);
    feedState = PlantFeedState(
      BackendAPI().usersAPI.loggedIn,
      AppDB().getAppData().storeGeo,
      plantID,
      plant['boxID'],
      PlantSettings.fromJSON(plant['settings']),
      BoxSettings.fromJSON(plant['boxSettings']),
    );
    add(FeedBlocEventFeedLoaded(feedState));

    appDataStream = AppDB().watchAppData().listen(appDataUpdated);
  }

  void appDataUpdated(hive.BoxEvent boxEvent) {
    feedState = feedState.copyWith(
      loggedIn: (boxEvent.value as AppData).jwt != null,
      storeGeo: (boxEvent.value as AppData).storeGeo,
    );
    add(FeedBlocEventFeedLoaded(feedState));
  }

  @override
  Future<void> close() async {
    await appDataStream?.cancel();
    await super.close();
  }
}
