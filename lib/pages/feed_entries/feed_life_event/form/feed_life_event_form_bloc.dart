/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/helpers/plant_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';

abstract class FeedLifeEventFormBlocEvent extends Equatable {}

class FeedLifeEventFormBlocEventInit extends FeedLifeEventFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedLifeEventFormBlocEventSetDate extends FeedLifeEventFormBlocEvent {
  final DateTime date;

  FeedLifeEventFormBlocEventSetDate(this.date);

  @override
  List<Object> get props => [date];
}

class FeedLifeEventFormBlocState extends Equatable {
  final PlantPhases phase;

  FeedLifeEventFormBlocState(this.phase);

  @override
  List<Object> get props => [phase];
}

class FeedLifeEventFormBlocStateInit extends FeedLifeEventFormBlocState {
  FeedLifeEventFormBlocStateInit(PlantPhases phase) : super(phase);
}

class FeedLifeEventFormBlocStateLoaded extends FeedLifeEventFormBlocState {
  final DateTime date;

  FeedLifeEventFormBlocStateLoaded(PlantPhases phase, this.date) : super(phase);

  @override
  List<Object> get props => [...super.props, date];
}

class FeedLifeEventFormBlocStateDone extends FeedLifeEventFormBlocState {
  FeedLifeEventFormBlocStateDone(PlantPhases phase) : super(phase);
}

class FeedLifeEventFormBloc
    extends Bloc<FeedLifeEventFormBlocEvent, FeedLifeEventFormBlocState> {
  final MainNavigateToFeedLifeEventFormEvent _args;

  FeedLifeEventFormBloc(this._args) : super(FeedLifeEventFormBlocStateInit(_args.phase)) {
    add(FeedLifeEventFormBlocEventInit());
  }

  @override
  Stream<FeedLifeEventFormBlocState> mapEventToState(
      FeedLifeEventFormBlocEvent event) async* {
    if (event is FeedLifeEventFormBlocEventInit) {
      Plant plant = await RelDB.get().plantsDAO.getPlant(_args.plant.id);
      PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
      yield FeedLifeEventFormBlocStateLoaded(
          _args.phase, plantSettings.dateForPhase(_args.phase));
    } else if (event is FeedLifeEventFormBlocEventSetDate) {
      await PlantHelper.updatePlantPhase(_args.plant, _args.phase, event.date);
      yield FeedLifeEventFormBlocStateDone(_args.phase);
    }
  }
}
