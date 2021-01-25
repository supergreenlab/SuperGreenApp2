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

class FeedCareCommonState extends FeedEntryStateLoaded {
  final List<MediaState> beforeMedias;
  final List<MediaState> afterMedias;

  FeedCareCommonState(
    FeedEntryState from, {
    this.beforeMedias,
    this.afterMedias,
    FeedEntrySocialState socialState,
    bool remoteState,
    String shareLink,
  }) : super.copy(from,
            socialState: socialState,
            remoteState: remoteState,
            shareLink: shareLink);

  @override
  List<Object> get props => [...super.props, beforeMedias, afterMedias];

  FeedEntryState copyWith({
    FeedEntrySocialState socialState,
    String shareLink,
  }) {
    return FeedCareCommonState(
      this,
      beforeMedias: beforeMedias,
      afterMedias: afterMedias,
      socialState: socialState,
      shareLink: shareLink,
    );
  }
}
