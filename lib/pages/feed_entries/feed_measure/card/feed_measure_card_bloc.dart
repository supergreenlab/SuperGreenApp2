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

abstract class FeedMeasureCardBlocEvent extends Equatable {}

class FeedMeasureCardBlocEventInit extends FeedMeasureCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedMeasureCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final FeedMedia previous;
  final FeedMedia current;

  FeedMeasureCardBlocState(
      this.feed, this.feedEntry, this.params, this.previous, this.current);

  @override
  List<Object> get props =>
      [this.feed, this.feedEntry, this.params, this.previous, this.current];
}

class FeedMeasureCardBloc
    extends Bloc<FeedMeasureCardBlocEvent, FeedMeasureCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  FeedMedia _previous;
  FeedMedia _current;

  @override
  FeedMeasureCardBlocState get initialState =>
      FeedMeasureCardBlocState(_feed, _feedEntry, {}, _previous, _current);

  FeedMeasureCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    add(FeedMeasureCardBlocEventInit());
  }

  @override
  Stream<FeedMeasureCardBlocState> mapEventToState(
      FeedMeasureCardBlocEvent event) async* {
    if (event is FeedMeasureCardBlocEventInit) {
      RelDB db = RelDB.get();
      if (_params['previous'] is int) {
        _previous = await db.feedsDAO.getFeedMedia(_params['previous']);
      } else if (_params['previous'] is String) {
        _previous = await db.feedsDAO.getFeedMediaForServerID(_params['previous']);
      }
      _current = (await db.feedsDAO.getFeedMedias(_feedEntry.id))[0];
      yield FeedMeasureCardBlocState(
          _feed, _feedEntry, _params, _previous, _current);
    }
  }
}
