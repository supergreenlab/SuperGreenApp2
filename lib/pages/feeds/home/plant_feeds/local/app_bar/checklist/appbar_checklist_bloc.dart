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

import 'dart:async';
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

class AppbarChecklistBlocEventoad extends AppbarChecklistBlocEvent {
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
  final List<Tuple2<ChecklistSeed, ChecklistAction>>? actions;

  AppbarChecklistBlocStateLoaded(this.plant, this.checklist, this.actions);

  @override
  List<Object?> get props => [plant, checklist, actions];
}

class AppbarChecklistBloc extends LegacyBloc<AppbarChecklistBlocEvent, AppbarChecklistBlocState> {
  final Plant plant;
  Checklist? checklist;
  List<Tuple2<ChecklistSeed, ChecklistAction>> actions = [];

  late StreamSubscription? subChecklist;
  late StreamSubscription subLogs;

  AppbarChecklistBloc(this.plant) : super(AppbarChecklistBlocStateInit()) {
    add(AppbarChecklistBlocEventInit());
  }

  @override
  Stream<AppbarChecklistBlocState> mapEventToState(AppbarChecklistBlocEvent event) async* {
    if (event is AppbarChecklistBlocEventInit) {
      try {
        checklist = await RelDB.get().checklistsDAO.getChecklistForPlant(this.plant.id);
      } catch (e) {
        subChecklist = RelDB.get().checklistsDAO.watchChecklistForPlant(this.plant.id).listen((event) {
          add(AppbarChecklistBlocEventoad());
        });
        yield AppbarChecklistBlocStateLoaded(this.plant, checklist, actions);
      }
      subLogs = RelDB.get().checklistsDAO.watchChecklistLogs(checklist!.id).listen((e) {
        add(AppbarChecklistBlocEventoad());
      });
    } else if (event is AppbarChecklistBlocEventoad) {
      try {
        checklist = await RelDB.get().checklistsDAO.getChecklistForPlant(this.plant.id);
      } catch (e) {
        yield AppbarChecklistBlocStateLoaded(this.plant, checklist, actions);
      }
      List<ChecklistLog> logs = await RelDB.get().checklistsDAO.getChecklistLogs(checklist!.id);
      actions = [];
      for (int i = 0; i < logs.length; ++i) {
        Map<String, dynamic> action = json.decode(logs[i].action);
        ChecklistSeed checklistSeed = await RelDB.get().checklistsDAO.getChecklistSeed(logs[i].checklistSeed);
        actions.add(Tuple2(checklistSeed, ChecklistAction.fromMap(action)));
      }
      yield AppbarChecklistBlocStateLoaded(this.plant, checklist, actions);
    } else if (event is AppbarChecklistBlocEventCreate) {
      int checklistID = await RelDB.get().checklistsDAO.addChecklist(ChecklistsCompanion.insert(
            plant: this.plant.id,
            synced: Value(false),
          ));
      checklist = await RelDB.get().checklistsDAO.getChecklist(checklistID);
      yield AppbarChecklistBlocStateCreated(checklist!);
    }
  }

  @override
  Future<void> close() async {
    if (subChecklist != null) {
      await subChecklist!.cancel();
    }
    await subLogs.cancel();
    return super.close();
  }
}
