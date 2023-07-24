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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:tuple/tuple.dart';

abstract class AppbarChecklistBlocEvent extends Equatable {}

class AppbarChecklistBlocEventInit extends AppbarChecklistBlocEvent {
  @override
  List<Object> get props => [];
}

class AppbarChecklistBlocEventCreate extends AppbarChecklistBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class AppbarChecklistBlocState extends Equatable {}

class AppbarChecklistBlocStateInit extends AppbarChecklistBlocState {
  @override
  List<Object> get props => [];
}

class AppbarChecklistBlocStateCreated extends AppbarChecklistBlocState {
  final Checklist checklist;

  AppbarChecklistBlocStateCreated(this.checklist);

  @override
  List<Object> get props => [
        checklist,
      ];
}

class AppbarChecklistBlocStateLoaded extends AppbarChecklistBlocState {
  final Plant plant;
  final Checklist? checklist;
  final List<ChecklistSeed>? activeSeeds;
  List<Tuple2<ChecklistSeed, ChecklistAction>>? actions;

  AppbarChecklistBlocStateLoaded(this.plant, this.checklist, this.activeSeeds, this.actions);

  @override
  List<Object?> get props => [plant, checklist, activeSeeds, actions];
}

class AppbarChecklistBloc extends LegacyBloc<AppbarChecklistBlocEvent, AppbarChecklistBlocState> {
  final Plant plant;
  Checklist? checklist;
  List<ChecklistSeed>? activeSeeds;
  List<Tuple2<ChecklistSeed, ChecklistAction>>? actions;

  AppbarChecklistBloc(this.plant) : super(AppbarChecklistBlocStateInit()) {
    add(AppbarChecklistBlocEventInit());
  }

  @override
  Stream<AppbarChecklistBlocState> mapEventToState(AppbarChecklistBlocEvent event) async* {
    if (event is AppbarChecklistBlocEventInit) {
      try {
        checklist = await RelDB.get().checklistsDAO.getChecklistForPlant(this.plant.id);
      } catch (e) {}
      activeSeeds = [];
      actions = [];
      activeSeeds!.forEach((as) {
        List<ChecklistAction> acts = json.decode(as.actions);
        acts.forEach((a) {
          actions!.add(Tuple2(as, a));
        });
      });
      yield AppbarChecklistBlocStateLoaded(this.plant, checklist, activeSeeds, actions);
    } else if (event is AppbarChecklistBlocEventCreate) {
      int checklistID = await RelDB.get().checklistsDAO.addChecklist(ChecklistsCompanion.insert(
            plant: this.plant.id,
            synced: Value(false),
          ));
      checklist = await RelDB.get().checklistsDAO.getChecklist(checklistID);
      yield AppbarChecklistBlocStateCreated(checklist!);
    }
  }
}
