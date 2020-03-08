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
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

abstract class BoxFeedBlocEvent extends Equatable {}

class BoxFeedBlocEventLoadBox extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocEventReloadChart extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocEventBoxUpdated extends BoxFeedBlocEvent {
  final Box box;

  BoxFeedBlocEventBoxUpdated(this.box);

  @override
  List<Object> get props => [box];
}

abstract class BoxFeedBlocState extends Equatable {}

class BoxFeedBlocStateInit extends BoxFeedBlocState {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateNoBox extends BoxFeedBlocState {
  BoxFeedBlocStateNoBox() : super();

  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateBoxLoaded extends BoxFeedBlocState {
  final Box box;

  BoxFeedBlocStateBoxLoaded(this.box);

  @override
  List<Object> get props => [box];
}

class BoxFeedBloc extends Bloc<BoxFeedBlocEvent, BoxFeedBlocState> {
  final HomeNavigateToBoxFeedEvent _args;

  BoxFeedBloc(this._args) {
    this.add(BoxFeedBlocEventLoadBox());
  }

  @override
  BoxFeedBlocState get initialState => BoxFeedBlocStateInit();

  @override
  Stream<BoxFeedBlocState> mapEventToState(BoxFeedBlocEvent event) async* {
    if (event is BoxFeedBlocEventLoadBox) {
      AppDB _db = AppDB();
      Box box = _args.box;
      if (box == null) {
        AppData appData = _db.getAppData();
        if (appData.lastBoxID == null) {
          yield BoxFeedBlocStateNoBox();
          return;
        }
        box = await RelDB.get().boxesDAO.getBox(appData.lastBoxID);
      } else {
        _db.setLastBox(box.id);
      }

      RelDB.get().boxesDAO.watchBox(box.id).listen(_onBoxUpdated);
      yield BoxFeedBlocStateBoxLoaded(box);
    } else if (event is BoxFeedBlocEventBoxUpdated) {
      yield BoxFeedBlocStateBoxLoaded(event.box);
    }
  }

  void _onBoxUpdated(Box box) {
    add(BoxFeedBlocEventBoxUpdated(box));
  }
}