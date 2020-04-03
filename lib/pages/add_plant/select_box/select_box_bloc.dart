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

abstract class SelectBoxBlocEvent extends Equatable {}

class SelectBoxBlocEventInit extends SelectBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectBoxBlocEventCreate extends SelectBoxBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;

  SelectBoxBlocEventCreate(this.name, {this.device, this.deviceBox});

  @override
  List<Object> get props => [name, device, deviceBox];
}

abstract class SelectBoxBlocState extends Equatable {}

class SelectBoxBlocStateLoading extends SelectBoxBlocState {
  @override
  List<Object> get props => [];
}

class SelectBoxBlocStateLoaded extends SelectBoxBlocState {
  final List<Box> boxes;

  SelectBoxBlocStateLoaded(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class SelectBoxBloc extends Bloc<SelectBoxBlocEvent, SelectBoxBlocState> {
  //ignore: unused_field
  MainNavigateToSelectBoxEvent _args;

  SelectBoxBloc(this._args) {
    add(SelectBoxBlocEventInit());
  }

  @override
  SelectBoxBlocState get initialState => SelectBoxBlocStateLoading();

  @override
  Stream<SelectBoxBlocState> mapEventToState(SelectBoxBlocEvent event) async* {
    if (event is SelectBoxBlocEventInit) {
      yield SelectBoxBlocStateLoading();
      List<Box> boxes = await RelDB.get().plantsDAO.getBoxes();
      yield SelectBoxBlocStateLoaded(boxes);
    }
  }
}
