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
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/local_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/home/box_feeds/common/box_feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';

class LocalBoxFeedBlocDelegate extends LocalFeedBlocDelegate {
  late Box box;
  late BoxFeedState feedState;
  StreamSubscription<Box>? boxStream;
  StreamSubscription<hive.BoxEvent>? appDataStream;

  LocalBoxFeedBlocDelegate(int feedID) : super(feedID);

  @override
  FeedEntryState postProcess(FeedEntryState state) {
    FeedEntry feedEntry = state.data as FeedEntry;
    if (box.serverID == null || feedEntry.serverID == null) {
      return state;
    }
    return state.copyWith(
        shareLink: 'https://supergreenlab.com/public/box?id=${box.serverID}&feid=${feedEntry.serverID}');
  }

  @override
  void loadFeed() async {
    box = await RelDB.get().plantsDAO.getBoxWithFeed(feedID);
    AppData appData = AppDB().getAppData();
    feedState = BoxFeedState(appData.jwt != null, appData.storeGeo, BoxSettings.fromJSON(box.settings));
    add(FeedBlocEventFeedLoaded(feedState));

    boxStream = RelDB.get().plantsDAO.watchBox(box.id).listen(boxUpdated);
    appDataStream = AppDB().watchAppData().listen(appDataUpdated);
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
    await appDataStream?.cancel();
    await super.close();
  }
}
