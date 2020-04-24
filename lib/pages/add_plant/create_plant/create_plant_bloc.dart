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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class CreatePlantBlocEvent extends Equatable {}

class CreatePlantBlocEventCreate extends CreatePlantBlocEvent {
  final String name;
  final bool isSingle;
  final int box;
  CreatePlantBlocEventCreate(this.name, this.isSingle, this.box);

  @override
  List<Object> get props => [name, box];
}

class CreatePlantBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePlantBlocStateDone extends CreatePlantBlocState {
  final Plant plant;
  final Box box;
  CreatePlantBlocStateDone(this.plant, this.box);

  @override
  List<Object> get props => [plant, box];
}

class CreatePlantBloc extends Bloc<CreatePlantBlocEvent, CreatePlantBlocState> {
  @override
  CreatePlantBlocState get initialState => CreatePlantBlocState();

  @override
  Stream<CreatePlantBlocState> mapEventToState(
      CreatePlantBlocEvent event) async* {
    if (event is CreatePlantBlocEventCreate) {
      final bdb = RelDB.get().plantsDAO;
      final fdb = RelDB.get().feedsDAO;
      final feed = FeedsCompanion.insert(name: event.name);
      final feedID = await fdb.addFeed(feed);
      PlantsCompanion plant;
      plant = PlantsCompanion.insert(
          feed: feedID,
          name: event.name,
          box: Value(event.box),
          settings: Value(jsonEncode({'isSingle': event.isSingle})));
      final plantID = await bdb.addPlant(plant);
      final p = await bdb.getPlant(plantID);
      final b = await bdb.getBox(event.box);
      yield CreatePlantBlocStateDone(p, b);
    }
  }
}
