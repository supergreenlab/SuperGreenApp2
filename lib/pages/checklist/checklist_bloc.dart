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
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/checklist/checklist_helper.dart';
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

class ChecklistBlocEventDeleteChecklistSeed extends ChecklistBlocEvent {
  final ChecklistSeed checklistSeed;

  ChecklistBlocEventDeleteChecklistSeed(this.checklistSeed);

  @override
  List<Object> get props => [checklistSeed];
}

class ChecklistBlocEventCheckChecklistLog extends ChecklistBlocEvent {
  final ChecklistLog checklistLog;

  ChecklistBlocEventCheckChecklistLog(this.checklistLog);

  @override
  List<Object> get props => [checklistLog];
}

class ChecklistBlocEventSkipChecklistLog extends ChecklistBlocEvent {
  final ChecklistLog checklistLog;

  ChecklistBlocEventSkipChecklistLog(this.checklistLog);

  @override
  List<Object> get props => [checklistLog];
}

class ChecklistBlocEventCreate extends ChecklistBlocEvent {
  final ChecklistSeedsCompanion checklistSeed;

  ChecklistBlocEventCreate(this.checklistSeed);

  @override
  List<Object> get props => [checklistSeed];
}

class ChecklistBlocEventAutoChecklist extends ChecklistBlocEvent {
  @override
  List<Object> get props => [];
}

class ChecklistBlocEventFilter extends ChecklistBlocEvent {
  final String searchTerms;

  ChecklistBlocEventFilter(this.searchTerms);

  @override
  List<Object> get props => [searchTerms];
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
  final List<Tuple3<ChecklistSeed, ChecklistAction, ChecklistLog>>? actions;
  final List<ChecklistCollection> collections;

  ChecklistBlocStateLoaded(this.plant, this.box, this.checklist, this.checklistSeeds, this.actions, this.collections);

  @override
  List<Object?> get props => [
        plant,
        box,
        checklist,
        checklistSeeds,
        actions,
        collections,
      ];
}

class ChecklistBloc extends LegacyBloc<ChecklistBlocEvent, ChecklistBlocState> {
  final MainNavigateToChecklist args;

  late StreamSubscription subChecklist;
  late StreamSubscription subChecklistSeeds;
  late StreamSubscription subLogs;
  late StreamSubscription subCollections;

  String? searchTerms;

  ChecklistBloc(this.args) : super(ChecklistBlocStateInit()) {
    add(ChecklistBlocEventInit());
  }

  @override
  Stream<ChecklistBlocState> mapEventToState(ChecklistBlocEvent event) async* {
    if (event is ChecklistBlocEventInit) {
      subChecklist = RelDB.get().checklistsDAO.watchChecklist(args.checklist.id).listen((event) {
        add(ChecklistBlocEventLoad());
      });
      subChecklistSeeds = RelDB.get().checklistsDAO.watchChecklistSeeds(this.args.checklist.id).listen((e) {
        add(ChecklistBlocEventLoad());
      });
      subLogs = RelDB.get().checklistsDAO.watchChecklistLogs(this.args.checklist.id).listen((e) {
        add(ChecklistBlocEventLoad());
      });
      subCollections = RelDB.get().checklistsDAO.watchCollections(this.args.checklist.id).listen((e) {
        add(ChecklistBlocEventLoad());
      });
    } else if (event is ChecklistBlocEventLoad) {
      Checklist checklist = await RelDB.get().checklistsDAO.getChecklist(this.args.checklist.id);
      late List<ChecklistSeed> checklistSeeds;
      if (searchTerms == null || searchTerms == '') {
        checklistSeeds = await RelDB.get().checklistsDAO.getChecklistSeeds(this.args.checklist.id);
      } else {
        checklistSeeds = await RelDB.get().checklistsDAO.searchSeeds(searchTerms!, this.args.checklist.id).get();
      }
      List<ChecklistLog> logs = await RelDB.get().checklistsDAO.getChecklistLogs(this.args.checklist.id);
      List<ChecklistCollection> collections = await RelDB.get().checklistsDAO.getChecklistCollections(this.args.checklist.id);
      List<Tuple3<ChecklistSeed, ChecklistAction, ChecklistLog>> actions = [];
      for (int i = 0; i < logs.length; ++i) {
        Map<String, dynamic> action = json.decode(logs[i].action);
        ChecklistSeed checklistSeed = await RelDB.get().checklistsDAO.getChecklistSeed(logs[i].checklistSeed);
        actions.add(Tuple3(checklistSeed, ChecklistAction.fromMap(action), logs[i]));
      }
      yield ChecklistBlocStateLoaded(this.args.plant, this.args.box, checklist, checklistSeeds, actions, collections);
    } else if (event is ChecklistBlocEventDeleteChecklistSeed) {
      await ChecklistHelper.deleteChecklistSeed(event.checklistSeed);
    } else if (event is ChecklistBlocEventSkipChecklistLog) {
      await ChecklistHelper.skipChecklistLog(event.checklistLog);
    } else if (event is ChecklistBlocEventCheckChecklistLog) {
      await ChecklistHelper.checkChecklistLog(event.checklistLog);
    } else if (event is ChecklistBlocEventCreate) {
      Checklist checklist = await RelDB.get().checklistsDAO.getChecklist(args.checklist.id);
      await RelDB.get().checklistsDAO.addChecklistSeed(event.checklistSeed.copyWith(
            checklistServerID: Value(checklist.serverID),
          ));
    } else if (event is ChecklistBlocEventAutoChecklist) {
      Checklist checklist = await RelDB.get().checklistsDAO.getChecklist(this.args.checklist.id);
      await ChecklistHelper.subscribeCollection(BackendAPI().checklistCollectionTheBasics, checklist);
      add(ChecklistBlocEventLoad());
    } else if (event is ChecklistBlocEventFilter) {
      this.searchTerms = event.searchTerms;
      add(ChecklistBlocEventLoad());
    }
  }

  @override
  Future<void> close() async {
    await subChecklist.cancel();
    await subLogs.cancel();
    await subChecklistSeeds.cancel();
    await subCollections.cancel();
    return super.close();
  }
}
