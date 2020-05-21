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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_state.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedMeasureCardPage extends StatelessWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;

  const FeedMeasureCardPage(this.animation, this.feedState, this.state, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedEntryStateLoaded) {
      return _renderLoaded(context, state);
    }
    return _renderLoading(context);
  }

  Widget _renderLoading(BuildContext context) {
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              'assets/feed_card/icon_towelie.png', 'Towelie', state.synced),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state.date),
          ),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedMeasureState state) {
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              'assets/feed_card/icon_measure.svg', 'Measure', state.synced),
          MediaList(
            [state.current],
            onMediaTapped: (media) {
              if (state.previous != null) {
                BlocProvider.of<MainNavigatorBloc>(context).add(
                    MainNavigateToFullscreenMedia(state.previous.thumbnailPath, state.previous.filePath,
                        overlayPath: state.current.filePath,
                        heroPath: state.current.filePath));
              } else {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToFullscreenMedia(state.current.thumbnailPath, state.previous.filePath));
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state.date),
          ),
        ],
      ),
    );
  }
}
