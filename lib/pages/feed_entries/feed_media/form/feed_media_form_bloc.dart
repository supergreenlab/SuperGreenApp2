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
import 'package:super_green_app/data/local/feed_entry_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedMediaFormBlocEvent extends Equatable {}

class FeedMediaFormBlocEventCreate extends FeedMediaFormBlocEvent {
  final List<FeedMediasCompanion> medias;
  final String message;
  final bool helpRequest;

  FeedMediaFormBlocEventCreate(this.medias, this.message, this.helpRequest);

  @override
  List<Object> get props => [medias, message, helpRequest];
}

class FeedMediaFormBlocState extends Equatable {
  FeedMediaFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocStateLoading extends FeedMediaFormBlocState {
  FeedMediaFormBlocStateLoading();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocStateDone extends FeedMediaFormBlocState {
  FeedMediaFormBlocStateDone();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBloc
    extends Bloc<FeedMediaFormBlocEvent, FeedMediaFormBlocState> {
  final MainNavigateToFeedMediaFormEvent args;

  @override
  FeedMediaFormBlocState get initialState => FeedMediaFormBlocState();

  FeedMediaFormBloc(this.args);

  @override
  Stream<FeedMediaFormBlocState> mapEventToState(
      FeedMediaFormBlocEvent event) async* {
    if (event is FeedMediaFormBlocEventCreate) {
      yield FeedMediaFormBlocStateLoading();
      final db = RelDB.get();
      int feedEntryID =
          await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_MEDIA',
        feed: args.plant.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({'message': event.message, 'helpRequest': event.helpRequest})),
      ));
      for (FeedMediasCompanion m in event.medias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feed: Value(args.plant.feed), feedEntry: Value(feedEntryID)));
      }
      yield FeedMediaFormBlocStateDone();
    }
  }
}
