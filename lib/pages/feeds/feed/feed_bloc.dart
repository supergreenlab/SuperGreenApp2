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
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedBlocEvent extends Equatable {}

class FeedBlocEventLoadFeed extends FeedBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedBlocEventDeleteFeedEntry extends FeedBlocEvent {
  final FeedEntry feedEntry;

  FeedBlocEventDeleteFeedEntry(this.feedEntry);

  @override
  List<Object> get props => [feedEntry];
}

class FeedBlocEventFeedEntriesListUpdated extends FeedBlocEvent {
  final List<FeedEntry> _feedEntries;

  FeedBlocEventFeedEntriesListUpdated(this._feedEntries);

  @override
  List<Object> get props => [_feedEntries];
}

class FeedBlocEventMarkAsRead extends FeedBlocEvent {
  final FeedEntry feedEntry;

  FeedBlocEventMarkAsRead(this.feedEntry);

  @override
  List<Object> get props => [feedEntry];
}

abstract class FeedBlocState extends Equatable {}

class FeedBlocStateInit extends FeedBlocState {
  FeedBlocStateInit() : super();

  @override
  List<Object> get props => [];
}

class FeedBlocStateLoaded extends FeedBlocState {
  final Feed feed;
  final List<FeedEntry> entries;

  FeedBlocStateLoaded(this.feed, this.entries);

  @override
  List<Object> get props => [feed, entries];
}

class FeedBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  final int _feedID;
  Feed _feed;
  StreamSubscription<List<FeedEntry>> _stream;

  FeedBloc(this._feedID) {
    add(FeedBlocEventLoadFeed());
  }

  @override
  FeedBlocState get initialState => FeedBlocStateInit();

  @override
  Stream<FeedBlocState> mapEventToState(FeedBlocEvent event) async* {
    if (event is FeedBlocEventLoadFeed) {
      final fdb = RelDB.get().feedsDAO;
      _feed = await fdb.getFeed(_feedID);
      final entries = fdb.watchEntries(_feedID);
      _stream = entries.listen(_onFeedEntriesChange);
    } else if (event is FeedBlocEventMarkAsRead) {
      final fdb = RelDB.get().feedsDAO;
      await fdb.updateFeedEntry(
          event.feedEntry.createCompanion(true).copyWith(isNew: Value(false)));
    } else if (event is FeedBlocEventFeedEntriesListUpdated) {
      yield FeedBlocStateLoaded(_feed, event._feedEntries);
    } else if (event is FeedBlocEventDeleteFeedEntry) {
      await RelDB.get().feedsDAO.deleteFeedEntry(event.feedEntry);
      await RelDB.get()
          .feedsDAO
          .deleteFeedMediasForFeedEntry(event.feedEntry.id);
    }
  }

  void _onFeedEntriesChange(List<FeedEntry> entries) {
    add(FeedBlocEventFeedEntriesListUpdated(entries));
  }

  @override
  Future<void> close() async {
    if (_stream != null) {
      await _stream.cancel();
    }
    return super.close();
  }
}
