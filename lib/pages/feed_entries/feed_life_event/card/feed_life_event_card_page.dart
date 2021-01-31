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
import 'package:super_green_app/pages/feed_entries/common/comments/card/comments_card_page.dart';
import 'package:super_green_app/pages/feed_entries/common/social_bar/social_bar_page.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_life_event.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedLifeEventCardPage extends StatelessWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;
  final List<Widget> Function(FeedEntryState feedEntryState) cardActions;

  const FeedLifeEventCardPage(this.animation, this.feedState, this.state,
      {Key key, this.cardActions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedEntryStateLoaded && feedState is PlantFeedState) {
      return _renderLoaded(context, state, feedState);
    }
    return _renderLoading(context, state);
  }

  Widget _renderLoading(BuildContext context, FeedEntryState state) {
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle('assets/feed_card/icon_life_events.svg', 'Life Event',
              state.synced,
              showSyncStatus: !state.remoteState,
              showControls: !state.remoteState),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, feedState),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedEntryStateLoaded state,
      PlantFeedState feedState) {
    FeedLifeEventParams params = state.params;
    const List<String> phases = [
      'Germination!',
      'Vegging Started!',
      'Blooming Started!',
      'Drying Started!',
      'Curing Started!'
    ];
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle('assets/feed_card/icon_life_events.svg', 'Life Event',
              state.synced,
              showSyncStatus: !state.remoteState,
              showControls: !state.remoteState, onDelete: () {
            BlocProvider.of<FeedBloc>(context)
                .add(FeedBlocEventDeleteEntry(state));
          }, actions: cardActions != null ? cardActions(state) : []),
          Container(
            height: 130,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(phases[params.phase.index],
                  style: TextStyle(
                      color: Color(0xff3bb30b),
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          SocialBarPage(
            state: state,
            feedState: feedState,
          ),
          CommentsCardPage(
            state: state,
            feedState: feedState,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, feedState),
          ),
        ],
      ),
    );
  }
}
