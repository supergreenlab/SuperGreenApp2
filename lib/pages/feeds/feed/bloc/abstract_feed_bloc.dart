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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc_entry_state.dart';

abstract class FeedBlocEvent extends Equatable {}

class FeedBlocEventLoadEntries extends FeedBlocEvent {
  final int n;

  FeedBlocEventLoadEntries(this.n);

  @override
  List<Object> get props => [n];
}

class FeedBlocEventLoadEntry extends FeedBlocEvent {
  final String entryID;

  FeedBlocEventLoadEntry(this.entryID);

  @override
  List<Object> get props => [entryID];
}

abstract class FeedBlocState extends Equatable {}

class FeedBlocStateInit extends FeedBlocState {
  FeedBlocStateInit() : super();

  @override
  List<Object> get props => [];
}

class FeedBlocStateLoaded extends FeedBlocState {
  final List<FeedBlocEntryState> entries;

  FeedBlocStateLoaded(this.entries);

  @override
  List<Object> get props => [entries];
}

abstract class FeedBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  List<FeedBlocEntryState> _entryStates = [];

  FeedBloc() {
    add(FeedBlocEventLoadEntries(10));
  }

  @override
  FeedBlocState get initialState => FeedBlocStateInit();

  @override
  Stream<FeedBlocState> mapEventToState(FeedBlocEvent event) async* {
    if (event is FeedBlocEventLoadEntries) {
      yield* loadEntries(event.n);
    }
  }

  Stream<FeedBlocState> loadEntries(int n);
}
