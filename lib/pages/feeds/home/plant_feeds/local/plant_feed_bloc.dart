/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:drift/drift.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/misc/bloc.dart';
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

class PlantFeedBlocEventMakePublic extends PlantFeedBlocEvent {
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
  final FeedEntry? feedEntry;
  final String? commentID;
  final String? replyTo;

  PlantFeedBlocStateLoaded(this.box, this.plant, {this.feedEntry, this.commentID, this.replyTo});

  @override
  List<Object?> get props => [box, plant, feedEntry, commentID, replyTo];
}

class PlantFeedBlocStatePlantRemoved extends PlantFeedBlocState {
  @override
  List<Object> get props => [];
}

class PlantFeedBloc extends LegacyBloc<PlantFeedBlocEvent, PlantFeedBlocState> {
  final HomeNavigateToPlantFeedEvent args;

  late Box? box;
  late Plant? plant;
  StreamSubscription<List<Plant>>? plantsStream;
  StreamSubscription<Plant>? plantStream;
  StreamSubscription<Box>? boxStream;

  PlantFeedBloc(this.args) : super(PlantFeedBlocStateInit()) {
    this.add(PlantFeedBlocEventLoad());
  }

  @override
  Stream<PlantFeedBlocState> mapEventToState(PlantFeedBlocEvent event) async* {
    if (event is PlantFeedBlocEventLoad) {
      plant = await PlantFeedBloc.getDisplayPlant(args.plant);
      if (plant == null) {
        int nPlants = await RelDB.get().plantsDAO.nPlants().getSingle();
        if (nPlants == 0) {
          plantsStream = RelDB.get().plantsDAO.watchPlants().listen((event) {
            if (event.length != 0) {
              this.add(PlantFeedBlocEventLoad());
              plantsStream!.cancel();
              plantsStream = null;
            }
          });
          yield PlantFeedBlocStateNoPlant();
          return;
        } else {
          try {
            plant = await RelDB.get().plantsDAO.getLastPlant();
            AppDB _db = AppDB();
            _db.setLastPlant(plant!.id);
          } catch (e, trace) {
            Logger.logError(e, trace);
            yield PlantFeedBlocStateNoPlant();
            return;
          }
        }
      }
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(plant!.box);
      plantStream = RelDB.get().plantsDAO.watchPlant(plant!.id).listen(_onPlantUpdated);
      boxStream = RelDB.get().plantsDAO.watchBox(plant!.box).listen(_onBoxUpdated);
      yield PlantFeedBlocStateLoaded(box!, plant!,
          feedEntry: args.feedEntry, commentID: args.commentID, replyTo: args.replyTo);
    } else if (event is PlantFeedBlocEventUpdated) {
      if (plant == null) {
        yield PlantFeedBlocStatePlantRemoved();
        return;
      }
      yield PlantFeedBlocStateLoaded(box!, plant!,
          feedEntry: args.feedEntry, commentID: args.commentID, replyTo: args.replyTo);
    } else if (event is PlantFeedBlocEventMakePublic) {
      if (plant == null) {
        return;
      }
      await RelDB.get()
          .plantsDAO
          .updatePlant(PlantsCompanion(id: Value(plant!.id), public: Value(true), synced: Value(false)));
    }
  }

  void _onPlantUpdated(Plant p) {
    plant = p;
    add(PlantFeedBlocEventUpdated());
  }

  void _onBoxUpdated(Box b) {
    box = b;
    add(PlantFeedBlocEventUpdated());
  }

  @override
  Future<void> close() async {
    await plantStream?.cancel();
    await boxStream?.cancel();
    if (plantsStream != null) {
      await plantsStream!.cancel();
    }
    return super.close();
  }

  static Future<Plant?> getDisplayPlant(Plant? plant) async {
    AppDB _db = AppDB();
    if (plant == null) {
      AppData appData = _db.getAppData();
      if (appData.lastPlantID == null) {
        return null;
      }
      try {
        plant = await RelDB.get().plantsDAO.getPlant(appData.lastPlantID!);
      } catch (e) {}
      if (plant == null) {
        List<Plant> plants = await RelDB.get().plantsDAO.getPlants();
        if (plants.length == 0) {
          _db.setLastPlant(null);
          return null;
        }
        plant = plants[0];
        _db.setLastPlant(plant.id);
      }
    } else {
      _db.setLastPlant(plant.id);
    }
    return plant;
  }
}
