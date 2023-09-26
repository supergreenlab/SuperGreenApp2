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

import 'package:super_green_app/data/rel/checklist/checklists.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class PlantDrawerBlocEvent extends Equatable {}

class PlantDrawerBlocEventLoadPlants extends PlantDrawerBlocEvent {
  @override
  List<Object> get props => [];
}

class PlantDrawerBlocEventBoxListUpdated extends PlantDrawerBlocEvent {
  final List<Plant> plants;
  final List<Box> boxes;
  final List<GetNLogsPerPlantsResult> hasPending;

  PlantDrawerBlocEventBoxListUpdated(this.plants, this.boxes, this.hasPending);

  @override
  List<Object> get props => [plants, boxes, hasPending];
}

abstract class PlantDrawerBlocState extends Equatable {}

class PlantDrawerBlocStateLoadingPlantList extends PlantDrawerBlocState {
  @override
  List<Object> get props => [];
}

class PlantDrawerBlocStatePlantListUpdated extends PlantDrawerBlocState {
  final List<Plant> plants;
  final List<Box> boxes;
  final List<GetNLogsPerPlantsResult> hasPending;

  PlantDrawerBlocStatePlantListUpdated(this.plants, this.boxes, this.hasPending);

  @override
  List<Object> get props => [plants, boxes, hasPending];
}

class PlantDrawerBloc extends LegacyBloc<PlantDrawerBlocEvent, PlantDrawerBlocState> {
  List<Plant> _plants = [];
  List<Box> _boxes = [];
  List<GetNLogsPerPlantsResult> _hasPending = [];
  StreamSubscription<List<Plant>>? _plantStream;
  StreamSubscription<List<Box>>? _boxesStream;
  StreamSubscription<List<GetNLogsPerPlantsResult>>? _pendingStream;

  PlantDrawerBloc() : super(PlantDrawerBlocStateLoadingPlantList()) {
    add(PlantDrawerBlocEventLoadPlants());
  }

  @override
  Stream<PlantDrawerBlocState> mapEventToState(PlantDrawerBlocEvent event) async* {
    if (event is PlantDrawerBlocEventLoadPlants) {
      final db = RelDB.get().plantsDAO;
      _plantStream = RelDB.get().plantsDAO.watchPlants().listen(_onPlantListChange);
      _boxesStream = RelDB.get().plantsDAO.watchBoxes().listen(_onBoxListChange);
      _pendingStream = RelDB.get().checklistsDAO.getNLogsPerPlants().watch().listen(_hasPendingChange);
    } else if (event is PlantDrawerBlocEventBoxListUpdated) {
      yield PlantDrawerBlocStatePlantListUpdated(_plants, _boxes, _hasPending);
    }
  }

  void _onPlantListChange(List<Plant> plants) {
    _plants = plants;
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _boxes, _hasPending));
  }

  void _onBoxListChange(List<Box> boxes) {
    _boxes = boxes;
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _boxes, _hasPending));
  }

  void _hasPendingChange(List<GetNLogsPerPlantsResult> hasPending) {
    _hasPending = hasPending;
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _boxes, _hasPending));
  }

  @override
  Future<void> close() async {
    await _plantStream?.cancel();
    await _boxesStream?.cancel();
    await _pendingStream?.cancel();
    return super.close();
  }
}
