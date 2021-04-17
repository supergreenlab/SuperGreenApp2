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
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

// TODO merge this with explorer PublicFeedEntry
abstract class FeedEntryState extends Equatable {
  final dynamic data;

  final dynamic feedEntryID;
  final dynamic feedID;
  final String type;
  final bool isNew;
  final bool synced;
  final DateTime date;
  final FeedEntryParams params;

  final String plantID;
  final String plantName;
  final PlantSettings plantSettings;
  final BoxSettings boxSettings;
  final bool followed;

  final FeedEntrySocialState socialState;

  final bool showPlantInfos;
  final bool isRemoteState;
  final bool isBackedUp;
  final String shareLink;

  FeedEntryState({
    this.feedEntryID,
    this.feedID,
    this.type,
    this.isNew,
    this.synced,
    this.date,
    this.params,
    this.plantID,
    this.plantName,
    this.plantSettings,
    this.boxSettings,
    this.followed,
    this.data,
    this.socialState,
    this.showPlantInfos,
    this.isRemoteState,
    this.isBackedUp,
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
        plantID,
        plantName,
        plantSettings,
        boxSettings,
        followed,
        socialState,
        showPlantInfos,
        isRemoteState,
        isBackedUp,
        shareLink,
      ];

  FeedEntryState copyWith({
    FeedEntrySocialState socialState,
    String shareLink,
    bool showPlantInfos,
    bool followed,
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
    String plantID,
    String plantName,
    PlantSettings plantSettings,
    BoxSettings boxSettings,
    bool followed,
    bool showPlantInfos,
    bool isRemoteState,
    bool isBackedUp,
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
          plantID: plantID,
          plantName: plantName,
          plantSettings: plantSettings,
          boxSettings: boxSettings,
          followed: followed,
          data: data,
          showPlantInfos: showPlantInfos,
          isRemoteState: isRemoteState,
          isBackedUp: isBackedUp,
          socialState: socialState,
          shareLink: shareLink,
        );

  FeedEntryState copyWith({
    FeedEntrySocialState socialState,
    String shareLink,
    bool showPlantInfos,
    bool followed,
  }) {
    return FeedEntryStateNotLoaded(
      feedEntryID: this.feedEntryID,
      feedID: this.feedID,
      type: this.type,
      isNew: this.isNew,
      synced: this.synced,
      date: this.date,
      params: this.params,
      plantID: this.plantID,
      plantName: this.plantName,
      plantSettings: this.plantSettings,
      boxSettings: this.boxSettings,
      followed: followed ?? this.followed,
      data: this.data,
      showPlantInfos: showPlantInfos ?? this.showPlantInfos,
      isRemoteState: this.isRemoteState,
      isBackedUp: this.isBackedUp,
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
    String plantID,
    String plantName,
    PlantSettings plantSettings,
    BoxSettings boxSettings,
    bool followed,
    bool showPlantInfos,
    bool isRemoteState,
    bool isBackedUp,
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
          plantID: plantID ?? from.plantID,
          plantName: plantName ?? from.plantName,
          plantSettings: plantSettings ?? from.plantSettings,
          boxSettings: boxSettings ?? from.boxSettings,
          followed: followed ?? from.followed,
          data: data ?? from.data,
          socialState: socialState ?? from.socialState,
          showPlantInfos: showPlantInfos ?? from.showPlantInfos,
          isRemoteState: isRemoteState ?? from.isRemoteState,
          isBackedUp: isBackedUp ?? from.isBackedUp,
          shareLink: shareLink ?? from.shareLink,
        );
}
