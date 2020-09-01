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
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_nutrient_mix.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';

abstract class FeedNutrientMixFormBlocEvent extends Equatable {}

class FeedNutrientMixFormBlocEventInit extends FeedNutrientMixFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBlocEventLoaded extends FeedNutrientMixFormBlocEvent {
  final List<Product> products;

  FeedNutrientMixFormBlocEventLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class FeedNutrientMixFormBlocEventCreate extends FeedNutrientMixFormBlocEvent {
  final List<NutrientProduct> nutrientProducts;

  FeedNutrientMixFormBlocEventCreate(this.nutrientProducts);

  @override
  List<Object> get props => [nutrientProducts];
}

abstract class FeedNutrientMixFormBlocState extends Equatable {}

class FeedNutrientMixFormBlocStateInit extends FeedNutrientMixFormBlocState {
  FeedNutrientMixFormBlocStateInit();

  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBlocStateLoaded extends FeedNutrientMixFormBlocState {
  final List<Product> products;

  FeedNutrientMixFormBlocStateLoaded(this.products);

  @override
  List<Object> get props => [products];
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

  StreamSubscription<Plant> plantStream;

  FeedNutrientMixFormBloc(this.args)
      : super(FeedNutrientMixFormBlocStateInit()) {
    add(FeedNutrientMixFormBlocEventInit());
  }

  @override
  Stream<FeedNutrientMixFormBlocState> mapEventToState(
      FeedNutrientMixFormBlocEvent event) async* {
    if (event is FeedNutrientMixFormBlocEventInit) {
      plantStream =
          RelDB.get().plantsDAO.watchPlant(args.plant.id).listen(plantUpdated);
      Plant plant = await RelDB.get().plantsDAO.getPlant(args.plant.id);
      PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
      yield FeedNutrientMixFormBlocStateLoaded(plantSettings.products
          .where((p) => p.category == ProductCategoryID.FERTILIZER)
          .toList());
    } else if (event is FeedNutrientMixFormBlocEventLoaded) {
      yield FeedNutrientMixFormBlocStateLoaded(event.products);
    } else if (event is FeedNutrientMixFormBlocEventCreate) {
      yield FeedNutrientMixFormBlocStateLoading();
      await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_SCHEDULE',
        feed: args.plant.feed,
        date: DateTime.now(),
        params: Value(FeedNutrientMixParams(event.nutrientProducts).toJSON()),
      ));
    }
  }

  void plantUpdated(Plant plant) {
    PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
    add(FeedNutrientMixFormBlocEventLoaded(plantSettings.products
        .where((p) => p.category == ProductCategoryID.FERTILIZER)
        .toList()));
  }

  @override
  Future<void> close() async {
    await plantStream.cancel();
    await super.close();
  }
}
