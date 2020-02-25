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
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedScheduleCardBlocEvent extends Equatable {}

class FeedScheduleCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;

  FeedScheduleCardBlocState(this.feed, this.feedEntry, this.params);

  @override
  List<Object> get props => [feed, feedEntry, params];
}

class FeedScheduleCardBloc
    extends Bloc<FeedScheduleCardBlocEvent, FeedScheduleCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  @override
  FeedScheduleCardBlocState get initialState => FeedScheduleCardBlocState(_feed, _feedEntry, _params);

  FeedScheduleCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
  }

  @override
  Stream<FeedScheduleCardBlocState> mapEventToState(
      FeedScheduleCardBlocEvent event) async* {}
}
