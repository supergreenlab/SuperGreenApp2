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
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:collection/collection.dart';

abstract class FeedNutrientMixFormBlocEvent extends Equatable {}

class FeedNutrientMixFormBlocEventInit extends FeedNutrientMixFormBlocEvent {
  @override
  List<Object> get props => [];
}

// class FeedNutrientMixFormBlocEventAddNutrients
//     extends FeedNutrientMixFormBlocEvent {
//   final List<NutrientProduct> missingProducts;

//   FeedNutrientMixFormBlocEventAddNutrients(this.missingProducts);

//   @override
//   List<Object> get props => [missingProducts];
// }

class FeedNutrientMixFormBlocEventLoaded extends FeedNutrientMixFormBlocEvent {
  final List<Product> products;

  FeedNutrientMixFormBlocEventLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class FeedNutrientMixFormBlocEventCreate extends FeedNutrientMixFormBlocEvent {
  final DateTime date;
  final String name;
  final double volume;
  final double? ph;
  final double? ec;
  final double? tds;
  final List<NutrientProduct> nutrientProducts;
  final String message;
  final List<Plant> plants;
  final NutrientMixPhase? phase;
  final FeedNutrientMixParams? baseNutrientMixParams;

  FeedNutrientMixFormBlocEventCreate(this.date, this.name, this.volume, this.ph, this.ec, this.tds,
      this.nutrientProducts, this.message, this.plants, this.phase, this.baseNutrientMixParams);

  @override
  List<Object?> get props =>
      [date, name, volume, ph, ec, nutrientProducts, message, plants, phase, baseNutrientMixParams];
}

abstract class FeedNutrientMixFormBlocState extends Equatable {}

class FeedNutrientMixFormBlocStateInit extends FeedNutrientMixFormBlocState {
  FeedNutrientMixFormBlocStateInit();

  @override
  List<Object> get props => [];
}

class FeedNutrientMixFormBlocStateLoaded extends FeedNutrientMixFormBlocState {
  final int nPlants;
  final Plant plant;
  final List<Product> products;
  final List<FeedNutrientMixParams> lastNutrientMixParams;

  FeedNutrientMixFormBlocStateLoaded(this.nPlants, this.plant, this.products, this.lastNutrientMixParams);

  @override
  List<Object> get props => [this.nPlants, plant, products, lastNutrientMixParams];
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

class FeedNutrientMixFormBloc extends Bloc<FeedNutrientMixFormBlocEvent, FeedNutrientMixFormBlocState> {
  final MainNavigateToFeedNutrientMixFormEvent args;

  List<FeedNutrientMixParams> lastNutrientMixParams = [];
  StreamSubscription<Plant>? plantStream;

  FeedNutrientMixFormBloc(this.args) : super(FeedNutrientMixFormBlocStateInit()) {
    add(FeedNutrientMixFormBlocEventInit());
  }

  @override
  Stream<FeedNutrientMixFormBlocState> mapEventToState(FeedNutrientMixFormBlocEvent event) async* {
    if (event is FeedNutrientMixFormBlocEventInit) {
      List<FeedEntry> nutrientMixes = await RelDB.get().feedsDAO.getFeedEntriesWithType('FE_NUTRIENT_MIX');
      Map<String, FeedEntry> lastNutrientMixParamsMap = {};
      for (FeedEntry nutrientMix in nutrientMixes) {
        FeedNutrientMixParams params = FeedNutrientMixParams.fromJSON(nutrientMix.params);
        if (params.name != null && params.name != '') {
          if (lastNutrientMixParamsMap[params.name] == null) {
            lastNutrientMixParamsMap[params.name!] = nutrientMix;
          } else if (lastNutrientMixParamsMap[params.name]!.date.isBefore(nutrientMix.date)) {
            lastNutrientMixParamsMap[params.name!] = nutrientMix;
          }
        }
      }
      lastNutrientMixParams =
          lastNutrientMixParamsMap.values.map((nm) => FeedNutrientMixParams.fromJSON(nm.params)).toList();
      lastNutrientMixParams.sort((np1, np2) {
        if (np1.phase == null && np2.phase == null) {
          return 0;
        } else if (np1.phase == null) {
          return 1;
        } else if (np2.phase == null) {
          return -1;
        }
        return np1.phase!.index - np2.phase!.index;
      });
      plantStream = RelDB.get().plantsDAO.watchPlant(args.plant.id).listen(plantUpdated);
      int nPlants = await RelDB.get().plantsDAO.nPlants().getSingle();
      Plant plant = await RelDB.get().plantsDAO.getPlant(args.plant.id);
      PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
      yield FeedNutrientMixFormBlocStateLoaded(
          nPlants,
          plant,
          plantSettings.products!.where((p) => p.category == ProductCategoryID.FERTILIZER).toList(),
          lastNutrientMixParams);
      // } else if (event is FeedNutrientMixFormBlocEventAddNutrients) {
      //   Plant plant = await RelDB.get().plantsDAO.getPlant(args.plant.id);
      //   addProductsToPlant(plant, event.missingProducts);
    } else if (event is FeedNutrientMixFormBlocEventLoaded) {
      int nPlants = await RelDB.get().plantsDAO.nPlants().getSingle();
      Plant plant = await RelDB.get().plantsDAO.getPlant(args.plant.id);
      yield FeedNutrientMixFormBlocStateLoaded(nPlants, plant, event.products, lastNutrientMixParams);
    } else if (event is FeedNutrientMixFormBlocEventCreate) {
      yield FeedNutrientMixFormBlocStateLoading();
      for (Plant plant in event.plants) {
        await addProductsToPlant(plant, event.nutrientProducts);
        await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
          type: 'FE_NUTRIENT_MIX',
          feed: plant.feed,
          date: event.date,
          params: Value(FeedNutrientMixParams(
                  name: event.name,
                  volume: event.volume,
                  ph: event.ph,
                  ec: event.ec,
                  tds: event.tds,
                  nutrientProducts:
                      event.nutrientProducts.where((np) => np.quantity != null && np.quantity! > 0).toList(),
                  message: event.message,
                  phase: event.phase,
                  basedOn: event.baseNutrientMixParams?.name)
              .toJSON()),
        ));
      }
      yield FeedNutrientMixFormBlocStateDone();
    }
  }

  Future addProductsToPlant(Plant plant, List<NutrientProduct> nutrientProducts) async {
    bool updatePlant = false;
    PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
    for (NutrientProduct nutrientProduct in nutrientProducts) {
      if (nutrientProduct.quantity != null && nutrientProduct.quantity == 0) {
        continue;
      }
      if (plantSettings.products!.firstWhereOrNull((p) => p.id == nutrientProduct.product.id) == null) {
        plantSettings.products!.add(nutrientProduct.product);
        updatePlant = true;
      }
    }
    if (updatePlant) {
      await RelDB.get().plantsDAO.updatePlant(
          PlantsCompanion(id: Value(plant.id), settings: Value(plantSettings.toJSON()), synced: Value(false)));
    }
  }

  void plantUpdated(Plant plant) {
    PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
    add(FeedNutrientMixFormBlocEventLoaded(
        plantSettings.products!.where((p) => p.category == ProductCategoryID.FERTILIZER).toList()));
  }

  @override
  Future<void> close() async {
    await plantStream?.cancel();
    await super.close();
  }
}
