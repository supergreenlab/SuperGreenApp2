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

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class HomeBlocEvent extends Equatable {}

class HomeBlocEventLoad extends HomeBlocEvent {
  @override
  List<Object> get props => [];
}

class HomeBlocEventLoaded extends HomeBlocEvent {
  final List<GetPendingFeedsResult> hasPending;

  HomeBlocEventLoaded(this.hasPending);

  @override
  List<Object> get props => [hasPending];
}

abstract class HomeBlocState extends Equatable {}

class HomeBlocStateInit extends HomeBlocState {
  @override
  List<Object> get props => [];
}

class HomeBlocStateLoaded extends HomeBlocState {
  final List<GetPendingFeedsResult> hasPending;

  HomeBlocStateLoaded(this.hasPending);

  @override
  List<Object> get props => [hasPending];
}

class HomeBloc extends LegacyBloc<HomeBlocEvent, HomeBlocState> {
  StreamSubscription<List<GetPendingFeedsResult>>? _pendingStream;

  HomeBloc() : super(HomeBlocStateInit()) {
    add(HomeBlocEventLoad());
  }

  @override
  Stream<HomeBlocState> mapEventToState(HomeBlocEvent event) async* {
    if (event is HomeBlocEventLoad) {
      final fdb = RelDB.get().feedsDAO;
      _pendingStream = fdb.getPendingFeeds().watch().listen(_hasPendingChange);
    } else if (event is HomeBlocEventLoaded) {
      yield HomeBlocStateLoaded(event.hasPending);
    }
  }

  void _hasPendingChange(List<GetPendingFeedsResult> hasPending) {
    add(HomeBlocEventLoaded(hasPending));
  }

  @override
  Future<void> close() async {
    await _pendingStream?.cancel();
    return super.close();
  }
}
