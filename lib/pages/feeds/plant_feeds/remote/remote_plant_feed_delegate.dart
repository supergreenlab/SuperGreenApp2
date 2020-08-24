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

import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/remote/remote_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_feed_state.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';

class RemotePlantFeedBlocDelegate extends RemoteFeedBlocDelegate {
  final String plantID;
  RemotePlantFeedBlocDelegate(this.plantID);

  @override
  Future<List<FeedEntryState>> loadEntries(int n, int offset) async {
    List<dynamic> entriesMap =
        await FeedsAPI().publicFeedEntries(plantID, n, offset);
    return entriesMap.map<FeedEntryState>((dynamic em) {
      Map<String, dynamic> entryMap = em;
      return loaderForType(entryMap['type']).stateForFeedEntryMap(entryMap);
    }).toList();
  }

  @override
  void loadFeed() async {
    Map<String, dynamic> plant = await FeedsAPI().publicPlant(plantID);
    add(FeedBlocEventFeedLoaded(PlantFeedState(
      AppDB().getAppData().storeGeo,
      PlantSettings.fromJSON(plant['settings']),
      BoxSettings.fromJSON(plant['boxSettings']),
    )));
  }
}
