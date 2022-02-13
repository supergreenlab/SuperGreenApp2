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
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class BookmarksBlocEvent extends Equatable {}

class BookmarksBlocEventInit extends BookmarksBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class BookmarksBlocState extends Equatable {}

class BookmarksBlocStateInit extends BookmarksBlocState {
  @override
  List<Object> get props => [];
}

class BookmarksBlocStateLoaded extends BookmarksBlocState {
  @override
  List<Object> get props => [];
}

class BookmarksBloc extends LegacyBloc<BookmarksBlocEvent, BookmarksBlocState> {
  final MainNavigateToBookmarks args;

  BookmarksBloc(this.args) : super(BookmarksBlocStateInit()) {
    add(BookmarksBlocEventInit());
  }

  @override
  Stream<BookmarksBlocState> mapEventToState(BookmarksBlocEvent event) async* {
    if (event is BookmarksBlocEventInit) {
      yield BookmarksBlocStateLoaded();
    }
  }
}
