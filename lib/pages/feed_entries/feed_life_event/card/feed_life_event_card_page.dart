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
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
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
  static String get feedLifeEventCardPageTitle {
    return Intl.message(
      'Life event',
      name: 'feedLifeEventCardPageTitle',
      desc: 'Life event card title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventCardPageGermination {
    return Intl.message(
      'Germination!',
      name: 'feedLifeEventCardPageGermination',
      desc: 'Germination life event',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventCardPageVeggingStarted {
    return Intl.message(
      'Vegging Started!',
      name: 'feedLifeEventCardPageVeggingStarted',
      desc: 'Vegging started life event',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventCardPageBloomingStarted {
    return Intl.message(
      'Blooming Started!',
      name: 'feedLifeEventCardPageBloomingStarted',
      desc: 'Blooming started life event',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventCardPageDryingStarted {
    return Intl.message(
      'Drying Started!',
      name: 'feedLifeEventCardPageDryingStarted',
      desc: 'Drying started life event',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventCardPageCuringStarted {
    return Intl.message(
      'Curing Started!',
      name: 'feedLifeEventCardPageCuringStarted',
      desc: 'Curing started life event',
      locale: SGLLocalizations.current.localeName,
    );
  }

  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;
  final List<Widget> Function(FeedEntryState feedEntryState) cardActions;

  const FeedLifeEventCardPage(this.animation, this.feedState, this.state, {Key key, this.cardActions})
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
          FeedCardTitle(
              'assets/feed_card/icon_life_events.svg', FeedLifeEventCardPage.feedLifeEventCardPageTitle, state.synced,
              showSyncStatus: !state.isRemoteState, showControls: !state.isRemoteState),
          Container(
            height: 130,
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

  Widget _renderLoaded(BuildContext context, FeedEntryStateLoaded state, PlantFeedState feedState) {
    FeedLifeEventParams params = state.params;
    List<String> phases = [
      FeedLifeEventCardPage.feedLifeEventCardPageGermination,
      FeedLifeEventCardPage.feedLifeEventCardPageVeggingStarted,
      FeedLifeEventCardPage.feedLifeEventCardPageBloomingStarted,
      FeedLifeEventCardPage.feedLifeEventCardPageDryingStarted,
      FeedLifeEventCardPage.feedLifeEventCardPageCuringStarted,
    ];
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              'assets/feed_card/icon_life_events.svg', FeedLifeEventCardPage.feedLifeEventCardPageTitle, state.synced,
              showSyncStatus: !state.isRemoteState, showControls: !state.isRemoteState, onDelete: () {
            BlocProvider.of<FeedBloc>(context).add(FeedBlocEventDeleteEntry(state));
          }, actions: cardActions != null ? cardActions(state) : []),
          Container(
            height: 130,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                phases[params.phase.index],
                style: TextStyle(color: Color(0xff3bb30b), fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
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
