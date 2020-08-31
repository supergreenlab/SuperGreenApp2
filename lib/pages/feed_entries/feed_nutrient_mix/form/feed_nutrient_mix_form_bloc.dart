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
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_nutrient_mix.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_schedule.dart';

abstract class FeedNutrientMixFormBlocEvent extends Equatable {}

class FeedNutrientMixFormBlocEventInit extends FeedNutrientMixFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBlocEventCreate extends FeedNutrientMixFormBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class FeedNutrientMixFormBlocState extends Equatable {}

class FeedNutrientMixFormBlocStateInit extends FeedNutrientMixFormBlocState {
  FeedNutrientMixFormBlocStateInit();

  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBlocStateLoaded extends FeedNutrientMixFormBlocState {
  FeedNutrientMixFormBlocStateLoaded();

  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBlocStateLoading extends FeedNutrientMixFormBlocState {
  FeedNutrientMixFormBlocStateLoading();

  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBlocStateDone extends FeedNutrientMixFormBlocState {
  FeedNutrientMixFormBlocStateDone();

  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBloc
    extends Bloc<FeedNutrientMixFormBlocEvent, FeedNutrientMixFormBlocState> {
  final MainNavigateToFeedNutrientMixFormEvent args;

  FeedNutrientMixFormBloc(this.args)
      : super(FeedNutrientMixFormBlocStateInit()) {
    add(FeedNutrientMixFormBlocEventInit());
  }

  @override
  Stream<FeedNutrientMixFormBlocState> mapEventToState(
      FeedNutrientMixFormBlocEvent event) async* {
    if (event is FeedNutrientMixFormBlocEventInit) {
      yield FeedNutrientMixFormBlocStateLoaded();
    } else if (event is FeedNutrientMixFormBlocEventCreate) {
      yield FeedNutrientMixFormBlocStateLoading();
      await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_SCHEDULE',
        feed: args.plant.feed,
        date: DateTime.now(),
        params: Value(FeedNutrientMixParams().toJSON()),
      ));
    }
  }
}
