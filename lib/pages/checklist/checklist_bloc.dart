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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:tuple/tuple.dart';

abstract class ChecklistBlocEvent extends Equatable {}

class ChecklistBlocEventInit extends ChecklistBlocEvent {
  @override
  List<Object> get props => [];
}

class ChecklistBlocEventLoad extends ChecklistBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class ChecklistBlocState extends Equatable {}

class ChecklistBlocStateInit extends ChecklistBlocState {
  @override
  List<Object> get props => [];
}

class ChecklistBlocStateLoaded extends ChecklistBlocState {
  final Plant plant;
  final Box box;
  final Checklist checklist;
  final List<ChecklistSeed> checklistSeeds;
  final List<Tuple2<ChecklistSeed, ChecklistAction>>? actions;

  ChecklistBlocStateLoaded(this.plant, this.box, this.checklist, this.checklistSeeds, this.actions);

  @override
  List<Object?> get props => [
        plant,
        box,
        checklist,
        checklistSeeds,
        actions,
      ];
}

class ChecklistBloc extends LegacyBloc<ChecklistBlocEvent, ChecklistBlocState> {
  final MainNavigateToChecklist args;

  late StreamSubscription subChecklistSeeds;
  late StreamSubscription subLogs;

  ChecklistBloc(this.args) : super(ChecklistBlocStateInit()) {
    add(ChecklistBlocEventInit());
  }

  @override
  Stream<ChecklistBlocState> mapEventToState(ChecklistBlocEvent event) async* {
    if (event is ChecklistBlocEventInit) {
      subChecklistSeeds = RelDB.get().checklistsDAO.watchChecklistSeeds(this.args.checklist.id).listen((e) {
        add(ChecklistBlocEventLoad());
      });
      subLogs = RelDB.get().checklistsDAO.watchChecklistLogs(this.args.checklist.id).listen((e) {
        add(ChecklistBlocEventLoad());
      });
    } else if (event is ChecklistBlocEventLoad) {
      List<ChecklistSeed> checklistSeeds = await RelDB.get().checklistsDAO.getChecklistSeeds(this.args.checklist.id);
      List<ChecklistLog> logs = await RelDB.get().checklistsDAO.getChecklistLogs(this.args.checklist.id);
      List<Tuple2<ChecklistSeed, ChecklistAction>> actions = [];
      for (int i = 0; i < logs.length; ++i) {
        Map<String, dynamic> action = json.decode(logs[i].action);
        ChecklistSeed checklistSeed = await RelDB.get().checklistsDAO.getChecklistSeed(logs[i].checklistSeed);
        actions.add(Tuple2(checklistSeed, ChecklistAction.fromMap(action)));
      }
      yield ChecklistBlocStateLoaded(this.args.plant, this.args.box, this.args.checklist, checklistSeeds, actions);
    }
  }

  @override
  Future<void> close() async {
    await subLogs.cancel();
    await subChecklistSeeds.cancel();
    return super.close();
  }
}
