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

import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedLightState extends FeedEntryStateLoaded {
  FeedLightState(
    FeedEntryState from, {
    FeedEntrySocialState socialState,
    bool showPlantInfos,
    bool isRemoteState,
    String shareLink,
  }) : super.copy(from,
            socialState: socialState ?? from.socialState,
            showPlantInfos: showPlantInfos ?? from.showPlantInfos,
            isRemoteState: isRemoteState ?? from.isRemoteState,
            shareLink: shareLink ?? from.shareLink);

  FeedEntryState copyWith({
    FeedEntrySocialState socialState,
    String shareLink,
    bool showPlantInfos,
  }) {
    return FeedLightState(
      this,
      showPlantInfos: showPlantInfos ?? this.showPlantInfos,
      socialState: socialState ?? this.socialState,
      shareLink: shareLink ?? this.shareLink,
    );
  }
}
