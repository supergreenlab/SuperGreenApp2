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
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/local_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

class SGLFeedBlocDelegate extends LocalFeedBlocDelegate {
  late FeedState feedState;
  StreamSubscription<hive.BoxEvent>? appDataStream;

  SGLFeedBlocDelegate(int feedID) : super(feedID);

  @override
  FeedEntryState postProcess(FeedEntryState state) {
    return state.copyWith(shareLink: 'pouet');
  }

  @override
  void loadFeed() async {
    AppData appData = AppDB().getAppData();
    feedState = FeedState(appData.jwt != null, appData.storeGeo);
    add(FeedBlocEventFeedLoaded(feedState));

    appDataStream = AppDB().watchAppData().listen(appDataUpdated, onError: (err) {
      print('error $err');
    });
  }

  void appDataUpdated(hive.BoxEvent boxEvent) {
    add(FeedBlocEventFeedLoaded(feedState.copyWith(
      loggedIn: (boxEvent.value as AppData).jwt != null,
      storeGeo: (boxEvent.value as AppData).storeGeo,
    )));
  }

  @override
  Future<void> close() async {
    await appDataStream?.cancel();
    await super.close();
  }

  @override
  Future likeFeedEntry(FeedEntryState entry) async {}
}
