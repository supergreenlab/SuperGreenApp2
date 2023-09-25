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

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class CreateChecklistSeedBlocEvent extends Equatable {}

class CreateChecklistBlocEventInit extends CreateChecklistSeedBlocEvent {
  @override
  List<Object> get props => [];
}

class CreateChecklistSeedBlocEventSave extends CreateChecklistSeedBlocEvent {

  final ChecklistSeedsCompanion checklistSeed;

  CreateChecklistSeedBlocEventSave(this.checklistSeed);

  @override
  List<Object> get props => [checklistSeed];
}

abstract class CreateChecklistSeedBlocState extends Equatable {}

class CreateChecklistSeedBlocStateInit extends CreateChecklistSeedBlocState {
  @override
  List<Object> get props => [];
}

class CreateChecklistSeedBlocStateLoaded extends CreateChecklistSeedBlocState {
  final Checklist checklist;
  final ChecklistSeedsCompanion checklistSeed;

  CreateChecklistSeedBlocStateLoaded(this.checklist, this.checklistSeed);

  @override
  List<Object> get props => [checklist];
}

class CreateChecklistSeedBlocStateCreated extends CreateChecklistSeedBlocState {
  @override
  List<Object> get props => [];
}

class CreateChecklistSeedBloc extends LegacyBloc<CreateChecklistSeedBlocEvent, CreateChecklistSeedBlocState> {

  final MainNavigateToCreateChecklist args;
  late final ChecklistSeedsCompanion checklistSeed;

  CreateChecklistSeedBloc(this.args) : super(CreateChecklistSeedBlocStateInit()) {
    add(CreateChecklistBlocEventInit());
  }

  @override
  Stream<CreateChecklistSeedBlocState> mapEventToState(CreateChecklistSeedBlocEvent event) async* {
    if (event is CreateChecklistBlocEventInit) {
      if (args.checklistSeed == null) {
        checklistSeed = ChecklistSeedsCompanion.insert(
          checklist: this.args.checklist.id,
          public: Value(false),
          repeat: Value(false),
          mine: Value(true),
          title: Value(''),
          description: Value(''),
          category: Value(''),
          conditions: Value('[]'),
          exitConditions: Value('[]'),
          actions: Value('[]'),
          synced: Value(false),
        );
      } else {
        checklistSeed = args.checklistSeed!.toCompanion(false);
      }
      yield CreateChecklistSeedBlocStateLoaded(this.args.checklist, checklistSeed);
    } else if (event is CreateChecklistSeedBlocEventSave) {
      if (event.checklistSeed.id.present) {
        await RelDB.get().checklistsDAO.updateChecklistSeed(event.checklistSeed.copyWith(synced: Value(false)));
      } else {
        Checklist checklist = await RelDB.get().checklistsDAO.getChecklist(args.checklist.id);
        await RelDB.get().checklistsDAO.addChecklistSeed(event.checklistSeed.copyWith(checklistServerID: Value(checklist.serverID),));
      }
      yield CreateChecklistSeedBlocStateCreated();
    }
  }
}
