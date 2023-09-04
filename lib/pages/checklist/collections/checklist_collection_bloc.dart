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
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class ChecklistCollectionBlocEvent extends Equatable {}

class ChecklistCollectionBlocEventInit extends ChecklistCollectionBlocEvent {
  @override
  List<Object?> get props => [];
}

abstract class ChecklistCollectionBlocState extends Equatable {}

class ChecklistCollectionBlocStateInit extends ChecklistCollectionBlocState {
  @override
  List<Object?> get props => [];
}

class ChecklistCollectionBlocStateLoaded extends ChecklistCollectionBlocState {

  final List<ChecklistCollectionsCompanion> collections;

  ChecklistCollectionBlocStateLoaded(this.collections);

  @override
  List<Object?> get props => [collections];
}

class ChecklistCollectionBloc extends LegacyBloc<ChecklistCollectionBlocEvent, ChecklistCollectionBlocState> {

  final Plant plant;

  ChecklistCollectionBloc(this.plant) : super(ChecklistCollectionBlocStateInit()) {
    add(ChecklistCollectionBlocEventInit());
  }

  @override
  Stream<ChecklistCollectionBlocState> mapEventToState(ChecklistCollectionBlocEvent event) async* {
    if (event is ChecklistCollectionBlocEventInit) {
      List<ChecklistCollectionsCompanion> collections = await BackendAPI().checklistAPI.getChecklistCollections();
      yield ChecklistCollectionBlocStateLoaded(collections);
    }
  }
}