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

abstract class ChecklistBlocEvent extends Equatable {}

class ChecklistBlocEventInit extends ChecklistBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class ChecklistBlocState extends Equatable {}

class ChecklistBlocStateInit extends ChecklistBlocState {
  @override
  List<Object> get props => [];
}

class ChecklistBlocStateLoaded extends ChecklistBlocState {
  final Checklist checklist;
  final List<ChecklistSeed> checklistSeeds;

  ChecklistBlocStateLoaded(this.checklist, this.checklistSeeds);

  @override
  List<Object> get props => [checklist, checklistSeeds,];
}

class ChecklistBloc extends LegacyBloc<ChecklistBlocEvent, ChecklistBlocState> {
  final MainNavigateToChecklist args;

  ChecklistBloc(this.args) : super(ChecklistBlocStateInit()) {
    add(ChecklistBlocEventInit());
  }

  @override
  Stream<ChecklistBlocState> mapEventToState(ChecklistBlocEvent event) async* {
    if (event is ChecklistBlocEventInit) {
      List<ChecklistSeed> checklistSeeds = await RelDB.get().checklistsDAO.getChecklistSeeds(this.args.checklist.id);
      yield ChecklistBlocStateLoaded(this.args.checklist, checklistSeeds);
    }
  }
}
