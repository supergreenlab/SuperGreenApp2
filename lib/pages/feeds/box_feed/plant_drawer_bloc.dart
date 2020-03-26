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

class PlantDrawerBlocEventLoadPlants extends PlantDrawerBlocEvent {
  @override
  List<Object> get props => [];
}

class PlantDrawerBlocEventBoxListUpdated extends PlantDrawerBlocEvent {
  final List<Plant> plants;
  final List<GetPendingFeedsResult> hasPending;

  PlantDrawerBlocEventBoxListUpdated(this.plants, this.hasPending);

  @override
  List<Object> get props => [plants, hasPending];
}

abstract class PlantDrawerBlocState extends Equatable {}

class PlantDrawerBlocStateLoadingBoxList extends PlantDrawerBlocState {
  @override
  List<Object> get props => [];
}

class PlantDrawerBlocStatePlantListUpdated extends PlantDrawerBlocState {
  final List<Plant> plants;
  final List<GetPendingFeedsResult> hasPending;

  PlantDrawerBlocStatePlantListUpdated(this.plants, this.hasPending);

  @override
  List<Object> get props => [plants, hasPending];
}

class PlantDrawerBloc extends Bloc<PlantDrawerBlocEvent, PlantDrawerBlocState> {
  List<Plant> _plants = [];
  List<GetPendingFeedsResult> _hasPending = [];

  @override
  PlantDrawerBlocState get initialState => PlantDrawerBlocStateLoadingBoxList();

  PlantDrawerBloc() {
    add(PlantDrawerBlocEventLoadPlants());
  }

  @override
  Stream<PlantDrawerBlocState> mapEventToState(PlantDrawerBlocEvent event) async* {
    if (event is PlantDrawerBlocEventLoadPlants) {
      final db = RelDB.get().plantsDAO;
      Stream<List<Plant>> plantsStream = db.watchPlants();
      plantsStream.listen(_onPlantListChange);
      final fdb = RelDB.get().feedsDAO;
      Stream<List<GetPendingFeedsResult>> hasPending =
          fdb.getPendingFeeds().watch();
      hasPending.listen(_hasPendingChange);
    } else if (event is PlantDrawerBlocEventBoxListUpdated) {
      yield PlantDrawerBlocStatePlantListUpdated(_plants, _hasPending);
    }
  }

  void _onPlantListChange(List<Plant> plants) {
    _plants = plants;
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _hasPending));
  }

  void _hasPendingChange(List<GetPendingFeedsResult> hasPending) {
    _hasPending = hasPending;
    add(PlantDrawerBlocEventBoxListUpdated(_plants, _hasPending));
  }
}
