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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/remote_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:tuple/tuple.dart';

class SimilarEntriesFeedBlocDelegate extends RemoteFeedBlocDelegate {
  final FeedEntryState feedEntryState;
  late FeedState feedState;
  StreamSubscription<hive.BoxEvent>? appDataStream;

  SimilarEntriesFeedBlocDelegate(this.feedEntryState) : super();

  @override
  FeedEntryState postProcess(FeedEntryState state) {
    return state.copyWith(
        shareLink: 'https://supergreenlab.com/public/plant?id=${state.plantID}&feid=${state.feedEntryID}');
  }

  @override
  Stream<FeedBlocState> mapEventToState(FeedBlocEvent event) async* {
    yield* super.mapEventToState(event);
  }

  @override
  Future<List<FeedEntryState>> loadEntries(int n, int offset, List<String>? filters) async {
    Tuple3<PlantPhases, DateTime, Duration> phaseDate = feedEntryState.plantSettings!.phaseAt(feedEntryState.date)!;

    String feedID = '00000000-0000-0000-0000-000000000000';
    if (feedEntryState.feedID is int) {
      Feed feed = await RelDB.get().feedsDAO.getFeed(feedEntryState.feedID);
      if (feed.serverID != null) {
        feedID = feed.serverID!;
      }
    } else if (feedEntryState.feedID is String) {
      feedID = feedEntryState.feedID;
    }
    if (feedEntryState.plantSettings!.plantType == 'AUTO') {
      DateTime date2 = feedEntryState.plantSettings!.germinationDate!;
      Duration diff = feedEntryState.date.difference(date2);
      phaseDate = Tuple3<PlantPhases, DateTime, Duration>(PlantPhases.GERMINATING, date2, diff);
    }
    List<dynamic> entriesMap = await BackendAPI().feedsAPI.similarFeedEntries(feedID, feedEntryState.plantSettings!.plantType, phaseDate.item1, phaseDate.item3.inDays+1, n, offset);

    entriesMap.removeWhere((e) => BackendAPI().blockedUserIDs.contains(e['userID']));

    return entriesMap.map<FeedEntryState>((dynamic em) {
      Map<String, dynamic> entryMap = em;
      return loaderForType(entryMap['type']).stateForFeedEntryMap(entryMap).copyWith(showPlantInfos: true);
    }).toList();
  }

  @override
  Future<void> loadFeed() async {
    feedState = FeedState(
      BackendAPI().usersAPI.loggedIn,
      AppDB().getAppData().storeGeo,
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
