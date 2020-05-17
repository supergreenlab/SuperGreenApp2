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

import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entries_param_helpers.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_care.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_light.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_measure.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_media.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_products.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_schedule.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_towelie_info.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_ventilation.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/feed_water.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class LocalFeedBloc extends FeedBlocProvider {
  final int feedID;
  final Map<String, FeedEntryLoader> loaders = {
    'FE_LIGHT': FeedLightLoader(),
    'FE_MEDIA': FeedMediaLoader(),
    'FE_MEASURE': FeedMeasureLoader(),
    'FE_SCHEDULE': FeedScheduleLoader(),
    'FE_TOPPING': FeedCareLoader(),
    'FE_DEFOLIATION': FeedCareLoader(),
    'FE_FIMMING': FeedCareLoader(),
    'FE_BENDING': FeedCareLoader(),
    'FE_TRANSPLANT': FeedCareLoader(),
    'FE_VENTILATION': FeedVentilationLoader(),
    'FE_WATER': FeedWaterLoader(),
    'FE_TOWELIE_INFO': FeedTowelieInfoLoader(),
    'FE_PRODUCTS': FeedProductsLoader(),
  };

  LocalFeedBloc(this.feedID);

  @override
  Future init() async {}

  @override
  Future<List<FeedEntryStateNotLoaded>> loadEntries(int n, int offset) async {
    List<FeedEntry> fe =
        await RelDB.get().feedsDAO.getEntries(feedID, n, offset);
    return fe
        .map<FeedEntryStateNotLoaded>((fe) => FeedEntryStateNotLoaded(
            fe.id,
            feedID,
            fe.type,
            fe.isNew,
            fe.synced,
            fe.date,
            FeedEntriesParamHelpers.paramForFeedEntryType(fe.type, fe.params)))
        .toList();
  }

  @override
  void startListenEntryChanges(FeedEntryStateLoaded entry) {}

  @override
  void cancelListenEntryChanges(FeedEntryState entry) {}
}
