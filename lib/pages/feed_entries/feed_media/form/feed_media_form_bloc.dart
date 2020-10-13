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
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_media.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/feed_media_form_page.dart';

abstract class FeedMediaFormBlocEvent extends Equatable {}

class FeedMediaFormBlocEventLoadDraft extends FeedMediaFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocEventSaveDraft extends FeedMediaFormBlocEvent {
  final FeedMediaDraft draft;

  FeedMediaFormBlocEventSaveDraft(this.draft);

  @override
  List<Object> get props => [draft];
}

class FeedMediaFormBlocEventDeleteDraft extends FeedMediaFormBlocEvent {
  final FeedMediaDraft draft;

  FeedMediaFormBlocEventDeleteDraft(this.draft);

  @override
  List<Object> get props => [draft];
}

class FeedMediaFormBlocEventCreate extends FeedMediaFormBlocEvent {
  final DateTime date;
  final List<FeedMediasCompanion> medias;
  final String message;
  final bool helpRequest;

  final FeedMediaDraft draft;

  FeedMediaFormBlocEventCreate(
      this.date, this.medias, this.message, this.helpRequest, this.draft);

  @override
  List<Object> get props => [date, medias, message, helpRequest, draft];
}

class FeedMediaFormBlocState extends Equatable {
  FeedMediaFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocStateLoadingDraft extends FeedMediaFormBlocState {
  FeedMediaFormBlocStateLoadingDraft();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocStateDraft extends FeedMediaFormBlocState {
  final FeedMediaDraft draft;

  FeedMediaFormBlocStateDraft(this.draft);

  @override
  List<Object> get props => [draft];
}

class FeedMediaFormBlocStateNoDraft extends FeedMediaFormBlocState {
  FeedMediaFormBlocStateNoDraft();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocStateCurrentDraft extends FeedMediaFormBlocState {
  final FeedMediaDraft draft;

  FeedMediaFormBlocStateCurrentDraft(this.draft);

  @override
  List<Object> get props => [draft];
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

  int get feedID => args.plant?.feed ?? args.box.feed;

  FeedMediaFormBloc(this.args) : super(FeedMediaFormBlocStateLoadingDraft()) {
    add(FeedMediaFormBlocEventLoadDraft());
  }

  @override
  Stream<FeedMediaFormBlocState> mapEventToState(
      FeedMediaFormBlocEvent event) async* {
    if (event is FeedMediaFormBlocEventLoadDraft) {
      try {
        FeedEntryDraft draft =
            await RelDB.get().feedsDAO.getEntryDraft(feedID, 'FE_MEDIA');
        if (draft != null) {
          yield FeedMediaFormBlocStateDraft(
              FeedMediaDraft.fromJSON(draft.id, draft.params));
        } else {
          yield FeedMediaFormBlocStateNoDraft();
        }
      } catch (e) {
        yield FeedMediaFormBlocStateNoDraft();
        Logger.log(e);
      }
    } else if (event is FeedMediaFormBlocEventDeleteDraft) {
      await RelDB.get().feedsDAO.deleteFeedEntryDraft(event.draft.draftID);
    } else if (event is FeedMediaFormBlocEventSaveDraft) {
      if (event.draft.draftID != null) {
        await RelDB.get().feedsDAO.updateFeedEntryDraft(
            FeedEntryDraftsCompanion(
                id: Value(event.draft.draftID),
                params: Value(event.draft.toJSON())));
      } else {
        int draftID = await RelDB.get().feedsDAO.addFeedEntryDraft(
            FeedEntryDraftsCompanion(
                feed: Value(feedID),
                type: Value('FE_MEDIA'),
                params: Value(event.draft.toJSON())));
        yield FeedMediaFormBlocStateCurrentDraft(
            event.draft.copyWithDraftID(draftID));
      }
    } else if (event is FeedMediaFormBlocEventCreate) {
      yield FeedMediaFormBlocStateLoading();
      final db = RelDB.get();
      int feedEntryID =
          await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_MEDIA',
        feed: feedID,
        date: event.date,
        params:
            Value(FeedMediaParams(event.message, event.helpRequest).toJSON()),
      ));
      for (FeedMediasCompanion m in event.medias) {
        await db.feedsDAO.addFeedMedia(
            m.copyWith(feed: Value(feedID), feedEntry: Value(feedEntryID)));
      }

      if (event.draft != null) {
        await RelDB.get().feedsDAO.deleteFeedEntryDraft(event.draft.draftID);
      }

      yield FeedMediaFormBlocStateDone();
    }
  }
}
