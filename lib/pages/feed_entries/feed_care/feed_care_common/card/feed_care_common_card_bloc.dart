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

abstract class FeedCareCommonCardBlocEvent extends Equatable {}

class FeedCareCommonCardBlocEventInit extends FeedCareCommonCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedMediaCardBlocEventMediaListUpdated extends FeedCareCommonCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedCareCommonCardBlocEventEdit extends FeedCareCommonCardBlocEvent {
  final String message;

  FeedCareCommonCardBlocEventEdit(this.message);

  @override
  List<Object> get props => [];
}

class FeedCareCommonCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final List<FeedMedia> beforeMedias;
  final List<FeedMedia> afterMedias;

  FeedCareCommonCardBlocState(this.feed, this.feedEntry, this.params,
      this.beforeMedias, this.afterMedias);

  @override
  List<Object> get props => [
        feed,
        feedEntry,
        params,
        beforeMedias,
        afterMedias,
      ];
}

class FeedCareCommonCardBloc
    extends Bloc<FeedCareCommonCardBlocEvent, FeedCareCommonCardBlocState> {
  final Feed _feed;
  FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  final List<FeedMedia> _beforeMedias = [];
  final List<FeedMedia> _afterMedias = [];

  StreamSubscription<List<FeedMedia>> _stream;

  @override
  FeedCareCommonCardBlocState get initialState =>
      FeedCareCommonCardBlocState(_feed, _feedEntry, {}, [], []);

  FeedCareCommonCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    add(FeedCareCommonCardBlocEventInit());
  }

  @override
  Stream<FeedCareCommonCardBlocState> mapEventToState(
      FeedCareCommonCardBlocEvent event) async* {
    if (event is FeedCareCommonCardBlocEventInit) {
      RelDB db = RelDB.get();
      _stream = db.feedsDAO.watchFeedMedias(_feedEntry.id).listen(_onMediasUpdated);
    } else if (event is FeedMediaCardBlocEventMediaListUpdated) {
      yield FeedCareCommonCardBlocState(
          _feed, _feedEntry, _params, _beforeMedias, _afterMedias);
    } else if (event is FeedCareCommonCardBlocEventEdit) {
      RelDB db = RelDB.get();
      Map<String, dynamic> params = JsonDecoder().convert(_feedEntry.params);
      params['message'] = event.message;
      db.feedsDAO.updateFeedEntry(_feedEntry.createCompanion(true).copyWith(
          params: Value(JsonEncoder().convert(params)), synced: Value(false)));
      _feedEntry = await db.feedsDAO.getFeedEntry(_feedEntry.id);
      yield FeedCareCommonCardBlocState(
          _feed, _feedEntry, _params, _beforeMedias, _afterMedias);
    }
  }

  void _onMediasUpdated(List<FeedMedia> medias) {
    _beforeMedias.addAll(medias.where((m) {
      final Map<String, dynamic> params = JsonDecoder().convert(m.params);
      return params['before'];
    }));
    _afterMedias.addAll(medias.where((m) {
      final Map<String, dynamic> params = JsonDecoder().convert(m.params);
      return !params['before'];
    }));
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
