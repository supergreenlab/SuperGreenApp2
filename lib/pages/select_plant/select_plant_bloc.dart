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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectPlantBlocEvent extends Equatable {}

class SelectPlantBlocEventInit extends SelectPlantBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SelectPlantBlocState extends Equatable {}

class SelectPlantBlocStateInit extends SelectPlantBlocState {
  @override
  List<Object> get props => [];
}

class SelectPlantBlocStateLoaded extends SelectPlantBlocState {
  final String title;
  final List<Plant> plants;
  final List<Box> boxes;
  final bool noPublic;

  SelectPlantBlocStateLoaded(this.title, this.plants, this.boxes, this.noPublic);

  @override
  List<Object> get props => [title, plants, boxes, noPublic];
}

class SelectPlantBloc extends LegacyBloc<SelectPlantBlocEvent, SelectPlantBlocState> {
  final MainNavigateToSelectPlantEvent args;

  SelectPlantBloc(this.args) : super(SelectPlantBlocStateInit()) {
    add(SelectPlantBlocEventInit());
  }

  @override
  Stream<SelectPlantBlocState> mapEventToState(SelectPlantBlocEvent event) async* {
    if (event is SelectPlantBlocEventInit) {
      List<Plant> plants = await RelDB.get().plantsDAO.getPlants();
      List<Box> boxes = await RelDB.get().plantsDAO.getBoxes();
      int initialPlantsCount = plants.length;
      if (args.noPublic) {
        plants = plants.where((p) => p.public == false).toList();
      }

      yield SelectPlantBlocStateLoaded(args.title, plants, boxes, plants.length == 0 && initialPlantsCount != 0);
    }
  }
}
