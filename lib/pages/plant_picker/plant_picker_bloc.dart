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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

abstract class PlantPickerBlocEvent extends Equatable {}

class PlantPickerBlocEventInit extends PlantPickerBlocEvent {
  PlantPickerBlocEventInit();

  @override
  List<Object> get props => [];
}

abstract class PlantPickerBlocState extends Equatable {}

class PlantPickerBlocStateInit extends PlantPickerBlocState {
  PlantPickerBlocStateInit();

  @override
  List<Object> get props => [];
}

class PlantPickerBlocStateLoaded extends PlantPickerBlocState {
  final String title;
  final List<Box> boxes;
  final List<Plant> plants;
  final List<Plant>? selectedPlants;

  PlantPickerBlocStateLoaded(this.title, this.boxes, this.plants, this.selectedPlants);

  @override
  List<Object?> get props => [title, boxes, plants, selectedPlants];
}

class PlantPickerBloc extends Bloc<PlantPickerBlocEvent, PlantPickerBlocState> {
  final MainNavigateToPlantPickerEvent args;

  PlantPickerBloc(this.args) : super(PlantPickerBlocStateInit()) {
    add(PlantPickerBlocEventInit());
  }

  @override
  Stream<PlantPickerBlocState> mapEventToState(PlantPickerBlocEvent event) async* {
    if (event is PlantPickerBlocEventInit) {
      List<Plant> plants = await RelDB.get().plantsDAO.getPlants();
      List<Box> boxes = await RelDB.get().plantsDAO.getBoxes();
      yield PlantPickerBlocStateLoaded(
          args.title,
          boxes..sort((b1, b2) => b1.name.compareTo(b2.name)),
          plants.where((p) {
            PlantSettings plantSettings = PlantSettings.fromJSON(p.settings);
            return plantSettings.dryingStart == null;
          }).toList()
            ..sort((p1, p2) => p1.name.compareTo(p2.name)),
          args.preselectedPlants);
    }
  }
}
