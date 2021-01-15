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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class CommentsCardBlocEvent extends Equatable {}

class CommentsCardBlocEventInit extends CommentsCardBlocEvent {
  @override
  List<Object> get props => [];
}

class CommentsCardBlocEventLoad extends CommentsCardBlocEvent {
  final String feedEntryID;

  CommentsCardBlocEventLoad(this.feedEntryID);

  @override
  List<Object> get props => [
        feedEntryID,
      ];
}

abstract class CommentsCardBlocState extends Equatable {}

class CommentsCardBlocStateInit extends CommentsCardBlocState {
  @override
  List<Object> get props => [];
}

class CommentsCardBlocStateNotSynced extends CommentsCardBlocState {
  @override
  List<Object> get props => [];
}

class CommentsCardBlocStateLoaded extends CommentsCardBlocState {
  final FeedEntryStateLoaded feedEntry;
  final List<Comment> comments;
  final int n;

  CommentsCardBlocStateLoaded(this.feedEntry, this.comments, this.n);

  @override
  List<Object> get props => [feedEntry, comments, n];
}

class CommentsCardBloc
    extends Bloc<CommentsCardBlocEvent, CommentsCardBlocState> {
  final FeedEntryStateLoaded _feedEntry;

  StreamSubscription<FeedEntry> _sub;

  CommentsCardBloc(this._feedEntry) : super(CommentsCardBlocStateInit()) {
    add(CommentsCardBlocEventInit());
  }

  @override
  Stream<CommentsCardBlocState> mapEventToState(
      CommentsCardBlocEvent event) async* {
    if (event is CommentsCardBlocEventInit) {
      yield CommentsCardBlocStateInit();
      String feedEntryID;
      if (_feedEntry.remoteState) {
        feedEntryID = _feedEntry.feedEntryID;
      } else {
        FeedEntry feedEntry =
            await RelDB.get().feedsDAO.getFeedEntry(_feedEntry.feedEntryID);
        if (feedEntry.serverID == null) {
          _sub = RelDB.get()
              .feedsDAO
              .watchFeedEntry(_feedEntry.feedEntryID)
              .listen(listenFeedEntryChange);
          yield CommentsCardBlocStateNotSynced();
          return;
        }
        feedEntryID = feedEntry.serverID;
      }
      yield* fetchComments(feedEntryID);
    } else if (event is CommentsCardBlocEventLoad) {
      yield* fetchComments(event.feedEntryID);
    }
  }

  Stream<CommentsCardBlocState> fetchComments(String feedEntryID) async* {
    List<Comment> comments = await BackendAPI()
        .feedsAPI
        .fetchCommentsForFeedEntry(feedEntryID, n: 2);
    int n =
        await BackendAPI().feedsAPI.fetchCommentCountForFeedEntry(feedEntryID);

    yield CommentsCardBlocStateLoaded(this._feedEntry, comments, n);
  }

  void listenFeedEntryChange(FeedEntry feedEntry) async {
    if (feedEntry.serverID == null) {
      return;
    }
    await _sub.cancel();
    _sub = null;
    add(CommentsCardBlocEventLoad(feedEntry.serverID));
  }

  @override
  Future<void> close() async {
    if (_sub != null) {
      _sub.cancel();
    }
    return super.close();
  }
}
