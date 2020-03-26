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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class PlantDrawerBlocEvent extends Equatable {}

class PlantDrawerBlocEventLoadBoxes extends PlantDrawerBlocEvent {
  @override
  List<Object> get props => [];
}

class PlantDrawerBlocEventBoxListUpdated extends PlantDrawerBlocEvent {
  final List<Plant> boxes;
  final List<GetPendingFeedsResult> hasPending;

  PlantDrawerBlocEventBoxListUpdated(this.boxes, this.hasPending);

  @override
  List<Object> get props => [boxes, hasPending];
}

abstract class PlantDrawerBlocState extends Equatable {}

class PlantDrawerBlocStateLoadingBoxList extends PlantDrawerBlocState {
  @override
  List<Object> get props => [];
}

class BoxDrawerBlocStateBoxListUpdated extends PlantDrawerBlocState {
  final List<Plant> boxes;
  final List<GetPendingFeedsResult> hasPending;

  BoxDrawerBlocStateBoxListUpdated(this.boxes, this.hasPending);

  @override
  List<Object> get props => [boxes, hasPending];
}

class PlantDrawerBloc extends Bloc<PlantDrawerBlocEvent, PlantDrawerBlocState> {
  List<Plant> _boxes = [];
  List<GetPendingFeedsResult> _hasPending = [];

  @override
  PlantDrawerBlocState get initialState => PlantDrawerBlocStateLoadingBoxList();

  PlantDrawerBloc() {
    add(PlantDrawerBlocEventLoadBoxes());
  }

  @override
  Stream<PlantDrawerBlocState> mapEventToState(PlantDrawerBlocEvent event) async* {
    if (event is PlantDrawerBlocEventLoadBoxes) {
      final db = RelDB.get().plantsDAO;
      Stream<List<Plant>> plantsStream = db.watchPlants();
      plantsStream.listen(_onPlantListChange);
      final fdb = RelDB.get().feedsDAO;
      Stream<List<GetPendingFeedsResult>> hasPending =
          fdb.getPendingFeeds().watch();
      hasPending.listen(_hasPendingChange);
    } else if (event is PlantDrawerBlocEventBoxListUpdated) {
      yield BoxDrawerBlocStateBoxListUpdated(_boxes, _hasPending);
    }
  }

  void _onPlantListChange(List<Plant> boxes) {
    _boxes = boxes;
    add(PlantDrawerBlocEventBoxListUpdated(_boxes, _hasPending));
  }

  void _hasPendingChange(List<GetPendingFeedsResult> hasPending) {
    _hasPending = hasPending;
    add(PlantDrawerBlocEventBoxListUpdated(_boxes, _hasPending));
  }
}
