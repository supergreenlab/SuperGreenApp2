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

import 'package:super_green_app/pages/feed_entries/common/media_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedTimelapseState extends FeedEntryStateLoaded {
  final List<MediaState> medias;

  FeedTimelapseState(
    FeedEntryState from, {
    required this.medias,
    FeedEntrySocialState? socialState,
    bool? showPlantInfos,
    bool? isRemoteState,
    bool? followed,
    String? shareLink,
  }) : super.copy(
          from,
          socialState: socialState ?? from.socialState,
          showPlantInfos: showPlantInfos ?? from.showPlantInfos,
          isRemoteState: isRemoteState ?? from.isRemoteState,
          followed: followed ?? from.followed,
          shareLink: shareLink ?? from.shareLink,
        );

  @override
  List<Object?> get props => [...super.props, medias];

  FeedEntryState copyWith({
    bool? showPlantInfos,
    FeedEntrySocialState? socialState,
    bool? followed,
    String? shareLink,
  }) {
    return FeedTimelapseState(
      this,
      medias: this.medias,
      showPlantInfos: showPlantInfos ?? this.showPlantInfos,
      socialState: socialState ?? this.socialState,
      followed: followed ?? this.followed,
      shareLink: shareLink ?? this.shareLink,
    );
  }
}
