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
  final String shareLink;

  FeedEntryState({
    this.feedEntryID,
    this.feedID,
    this.type,
    this.isNew,
    this.synced,
    this.date,
    this.params,
    this.data,
    this.socialState,
    this.remoteState = false,
    this.shareLink,
  });

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
        socialState,
        shareLink,
      ];

  FeedEntryState copyWith({
    FeedEntrySocialState socialState,
    String shareLink,
  });
}

class FeedEntryStateNotLoaded extends FeedEntryState {
  FeedEntryStateNotLoaded({
    dynamic feedEntryID,
    dynamic feedID,
    String type,
    bool isNew,
    bool synced,
    DateTime date,
    dynamic params,
    bool remoteState = false,
    dynamic data,
    FeedEntrySocialState socialState,
    String shareLink,
  }) : super(
          feedEntryID: feedEntryID,
          feedID: feedID,
          type: type,
          isNew: isNew,
          synced: synced,
          date: date,
          params: params,
          data: data,
          remoteState: remoteState,
          socialState: socialState,
          shareLink: shareLink,
        );

  FeedEntryState copyWith({
    FeedEntrySocialState socialState,
    String shareLink,
  }) {
    return FeedEntryStateNotLoaded(
      feedEntryID: this.feedEntryID,
      feedID: this.feedID,
      type: this.type,
      isNew: this.isNew,
      synced: this.synced,
      date: this.date,
      params: this.params,
      data: this.data,
      remoteState: this.remoteState,
      socialState: socialState ?? this.socialState,
      shareLink: shareLink ?? this.shareLink,
    );
  }
}

abstract class FeedEntryStateLoaded extends FeedEntryState {
  FeedEntryStateLoaded.copy(
    FeedEntryState from, {
    dynamic feedEntryID,
    dynamic feedID,
    String type,
    bool isNew,
    bool synced,
    DateTime date,
    dynamic params,
    bool remoteState = false,
    dynamic data,
    FeedEntrySocialState socialState,
    String shareLink,
  }) : super(
          feedEntryID: feedEntryID ?? from.feedEntryID,
          feedID: feedID ?? from.feedID,
          type: type ?? from.type,
          isNew: isNew ?? from.isNew,
          synced: synced ?? from.synced,
          date: date ?? from.date,
          params: params ?? from.params,
          data: data ?? from.data,
          socialState: socialState ?? from.socialState,
          remoteState: remoteState ?? from.remoteState,
          shareLink: shareLink ?? from.shareLink,
        );
}
