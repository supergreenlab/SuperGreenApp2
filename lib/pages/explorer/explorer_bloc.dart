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
import 'package:super_green_app/misc/bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class PlantState extends Equatable {
  final String id;
  final String name;
  final String filePath;
  final String thumbnailPath;

  PlantState(this.id, this.name, this.filePath, this.thumbnailPath);

  @override
  List<Object> get props => [id, name, filePath, thumbnailPath];
}

abstract class ExplorerBlocEvent extends Equatable {}

class ExplorerBlocEventInit extends ExplorerBlocEvent {
  @override
  List<Object> get props => [];
}

class ExplorerBlocEventMakePublic extends ExplorerBlocEvent {
  final Plant plant;

  ExplorerBlocEventMakePublic(this.plant);

  @override
  List<Object> get props => [plant];
}

class ExplorerBlocEventLoadNextPage extends ExplorerBlocEvent {
  final int offset;

  ExplorerBlocEventLoadNextPage(this.offset);

  @override
  List<Object> get props => [offset];
}

abstract class ExplorerBlocState extends Equatable {}

class ExplorerBlocStateInit extends ExplorerBlocState {
  @override
  List<Object> get props => [];
}

class ExplorerBlocStateLoaded extends ExplorerBlocState {
  final bool loggedIn;

  ExplorerBlocStateLoaded(this.loggedIn);

  @override
  List<Object> get props => [loggedIn];
}

class ExplorerBloc extends LegacyBloc<ExplorerBlocEvent, ExplorerBlocState> {
  ExplorerBloc() : super(ExplorerBlocStateInit()) {
    add(ExplorerBlocEventInit());
  }

  @override
  Stream<ExplorerBlocState> mapEventToState(ExplorerBlocEvent event) async* {
    if (event is ExplorerBlocEventInit) {
      yield ExplorerBlocStateInit();
      yield ExplorerBlocStateLoaded(BackendAPI().usersAPI.loggedIn);
    } else if (event is ExplorerBlocEventMakePublic) {
      await RelDB.get()
          .plantsDAO
          .updatePlant(PlantsCompanion(id: Value(event.plant.id), public: Value(true), synced: Value(false)));
    }
  }
}
