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
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class BoxDrawerBlocEvent extends Equatable {}

class BoxDrawerBlocEventLoadBoxes extends BoxDrawerBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxDrawerBlocEventBoxListUpdated extends BoxDrawerBlocEvent {
  final List<Box> boxes;

  BoxDrawerBlocEventBoxListUpdated(this.boxes);

  @override
  List<Object> get props => [boxes];
}

abstract class BoxDrawerBlocState extends Equatable {}

class BoxDrawerBlocStateLoadingBoxList extends BoxDrawerBlocState {
  @override
  List<Object> get props => [];
}

class BoxDrawerBlocStateBoxListUpdated extends BoxDrawerBlocState {
  final List<Box> boxes;

  BoxDrawerBlocStateBoxListUpdated(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class BoxDrawerBloc extends Bloc<BoxDrawerBlocEvent, BoxDrawerBlocState> {
  @override
  BoxDrawerBlocState get initialState => BoxDrawerBlocStateLoadingBoxList();

  BoxDrawerBloc() {
    add(BoxDrawerBlocEventLoadBoxes());
  }

  @override
  Stream<BoxDrawerBlocState> mapEventToState(BoxDrawerBlocEvent event) async* {
    if (event is BoxDrawerBlocEventLoadBoxes) {
      final db = RelDB.get().boxesDAO;
      Stream<List<Box>> boxesStream = db.watchBoxes();
      boxesStream.listen(_onBoxListChange);
    } else if (event is BoxDrawerBlocEventBoxListUpdated) {
      yield BoxDrawerBlocStateBoxListUpdated(event.boxes);
    }
  }

  void _onBoxListChange(List<Box> boxes) {
    add(BoxDrawerBlocEventBoxListUpdated(boxes));
  }
}
