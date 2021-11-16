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

import 'package:hive/hive.dart' as hive;
import 'package:moor/moor.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_life_event.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/local_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class LocalPlantFeedBlocDelegate extends LocalFeedBlocDelegate {
  late Plant plant;
  late Box box;

  late PlantFeedState feedState;
  StreamSubscription<Box>? boxStream;
  StreamSubscription<Plant>? plantStream;
  StreamSubscription<hive.BoxEvent>? appDataStream;

  LocalPlantFeedBlocDelegate(int feedID, {int? feedEntryID, String? commentID, String? replyTo})
      : super(feedID, feedEntryID: feedEntryID, commentID: commentID, replyTo: replyTo);

  @override
  FeedEntryState postProcess(FeedEntryState state) {
    FeedEntry feedEntry = state.data as FeedEntry;
    if (plant.serverID == null || feedEntry.serverID == null) {
      return state;
    }
    return state.copyWith(
        shareLink: 'https://supergreenlab.com/public/plant?id=${plant.serverID}&feid=${feedEntry.serverID}');
  }

  @override
  Future<List<FeedEntryState>> loadEntries(int n, int offset) {
    return super.loadEntries(n, offset);
  }

  @override
  void loadFeed() async {
    plant = await RelDB.get().plantsDAO.getPlantWithFeed(feedID);
    box = await RelDB.get().plantsDAO.getBox(plant.box!);
    AppData appData = AppDB().getAppData();
    feedState = PlantFeedState(appData.jwt != null, appData.storeGeo, PlantSettings.fromJSON(plant.settings),
        BoxSettings.fromJSON(box.settings));
    add(FeedBlocEventFeedLoaded(feedState));

    plantStream = RelDB.get().plantsDAO.watchPlant(plant.id).listen(plantUpdated);
    boxStream = RelDB.get().plantsDAO.watchBox(plant.box!).listen(boxUpdated);
    appDataStream = AppDB().watchAppData().listen(appDataUpdated);
  }

  @override
  Future deleteFeedEntry(feedEntryID) async {
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(feedEntryID);
    // TODO find something to do for feedEntry destructors.
    if (feedEntry.type == 'FE_LIFE_EVENT') {
      FeedLifeEventParams params = FeedLifeEventParams.fromJSON(feedEntry.params);
      PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
      plantSettings = plantSettings.removeDateForPhase(params.phase);
      PlantsCompanion plantsCompanion = PlantsCompanion(
        id: Value(plant.id),
        settings: Value(plantSettings.toJSON()),
        synced: Value(false),
      );
      await RelDB.get().plantsDAO.updatePlant(plantsCompanion);
    }
    await super.deleteFeedEntry(feedEntryID);
  }

  void plantUpdated(Plant plant) {
    this.plant = plant;
    feedState = feedState.copyWith(
      plantSettings: PlantSettings.fromJSON(plant.settings),
    );
    add(FeedBlocEventFeedLoaded(feedState));
  }

  void boxUpdated(Box box) {
    this.box = box;
    feedState = feedState.copyWith(
      boxSettings: BoxSettings.fromJSON(box.settings),
    );
    add(FeedBlocEventFeedLoaded(feedState));
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
    await boxStream?.cancel();
    await plantStream?.cancel();
    await appDataStream?.cancel();
    await super.close();
  }
}
