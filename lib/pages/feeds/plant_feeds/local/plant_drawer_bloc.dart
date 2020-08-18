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
  final List<GetPendingFeedsResult> hasPending;

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
  final List<GetPendingFeedsResult> hasPending;

  PlantDrawerBlocStatePlantListUpdated(
      this.plants, this.boxes, this.hasPending);

  @override
  List<Object> get props => [plants, boxes, hasPending];
}

class PlantDrawerBloc extends Bloc<PlantDrawerBlocEvent, PlantDrawerBlocState> {
  List<Plant> _plants = [];
  List<Box> _boxes = [];
  List<GetPendingFeedsResult> _hasPending = [];
  StreamSubscription<List<Plant>> _plantStream;
  StreamSubscription<List<Box>> _boxesStream;
  StreamSubscription<List<GetPendingFeedsResult>> _pendingStream;

  PlantDrawerBloc() : super(PlantDrawerBlocStateLoadingPlantList()) {
    add(PlantDrawerBlocEventLoadPlants());
  }

  @override
  Stream<PlantDrawerBlocState> mapEventToState(
      PlantDrawerBlocEvent event) async* {
    if (event is PlantDrawerBlocEventLoadPlants) {
      final db = RelDB.get().plantsDAO;
      _plantStream = db.watchPlants().listen(_onPlantListChange);
      _boxesStream = db.watchBoxes().listen(_onBoxListChange);
      final fdb = RelDB.get().feedsDAO;
      _pendingStream = fdb.getPendingFeeds().watch().listen(_hasPendingChange);
    } else if (event is PlantDrawerBlocEventBoxListUpdated) {
      yield PlantDrawerBlocStatePlantListUpdated(_plants, _boxes, _hasPending);
    }
  }

  void _onPlantListChange(List<Plant> plants) {
    _plants = plants;
    _plants.sort((p1, p2) => p1.name.compareTo(p2.name));
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _boxes, _hasPending));
  }

  void _onBoxListChange(List<Box> boxes) {
    _boxes = boxes;
    _boxes.sort((b1, b2) => b1.name.compareTo(b2.name));
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _boxes, _hasPending));
  }

  void _hasPendingChange(List<GetPendingFeedsResult> hasPending) {
    _hasPending = hasPending;
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _boxes, _hasPending));
  }

  @override
  Future<void> close() async {
    if (_plantStream != null) {
      await _plantStream.cancel();
    }
    if (_boxesStream != null) {
      await _boxesStream.cancel();
    }
    if (_pendingStream != null) {
      await _pendingStream.cancel();
    }
    return super.close();
  }
}
