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
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';

abstract class FeedEntryState extends Equatable {
  final dynamic data;

  final dynamic feedEntryID;
  final dynamic feedID;
  final String type;
  final bool isNew;
  final bool synced;
  final DateTime date;
  final FeedEntryParams params;

  final FeedEntrySocialState socialState;

  final bool remoteState;

  FeedEntryState(this.feedEntryID, this.feedID, this.type, this.isNew,
      this.synced, this.date, this.params,
      {this.remoteState = false, this.data, this.socialState});

  @override
  List<Object> get props => [
        feedEntryID,
        feedID,
        type,
        isNew,
        synced,
        date,
        params,
        remoteState,
        socialState
      ];
}

class FeedEntryStateNotLoaded extends FeedEntryState {
  FeedEntryStateNotLoaded(dynamic id, dynamic feedID, String type, bool isNew,
      bool synced, DateTime date, dynamic params,
      {bool remoteState = false,
      dynamic data,
      FeedEntrySocialState socialState})
      : super(id, feedID, type, isNew, synced, date, params,
            remoteState: remoteState, data: data, socialState: socialState);
}

class FeedEntryStateLoaded extends FeedEntryState {
  FeedEntryStateLoaded.copy(FeedEntryState from,
      {FeedEntrySocialState socialState, bool remoteState})
      : super(
          from.feedEntryID,
          from.feedID,
          from.type,
          from.isNew,
          from.synced,
          from.date,
          from.params,
          remoteState: remoteState ?? from.remoteState,
          socialState: socialState ?? from.socialState,
        );
}
