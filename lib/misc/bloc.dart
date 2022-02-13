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

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/logger/logger.dart';

abstract class LegacyBloc<Event, State> extends Bloc<Event, State> {
  LegacyBloc(State initialState) : super(initialState) {
    on<Event>((event, emit) async {
      await emit.onEach(mapEventToState(event), onData: (State state) {
        emit(state);
      }, onError: (e, trace) {
        Logger.logError(e, trace);
      });
    }, transformer: sequential());
  }

  Stream<State> mapEventToState(Event event);
}
