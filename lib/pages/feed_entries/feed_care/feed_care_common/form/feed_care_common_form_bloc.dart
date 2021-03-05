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
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_care.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/form/feed_care_common_form_page.dart';

abstract class FeedCareCommonFormBlocEvent extends Equatable {}

class FeedCareCommonFormBlocEventLoadDraft extends FeedCareCommonFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedCareCommonFormBlocEventSaveDraft extends FeedCareCommonFormBlocEvent {
  final FeedCareCommonDraft draft;

  FeedCareCommonFormBlocEventSaveDraft(this.draft);

  @override
  List<Object> get props => [draft];
}

class FeedCareCommonFormBlocEventDeleteDraft extends FeedCareCommonFormBlocEvent {
  final FeedCareCommonDraft draft;

  FeedCareCommonFormBlocEventDeleteDraft(this.draft);

  @override
  List<Object> get props => [draft];
}

class FeedCareCommonFormBlocEventCreate extends FeedCareCommonFormBlocEvent {
  final DateTime date;
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;
  final String message;
  final bool helpRequest;

  final FeedCareCommonDraft draft;

  FeedCareCommonFormBlocEventCreate(
      this.date, this.beforeMedias, this.afterMedias, this.message, this.helpRequest, this.draft);

  @override
  List<Object> get props => [date, beforeMedias, afterMedias, message, helpRequest];
}

class FeedCareCommonFormBlocState extends Equatable {
  FeedCareCommonFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedCareCommonFormBlocStateDraft extends FeedCareCommonFormBlocState {
  final FeedCareCommonDraft draft;

  FeedCareCommonFormBlocStateDraft(this.draft);

  @override
  List<Object> get props => [draft];
}

class FeedCareCommonFormBlocStateCurrentDraft extends FeedCareCommonFormBlocState {
  final FeedCareCommonDraft draft;

  FeedCareCommonFormBlocStateCurrentDraft(this.draft);

  @override
  List<Object> get props => [draft];
}

class FeedCareCommonFormBlocStateLoading extends FeedCareCommonFormBlocState {
  FeedCareCommonFormBlocStateLoading();
}

class FeedCareCommonFormBlocStateDone extends FeedCareCommonFormBlocState {
  final Plant plant;
  final FeedEntry feedEntry;

  FeedCareCommonFormBlocStateDone(this.plant, this.feedEntry);
}

abstract class FeedCareCommonFormBloc extends Bloc<FeedCareCommonFormBlocEvent, FeedCareCommonFormBlocState> {
  final MainNavigateToFeedCareCommonFormEvent args;

  FeedCareCommonFormBloc(this.args) : super(FeedCareCommonFormBlocState()) {
    add(FeedCareCommonFormBlocEventLoadDraft());
  }

  @override
  Stream<FeedCareCommonFormBlocState> mapEventToState(FeedCareCommonFormBlocEvent event) async* {
    if (event is FeedCareCommonFormBlocEventLoadDraft) {
      try {
        FeedEntryDraft draft = await RelDB.get().feedsDAO.getEntryDraft(args.plant.feed, cardType());
        yield FeedCareCommonFormBlocStateDraft(FeedCareCommonDraft.fromJSON(draft.id, draft.params));
      } catch (e, trace) {
        Logger.logError(e, trace);
      }
    } else if (event is FeedCareCommonFormBlocEventDeleteDraft) {
      await RelDB.get().feedsDAO.deleteFeedEntryDraft(event.draft.draftID);
    } else if (event is FeedCareCommonFormBlocEventSaveDraft) {
      if (event.draft.draftID != null) {
        await RelDB.get().feedsDAO.updateFeedEntryDraft(
            FeedEntryDraftsCompanion(id: Value(event.draft.draftID), params: Value(event.draft.toJSON())));
      } else {
        int draftID = await RelDB.get().feedsDAO.addFeedEntryDraft(FeedEntryDraftsCompanion(
            feed: Value(args.plant.feed), type: Value(cardType()), params: Value(event.draft.toJSON())));
        yield FeedCareCommonFormBlocStateCurrentDraft(event.draft.copyWithDraftID(draftID));
      }
    } else if (event is FeedCareCommonFormBlocEventCreate) {
      yield FeedCareCommonFormBlocStateLoading();
      final db = RelDB.get();
      int feedEntryID = await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
        type: cardType(),
        feed: args.plant.feed,
        date: event.date,
        params: Value(FeedCareParams(event.message).toJSON()),
      ));
      for (FeedMediasCompanion m in event.beforeMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(
            feed: Value(args.plant.feed),
            feedEntry: Value(feedEntryID),
            params: Value(JsonEncoder().convert({'before': true}))));
      }
      for (FeedMediasCompanion m in event.afterMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(
            feed: Value(args.plant.feed),
            feedEntry: Value(feedEntryID),
            params: Value(JsonEncoder().convert({'before': false}))));
      }
      FeedEntry feedEntry = await db.feedsDAO.getFeedEntry(feedEntryID);

      if (event.draft != null) {
        await RelDB.get().feedsDAO.deleteFeedEntryDraft(event.draft.draftID);
      }

      yield FeedCareCommonFormBlocStateDone(args.plant, feedEntry);
    }
  }

  String cardType();
}
