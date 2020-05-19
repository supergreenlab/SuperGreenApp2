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

abstract class FeedCareCommonFormBlocEvent extends Equatable {}

class FeedCareCommonFormBlocEventCreate extends FeedCareCommonFormBlocEvent {
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;
  final String message;
  final bool helpRequest;

  FeedCareCommonFormBlocEventCreate(this.beforeMedias, this.afterMedias, this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedCareCommonFormBlocState extends Equatable {
  FeedCareCommonFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedCareCommonFormBlocStateLoading extends FeedCareCommonFormBlocState {
  FeedCareCommonFormBlocStateLoading();
}

class FeedCareCommonFormBlocStateDone extends FeedCareCommonFormBlocState {
  final Plant plant;
  final FeedEntry feedEntry;

  FeedCareCommonFormBlocStateDone(this.plant, this.feedEntry);
}

abstract class FeedCareCommonFormBloc
    extends Bloc<FeedCareCommonFormBlocEvent, FeedCareCommonFormBlocState> {
  final MainNavigateToFeedCareCommonFormEvent args;

  @override
  FeedCareCommonFormBlocState get initialState => FeedCareCommonFormBlocState();

  FeedCareCommonFormBloc(this.args);

  @override
  Stream<FeedCareCommonFormBlocState> mapEventToState(
      FeedCareCommonFormBlocEvent event) async* {
    if (event is FeedCareCommonFormBlocEventCreate) {
      yield FeedCareCommonFormBlocStateLoading();
      final db = RelDB.get();
      int feedEntryID =
          await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
        type: cardType(),
        feed: args.plant.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({'message': event.message})),
      ));
      for (FeedMediasCompanion m in event.beforeMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feed: Value(args.plant.feed), feedEntry: Value(feedEntryID), params: Value(JsonEncoder().convert({'before': true}))));
      }
      for (FeedMediasCompanion m in event.afterMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feed: Value(args.plant.feed), feedEntry: Value(feedEntryID), params: Value(JsonEncoder().convert({'before': false}))));
      }
      FeedEntry feedEntry = await db.feedsDAO.getFeedEntry(feedEntryID);
      yield FeedCareCommonFormBlocStateDone(args.plant, feedEntry);
    }
  }

  String cardType();
}
