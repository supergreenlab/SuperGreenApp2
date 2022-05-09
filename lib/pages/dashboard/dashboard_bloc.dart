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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class DashboardBlocEvent extends Equatable {}

class DashboardBlocEventInit extends DashboardBlocEvent {
  @override
  List<Object?> get props => [];
}

abstract class DashboardBlocState extends Equatable {}

class DashboardBlocStateInit extends DashboardBlocState {
  @override
  List<Object?> get props => [];
}

class DashboardBlocStateLoaded extends DashboardBlocState {
  final List<Plant> plants;
  final List<Box> boxes;

  DashboardBlocStateLoaded(this.plants, this.boxes);

  @override
  List<Object?> get props => [plants, boxes];
}

class DashboardBloc extends LegacyBloc<DashboardBlocEvent, DashboardBlocState> {
  DashboardBloc() : super(DashboardBlocStateInit()) {
    add(DashboardBlocEventInit());
  }

  @override
  Stream<DashboardBlocState> mapEventToState(DashboardBlocEvent event) async* {
    if (event is DashboardBlocEventInit) {
      List<Plant> plants = await RelDB.get().plantsDAO.getPlants();
      List<Box> boxes = await RelDB.get().plantsDAO.getBoxes();
      plants.sort((p1, p2) {
        if (p1.box == p2.box) {
          return p1.name.compareTo(p2.name);
        }
        Box b1 = boxes.firstWhere((b) => b.id == p1.box);
        Box b2 = boxes.firstWhere((b) => b.id == p2.box);
        return b1.name.compareTo(b2.name);
      });
      yield DashboardBlocStateLoaded(plants, boxes);
    }
  }
}
