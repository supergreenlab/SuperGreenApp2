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
import 'package:super_green_app/pages/feed_entries/feed_nutrient_mix/card/feed_nutrient_mix_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/local_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedNutrientMixLoader extends LocalFeedEntryLoader {
  FeedNutrientMixLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future<FeedEntryStateLoaded> load(FeedEntryState state) async =>
      FeedNutrientMixState(state);

  @override
  FeedEntryState stateForFeedEntry(FeedEntry feedEntry) =>
      FeedNutrientMixState(super.stateForFeedEntry(feedEntry));
}
