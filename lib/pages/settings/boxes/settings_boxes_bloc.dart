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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsBoxesBlocEvent extends Equatable {}

class SettingsBoxesBlocEventInit extends SettingsBoxesBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsBoxesblocEventBoxListChanged extends SettingsBoxesBlocEvent {
  final List<Box> boxes;

  SettingsBoxesblocEventBoxListChanged(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class SettingsBoxesBlocEventDeleteBox extends SettingsBoxesBlocEvent {
  final Box box;

  SettingsBoxesBlocEventDeleteBox(this.box);

  @override
  List<Object> get props => [box];
}

abstract class SettingsBoxesBlocState extends Equatable {}

class SettingsBoxesBlocStateInit extends SettingsBoxesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxesBlocStateLoading extends SettingsBoxesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxesBlocStateNotEmptyBox extends SettingsBoxesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxesBlocStateLoaded extends SettingsBoxesBlocState {
  final List<Box> boxes;

  SettingsBoxesBlocStateLoaded(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class SettingsBoxesBloc extends LegacyBloc<SettingsBoxesBlocEvent, SettingsBoxesBlocState> {
  late List<Box> _boxes;
  StreamSubscription<List<Box>>? _boxesStream;

  //ignore: unused_field
  final MainNavigateToSettingsBoxes args;

  SettingsBoxesBloc(this.args) : super(SettingsBoxesBlocStateInit()) {
    add(SettingsBoxesBlocEventInit());
  }

  @override
  Stream<SettingsBoxesBlocState> mapEventToState(event) async* {
    if (event is SettingsBoxesBlocEventInit) {
      yield SettingsBoxesBlocStateLoading();
      _boxesStream = RelDB.get().plantsDAO.watchBoxes().listen(_onBoxListChange);
    } else if (event is SettingsBoxesblocEventBoxListChanged) {
      yield SettingsBoxesBlocStateLoaded(event.boxes);
    } else if (event is SettingsBoxesBlocEventDeleteBox) {
      int nPlants = await RelDB.get().plantsDAO.nPlantsInBox(event.box.id).getSingle();
      if (nPlants != 0) {
        yield SettingsBoxesBlocStateNotEmptyBox();
        await Future.delayed(Duration(seconds: 2));
        yield SettingsBoxesBlocStateLoaded(_boxes);
        return;
      }
      await PlantHelper.deleteBox(event.box);
    }
  }

  void _onBoxListChange(List<Box> boxes) {
    _boxes = boxes;
    add(SettingsBoxesblocEventBoxListChanged(_boxes));
  }

  @override
  Future<void> close() async {
    await _boxesStream?.cancel();
    return super.close();
  }
}
