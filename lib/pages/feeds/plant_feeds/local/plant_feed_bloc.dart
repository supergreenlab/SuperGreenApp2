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
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

abstract class PlantFeedBlocEvent extends Equatable {}

class PlantFeedBlocEventLoad extends PlantFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class PlantFeedBlocEventReloadChart extends PlantFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class PlantFeedBlocEventUpdated extends PlantFeedBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  PlantFeedBlocEventUpdated();

  @override
  List<Object> get props => [rand];
}

abstract class PlantFeedBlocState extends Equatable {}

class PlantFeedBlocStateInit extends PlantFeedBlocState {
  @override
  List<Object> get props => [];
}

class PlantFeedBlocStateNoPlant extends PlantFeedBlocState {
  PlantFeedBlocStateNoPlant() : super();

  @override
  List<Object> get props => [];
}

class PlantFeedBlocStateLoaded extends PlantFeedBlocState {
  final Box box;
  final Plant plant;
  final int nTimelapses;

  PlantFeedBlocStateLoaded(this.box, this.plant, this.nTimelapses);

  @override
  List<Object> get props => [box, plant, nTimelapses];
}

class PlantFeedBloc extends Bloc<PlantFeedBlocEvent, PlantFeedBlocState> {
  final HomeNavigateToPlantFeedEvent args;

  Box box;
  Plant plant;
  int nTimelapses;
  StreamSubscription<int> timelapsesStream;
  StreamSubscription<Plant> plantStream;

  PlantFeedBloc(this.args) {
    this.add(PlantFeedBlocEventLoad());
  }

  @override
  PlantFeedBlocState get initialState => PlantFeedBlocStateInit();

  @override
  Stream<PlantFeedBlocState> mapEventToState(PlantFeedBlocEvent event) async* {
    if (event is PlantFeedBlocEventLoad) {
      AppDB _db = AppDB();
      plant = args?.plant;
      if (plant == null) {
        AppData appData = _db.getAppData();
        if (appData.lastPlantID == null) {
          yield PlantFeedBlocStateNoPlant();
          return;
        }
        plant = await RelDB.get().plantsDAO.getPlant(appData.lastPlantID);
        if (plant == null) {
          List<Plant> plants = await RelDB.get().plantsDAO.getPlants();
          if (plants.length == 0) {
            _db.setLastPlant(null);
            yield PlantFeedBlocStateNoPlant();
            return;
          }
          plant = plants[0];
          _db.setLastPlant(plant.id);
        }
      } else {
        _db.setLastPlant(plant.id);
      }

      final db = RelDB.get();
      box = await db.plantsDAO.getBox(plant.box);
      nTimelapses =
          await RelDB.get().plantsDAO.nTimelapses(plant.id).getSingle();
      timelapsesStream = RelDB.get()
          .plantsDAO
          .nTimelapses(plant.id)
          .watchSingle()
          .listen(_onNTimelapsesUpdated);
      plantStream =
          RelDB.get().plantsDAO.watchPlant(plant.id).listen(_onPlantUpdated);
      yield PlantFeedBlocStateLoaded(box, plant, nTimelapses);
    } else if (event is PlantFeedBlocEventUpdated) {
      yield PlantFeedBlocStateLoaded(box, plant, nTimelapses);
    }
  }

  void _onPlantUpdated(Plant p) {
    plant = p;
    add(PlantFeedBlocEventUpdated());
  }

  void _onNTimelapsesUpdated(int n) {
    nTimelapses = n;
    add(PlantFeedBlocEventUpdated());
  }

  @override
  Future<void> close() async {
    if (timelapsesStream != null) {
      await timelapsesStream.cancel();
    }
    if (plantStream != null) {
      await plantStream.cancel();
    }
    return super.close();
  }
}
