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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
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
  final CommentType type;
  final Comment replyTo;
  final List<Product> recommend;

  CommentsFormBlocEventPostComment(
      this.text, this.type, this.replyTo, this.recommend);

  @override
  List<Object> get props => [
        text,
        type,
        replyTo,
        recommend,
      ];
}

class CommentsFormBlocEventLike extends CommentsFormBlocEvent {
  final Comment comment;

  CommentsFormBlocEventLike(this.comment);

  @override
  List<Object> get props => [comment];
}

class CommentsFormBlocEventLoadComments extends CommentsFormBlocEvent {
  final int offset;

  CommentsFormBlocEventLoadComments(this.offset);

  @override
  List<Object> get props => [offset];
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
  final bool eof;

  CommentsFormBlocStateLoaded(this.autoFocus, this.feedEntry, this.comments,
      this.n, this.user, this.eof);

  @override
  List<Object> get props => [autoFocus, feedEntry, comments, n, user];
}

class CommentsFormBlocStateUpdateComment extends CommentsFormBlocState {
  final String oldID;
  final Comment comment;

  String get commentID => oldID ?? comment.id;

  CommentsFormBlocStateUpdateComment(this.comment, {this.oldID});

  @override
  List<Object> get props => [comment, oldID];
}

class CommentsFormBlocStateAddComment extends CommentsFormBlocState {
  final Comment comment;

  CommentsFormBlocStateAddComment(this.comment);

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
      yield* fetchComments();
    } else if (event is CommentsFormBlocEventLike) {
      await BackendAPI().feedsAPI.likeComment(event.comment);
      yield CommentsFormBlocStateUpdateComment(
          event.comment.copyWith(liked: !event.comment.liked));
    } else if (event is CommentsFormBlocEventPostComment) {
      String tempID = Uuid().v4();
      Comment comment = Comment(
          id: tempID,
          feedEntryID: feedEntryID,
          userID: this.user.id,
          from: this.user.nickname,
          pic: this.user.pic,
          replyTo: event.replyTo?.id,
          text: event.text,
          type: event.type,
          createdAt: DateTime.now(),
          liked: false,
          params: JsonEncoder()
              .convert(CommentParam(recommend: event.recommend).toMap()),
          isNew: true);
      yield CommentsFormBlocStateAddComment(comment);
      comment = await BackendAPI().feedsAPI.postComment(comment);
      yield CommentsFormBlocStateUpdateComment(comment, oldID: tempID);
      yield* fetchComments();
    } else if (event is CommentsFormBlocEventLoadComments) {
      yield* fetchComments(offset: event.offset);
    }
  }

  Stream<CommentsFormBlocState> fetchComments({offset = 0, limit = 20}) async* {
    List<Comment> comments = await BackendAPI()
        .feedsAPI
        .fetchCommentsForFeedEntry(feedEntryID, limit: limit, offset: offset);
    int n =
        await BackendAPI().feedsAPI.fetchCommentCountForFeedEntry(feedEntryID);

    yield CommentsFormBlocStateLoaded(
        this.args.autoFocus,
        this.args.feedEntry,
        comments,
        n,
        this.user,
        comments.where((c) => c.replyTo == null).length != limit);
  }
}
