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
import 'package:super_green_app/data/api/backend/checklist/checklist_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class ChecklistCollectionsBlocEvent extends Equatable {}

class ChecklistCollectionsBlocEventInit extends ChecklistCollectionsBlocEvent {
  @override
  List<Object?> get props => [];
}

class ChecklistCollectionsBlocEventAddCollection extends ChecklistCollectionsBlocEvent {

  final ChecklistCollectionsCompanion collection;

  ChecklistCollectionsBlocEventAddCollection(this.collection);

  @override
  List<Object?> get props => [collection,];
}

abstract class ChecklistCollectionsBlocState extends Equatable {}

class ChecklistCollectionsBlocStateInit extends ChecklistCollectionsBlocState {
  @override
  List<Object?> get props => [];
}

class ChecklistCollectionsBlocStateLoaded extends ChecklistCollectionsBlocState {

  final List<ChecklistCollection> checklistCollections;
  final List<ChecklistCollectionsCompanion> collections;

  ChecklistCollectionsBlocStateLoaded(this.checklistCollections, this.collections);

  @override
  List<Object?> get props => [collections];
}

class ChecklistCollectionsBloc extends LegacyBloc<ChecklistCollectionsBlocEvent, ChecklistCollectionsBlocState> {

  final MainNavigateToChecklistCollections args;

  ChecklistCollectionsBloc(this.args) : super(ChecklistCollectionsBlocStateInit()) {
    add(ChecklistCollectionsBlocEventInit());
  }

  @override
  Stream<ChecklistCollectionsBlocState> mapEventToState(ChecklistCollectionsBlocEvent event) async* {
    if (event is ChecklistCollectionsBlocEventInit) {
      List<ChecklistCollection> checklistCollections = await RelDB.get().checklistsDAO.getChecklistCollectionsForChecklist(args.checklist);
      List<ChecklistCollectionsCompanion> collections = await BackendAPI().checklistAPI.getChecklistCollections();
      yield ChecklistCollectionsBlocStateLoaded(checklistCollections, collections);
    } else if (event is ChecklistCollectionsBlocEventAddCollection) {
      await ChecklistHelper.subscribeCollection(event.collection.serverID.value!, args.checklist);
    }
  }
}