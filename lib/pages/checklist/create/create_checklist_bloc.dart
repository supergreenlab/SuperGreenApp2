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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class CreateChecklistBlocEvent extends Equatable {}

class CreateChecklistBlocEventInit extends CreateChecklistBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class CreateChecklistBlocState extends Equatable {}

class CreateChecklistBlocStateInit extends CreateChecklistBlocState {
  @override
  List<Object> get props => [];
}

class CreateChecklistBlocStateLoaded extends CreateChecklistBlocState {
  final Plant plant;

  CreateChecklistBlocStateLoaded(this.plant);

  @override
  List<Object> get props => [plant];
}

class CreateChecklistBloc extends LegacyBloc<CreateChecklistBlocEvent, CreateChecklistBlocState> {

  final MainNavigateToCreateChecklist args;

  CreateChecklistBloc(this.args) : super(CreateChecklistBlocStateInit()) {
    add(CreateChecklistBlocEventInit());
  }

  @override
  Stream<CreateChecklistBlocState> mapEventToState(CreateChecklistBlocEvent event) async* {
    if (event is CreateChecklistBlocEventInit) {
      yield CreateChecklistBlocStateLoaded(this.args.plant);
    }
  }
}
