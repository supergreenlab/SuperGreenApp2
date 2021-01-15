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
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

abstract class SocialBarBlocEvent extends Equatable {}

class SocialBarBlocEventInit extends SocialBarBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SocialBarBlocState extends Equatable {}

class SocialBarBlocStateInit extends SocialBarBlocState {
  @override
  List<Object> get props => [];
}

class SocialBarBlocStateLoaded extends SocialBarBlocState {
  final FeedEntryStateLoaded feedEntry;

  SocialBarBlocStateLoaded(this.feedEntry);

  @override
  List<Object> get props => [feedEntry];
}

class SocialBarBloc extends Bloc<SocialBarBlocEvent, SocialBarBlocState> {
  final FeedEntryStateLoaded feedEntry;

  SocialBarBloc(this.feedEntry) : super(SocialBarBlocStateInit()) {
    add(SocialBarBlocEventInit());
  }

  @override
  Stream<SocialBarBlocState> mapEventToState(SocialBarBlocEvent event) async* {
    if (event is SocialBarBlocEventInit) {
      yield SocialBarBlocStateLoaded(this.feedEntry);
    }
  }
}
