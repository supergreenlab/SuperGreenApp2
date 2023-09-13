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
import 'package:super_green_app/data/api/backend/checklist/checklist_helper.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class ChecklistActionPopupBlocEvent extends Equatable {}

class ChecklistActionPopupBlocEventInit extends ChecklistActionPopupBlocEvent {
  @override
  List<Object?> get props => [];
}

class ChecklistActionPopupBlocEventCheckChecklistLog extends ChecklistActionPopupBlocEvent {
  final ChecklistLog checklistLog;

  ChecklistActionPopupBlocEventCheckChecklistLog(this.checklistLog);

  @override
  List<Object> get props => [];
}

class ChecklistActionPopupBlocEventSkipChecklistLog extends ChecklistActionPopupBlocEvent {
  final ChecklistLog checklistLog;

  ChecklistActionPopupBlocEventSkipChecklistLog(this.checklistLog);

  @override
  List<Object> get props => [];
}

abstract class ChecklistActionPopupBlocState extends Equatable {}

class ChecklistActionPopupBlocStateInit extends ChecklistActionPopupBlocState {
  @override
  List<Object?> get props => [];
}

class ChecklistActionPopupBlocStateLoaded extends ChecklistActionPopupBlocState {
  final Plant plant;
  final Box box;
  final ChecklistSeed checklistSeed;
  final ChecklistAction checklistAction;
  final List<ChecklistLog> checklistLogs;

  ChecklistActionPopupBlocStateLoaded(
      this.plant, this.box, this.checklistSeed, this.checklistAction, this.checklistLogs);

  @override
  List<Object?> get props => [plant, box, checklistSeed, checklistAction, checklistLogs];
}

class ChecklistActionPopupBloc extends LegacyBloc<ChecklistActionPopupBlocEvent, ChecklistActionPopupBlocState> {
  final Plant plant;
  final Box box;
  final ChecklistSeed checklistSeed;
  final ChecklistAction checklistAction;

  ChecklistActionPopupBloc(this.plant, this.box, this.checklistSeed, this.checklistAction)
      : super(ChecklistActionPopupBlocStateInit()) {
    add(ChecklistActionPopupBlocEventInit());
  }

  @override
  Stream<ChecklistActionPopupBlocState> mapEventToState(ChecklistActionPopupBlocEvent event) async* {
    if (event is ChecklistActionPopupBlocEventInit) {
      List<ChecklistLog> checklistLogs =
          await RelDB.get().checklistsDAO.getActiveChecklistLogsForChecklistSeed(this.checklistSeed);
      yield ChecklistActionPopupBlocStateLoaded(plant, box, checklistSeed, checklistAction, checklistLogs);
    } else if (event is ChecklistActionPopupBlocEventSkipChecklistLog) {
      await ChecklistHelper.skipChecklistLog(event.checklistLog);
      List<ChecklistLog> checklistLogs =
          await RelDB.get().checklistsDAO.getActiveChecklistLogsForChecklistSeed(this.checklistSeed);
      if (checklistLogs.length != 0) {
        yield ChecklistActionPopupBlocStateLoaded(plant, box, checklistSeed, checklistAction, checklistLogs);
      }
    } else if (event is ChecklistActionPopupBlocEventCheckChecklistLog) {
      await ChecklistHelper.checkChecklistLog(event.checklistLog);
      List<ChecklistLog> checklistLogs =
          await RelDB.get().checklistsDAO.getActiveChecklistLogsForChecklistSeed(this.checklistSeed);
      if (checklistLogs.length != 0) {
        yield ChecklistActionPopupBlocStateLoaded(plant, box, checklistSeed, checklistAction, checklistLogs);
      }
    }
  }
}
