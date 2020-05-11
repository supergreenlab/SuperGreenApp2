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
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedMediaCardBlocEvent extends Equatable {}

class FeedMediaCardBlocEventInit extends FeedMediaCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedMediaCardBlocEventMediaListUpdated extends FeedMediaCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedMediaCardBlocEventEdit extends FeedMediaCardBlocEvent {
  final String message;

  FeedMediaCardBlocEventEdit(this.message);

  @override
  List<Object> get props => [];
}

class FeedMediaCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final List<FeedMedia> medias;

  FeedMediaCardBlocState(this.feed, this.feedEntry, this.params, this.medias);

  @override
  List<Object> get props =>
      [this.feed, this.feedEntry, this.params, this.medias];
}

class FeedMediaCardBloc
    extends Bloc<FeedMediaCardBlocEvent, FeedMediaCardBlocState> {
  final Feed _feed;
  FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  final List<FeedMedia> _medias = [];

  StreamSubscription<List<FeedMedia>> _stream;

  @override
  FeedMediaCardBlocState get initialState =>
      FeedMediaCardBlocState(_feed, _feedEntry, {}, []);

  FeedMediaCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    add(FeedMediaCardBlocEventInit());
  }

  @override
  Stream<FeedMediaCardBlocState> mapEventToState(
      FeedMediaCardBlocEvent event) async* {
    if (event is FeedMediaCardBlocEventInit) {
      _stream = RelDB.get()
          .feedsDAO
          .watchFeedMedias(_feedEntry.id)
          .listen(_onMediasUpdated);
    } else if (event is FeedMediaCardBlocEventMediaListUpdated) {
      yield FeedMediaCardBlocState(_feed, _feedEntry, _params, _medias);
    } else if (event is FeedMediaCardBlocEventEdit) {
      RelDB db = RelDB.get();
      Map<String, dynamic> params = JsonDecoder().convert(_feedEntry.params);
      params['message'] = event.message;
      db.feedsDAO.updateFeedEntry(FeedEntriesCompanion(
          id: Value(_feedEntry.id),
          params: Value(JsonEncoder().convert(params)),
          synced: Value(false)));
      _feedEntry = await db.feedsDAO.getFeedEntry(_feedEntry.id);
      yield FeedMediaCardBlocState(_feed, _feedEntry, _params, _medias);
    }
  }

  void _onMediasUpdated(List<FeedMedia> medias) {
    _medias.replaceRange(0, _medias.length, medias);
    add(FeedMediaCardBlocEventMediaListUpdated());
  }

  @override
  Future<void> close() async {
    if (_stream != null) {
      await _stream.cancel();
    }
    return super.close();
  }
}
