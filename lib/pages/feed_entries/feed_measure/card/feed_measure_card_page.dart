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
import 'package:super_green_app/pages/feed_entries/entry_params/feed_measure.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
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

  const FeedMeasureCardPage(this.animation, this.feedState, this.state,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedEntryStateLoaded) {
      return _renderLoaded(context, state);
    }
    return _renderLoading(context, state);
  }

  Widget _renderLoading(BuildContext context, FeedEntryState state) {
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              'assets/feed_card/icon_measure.svg', 'Measure', state.synced,
              showSyncStatus: !state.remoteState,
              showControls: !state.remoteState),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state.date),
          ),
          Container(
            height: 350,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedMeasureState state) {
    FeedMeasureParams params = state.params;
    String sliderTitle;
    if (params.time != null) {
      Duration time = Duration(seconds: params.time);
      sliderTitle = '${Duration(seconds: params.time).inDays} days';
      if (time.inMinutes == 0) {
        sliderTitle = '${Duration(seconds: params.time).inSeconds} s';
      } else if (time.inHours == 0) {
        sliderTitle = '${Duration(seconds: params.time).inMinutes} min';
      } else if (time.inDays == 0) {
        sliderTitle = '${Duration(seconds: params.time).inHours} hours';
      } else if (time.inDays < 4) {
        sliderTitle =
            '${Duration(seconds: params.time).inDays} days and ${Duration(seconds: params.time).inHours % 24} hours';
      }
    }
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
            'assets/feed_card/icon_measure.svg',
            'Measure',
            state.synced,
            showSyncStatus: !state.remoteState,
            showControls: !state.remoteState,
            onDelete: () {
              BlocProvider.of<FeedBloc>(context)
                  .add(FeedBlocEventDeleteEntry(state));
            },
          ),
          MediaList(
            [state.current],
            showSyncStatus: !state.remoteState,
            showTapIcon: state.previous != null,
            onMediaTapped: (media) {
              if (state.previous != null) {
                BlocProvider.of<MainNavigatorBloc>(context).add(
                    MainNavigateToFullscreenMedia(
                        state.previous.thumbnailPath, state.previous.filePath,
                        overlayPath: state.current.filePath,
                        heroPath: state.current.filePath,
                        sliderTitle: sliderTitle));
              } else {
                BlocProvider.of<MainNavigatorBloc>(context).add(
                    MainNavigateToFullscreenMedia(
                        state.current.thumbnailPath, state.current.filePath));
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
