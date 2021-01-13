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
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class CommentsCardBlocEvent extends Equatable {}

class CommentsCardBlocEventInit extends CommentsCardBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class CommentsCardBlocState extends Equatable {}

class CommentsCardBlocStateInit extends CommentsCardBlocState {
  @override
  List<Object> get props => [];
}

class CommentsCardBlocStateLoaded extends CommentsCardBlocState {
  final List<Comment> comments;

  CommentsCardBlocStateLoaded(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentsCardBloc
    extends Bloc<CommentsCardBlocEvent, CommentsCardBlocState> {
  final FeedEntryStateLoaded _feedEntry;

  CommentsCardBloc(this._feedEntry) : super(CommentsCardBlocStateInit()) {
    add(CommentsCardBlocEventInit());
  }

  @override
  Stream<CommentsCardBlocState> mapEventToState(
      CommentsCardBlocEvent event) async* {
    if (event is CommentsCardBlocEventInit) {
      yield CommentsCardBlocStateInit();
      yield CommentsCardBlocStateLoaded([]);
    }
  }
}
