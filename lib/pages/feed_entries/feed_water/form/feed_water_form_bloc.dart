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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/local/feed_entry_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_water.dart';

abstract class FeedWaterFormBlocEvent extends Equatable {}

class FeedWaterFormBlocEventCreate extends FeedWaterFormBlocEvent {
  final DateTime date;
  final bool tooDry;
  final double volume;
  final bool nutrient;
  final bool wateringLab;
  final double ph;
  final double ec;

  FeedWaterFormBlocEventCreate(this.date, this.tooDry, this.volume,
      this.nutrient, this.wateringLab, this.ph, this.ec);

  @override
  List<Object> get props =>
      [date, tooDry, volume, nutrient, wateringLab, ph, ec];
}

class FeedWaterFormBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedWaterFormBlocStateDone extends FeedWaterFormBlocState {
  final Plant plant;
  final FeedEntry feedEntry;

  FeedWaterFormBlocStateDone(this.plant, this.feedEntry);

  @override
  List<Object> get props => [];
}

class FeedWaterFormBloc
    extends Bloc<FeedWaterFormBlocEvent, FeedWaterFormBlocState> {
  final MainNavigateToFeedWaterFormEvent args;

  @override
  FeedWaterFormBlocState get initialState => FeedWaterFormBlocState();

  FeedWaterFormBloc(this.args);

  @override
  Stream<FeedWaterFormBlocState> mapEventToState(
      FeedWaterFormBlocEvent event) async* {
    if (event is FeedWaterFormBlocEventCreate) {
      final db = RelDB.get();
      List<Plant> plants = [args.plant];
      if (event.wateringLab) {
        plants = await db.plantsDAO.getPlantsInBox(args.plant.box);
      }
      FeedEntry feedEntry;
      for (int i = 0; i < plants.length; ++i) {
        int feedEntryID =
            await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
          type: 'FE_WATER',
          feed: plants[i].feed,
          date: event.date,
          params: Value(FeedWaterParams(event.volume, event.tooDry,
                  event.nutrient, event.ph, event.ec)
              .toJSON()),
        ));
        if (i == 0) {
          feedEntry = await db.feedsDAO.getFeedEntry(feedEntryID);
        }
      }
      yield FeedWaterFormBlocStateDone(args.plant, feedEntry);
    }
  }
}
