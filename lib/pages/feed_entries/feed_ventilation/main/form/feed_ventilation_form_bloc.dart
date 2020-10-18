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

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedVentilationFormBlocEvent extends Equatable {}

class FeedVentilationFormBlocEventInit extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventInit();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocEventCreate extends FeedVentilationFormBlocEvent {
  final int blowerDay;
  final int blowerNight;

  FeedVentilationFormBlocEventCreate(this.blowerDay, this.blowerNight);

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocEventCancelEvent
    extends FeedVentilationFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocState extends Equatable {
  final Box box;

  FeedVentilationFormBlocState(this.box);

  @override
  List<Object> get props => [box];
}

class FeedVentilationFormBlocStateLoading extends FeedVentilationFormBlocState {
  FeedVentilationFormBlocStateLoading(Box box) : super(box);
}

class FeedVentilationFormBlocStateNoDevice
    extends FeedVentilationFormBlocStateLoading {
  FeedVentilationFormBlocStateNoDevice(Box box) : super(box);
}

class FeedVentilationFormBloc
    extends Bloc<FeedVentilationFormBlocEvent, FeedVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent args;

  Device device;

  FeedVentilationFormBloc(this.args) : super(FeedVentilationFormBlocState()) {
    add(FeedVentilationFormBlocEventInit());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(
      FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventInit) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        yield FeedVentilationFormBlocStateNoDevice(box);
        return;
      }
      device = await db.devicesDAO.getDevice(box.device);
      yield FeedVentilationFormBlocStateLoading(box);
    }
  }
}
