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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/data/api/backend/users/users_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class CommentsFormBlocEvent extends Equatable {}

class CommentsFormBlocEventInit extends CommentsFormBlocEvent {
  @override
  List<Object> get props => [];
}

class CommentsFormBlocEventPostComment extends CommentsFormBlocEvent {
  final String text;
  final String type;

  CommentsFormBlocEventPostComment(this.text, this.type);

  @override
  List<Object> get props => [
        text,
        type,
      ];
}

class CommentsFormBlocEventLike extends CommentsFormBlocEvent {
  final Comment comment;

  CommentsFormBlocEventLike(this.comment);

  @override
  List<Object> get props => [comment];
}

abstract class CommentsFormBlocState extends Equatable {}

class CommentsFormBlocStateInit extends CommentsFormBlocState {
  @override
  List<Object> get props => [];
}

class CommentsFormBlocStateLoading extends CommentsFormBlocState {
  @override
  List<Object> get props => [];
}

class CommentsFormBlocStateLoaded extends CommentsFormBlocState {
  final bool autoFocus;
  final FeedEntryStateLoaded feedEntry;
  final List<Comment> comments;
  final int n;
  final User user;

  CommentsFormBlocStateLoaded(
      this.autoFocus, this.feedEntry, this.comments, this.n, this.user);

  @override
  List<Object> get props => [autoFocus, feedEntry, comments, n, user];
}

class CommentsFormBlocStateUpdateComment extends CommentsFormBlocState {
  final Comment comment;

  CommentsFormBlocStateUpdateComment(this.comment);

  @override
  List<Object> get props => [comment];
}

class CommentsFormBloc
    extends Bloc<CommentsFormBlocEvent, CommentsFormBlocState> {
  final MainNavigateToCommentFormEvent args;
  User user;
  String feedEntryID;

  CommentsFormBloc(this.args) : super(CommentsFormBlocStateInit()) {
    add(CommentsFormBlocEventInit());
  }

  @override
  Stream<CommentsFormBlocState> mapEventToState(
      CommentsFormBlocEvent event) async* {
    if (event is CommentsFormBlocEventInit) {
      this.user = await BackendAPI().usersAPI.me();
      if (args.feedEntry.remoteState) {
        feedEntryID = args.feedEntry.feedEntryID;
      } else {
        FeedEntry feedEntry =
            await RelDB.get().feedsDAO.getFeedEntry(args.feedEntry.feedEntryID);
        feedEntryID = feedEntry.serverID;
      }
      yield* fetchComments(feedEntryID);
    } else if (event is CommentsFormBlocEventLike) {
      await BackendAPI().feedsAPI.likeComment(event.comment);
      FeedEntryHelper.eventBus.fire(FeedEntryUpdateComment(event.comment));
      yield CommentsFormBlocStateUpdateComment(
          event.comment.copyWith(liked: !event.comment.liked));
    } else if (event is CommentsFormBlocEventPostComment) {
      yield CommentsFormBlocStateLoading();
      Comment comment = Comment(
          feedEntryID: feedEntryID,
          userID: this.user.id,
          from: this.user.nickname,
          pic: this.user.pic,
          text: event.text,
          type: event.type,
          createdAt: DateTime.now(),
          liked: false,
          params: "{}");
      comment = await BackendAPI().feedsAPI.postComment(comment);
      FeedEntryHelper.eventBus.fire(FeedEntryAddComment(comment));
      yield CommentsFormBlocStateLoaded(
          this.args.autoFocus,
          this.args.feedEntry,
          [
            comment,
          ],
          10,
          this.user);
    }
  }

  Stream<CommentsFormBlocState> fetchComments(String feedEntryID) async* {
    List<Comment> comments = await BackendAPI()
        .feedsAPI
        .fetchCommentsForFeedEntry(feedEntryID, n: 20);
    int n =
        await BackendAPI().feedsAPI.fetchCommentCountForFeedEntry(feedEntryID);

    yield CommentsFormBlocStateLoaded(
        this.args.autoFocus, this.args.feedEntry, comments, n, this.user);
  }
}
