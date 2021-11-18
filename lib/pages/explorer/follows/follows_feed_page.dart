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
import 'package:super_green_app/pages/explorer/follows/follows_feed_delegate.dart';
import 'package:super_green_app/pages/explorer/follows/follows_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FollowsFeedPage extends StatefulWidget {
  @override
  _FollowsFeedPageState createState() => _FollowsFeedPageState();
}

class _FollowsFeedPageState extends State<FollowsFeedPage> {
  bool hasCards = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FollowsFeedBloc, FollowsFeedBlocState>(
      listener: (BuildContext context, FollowsFeedBlocState state) {
        if (state is FollowsFeedBlocStateLoaded) {}
      },
      child: BlocBuilder<FollowsFeedBloc, FollowsFeedBlocState>(
          bloc: BlocProvider.of<FollowsFeedBloc>(context),
          builder: (context, state) {
            late Widget body;
            if (state is FollowsFeedBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is FollowsFeedBlocStateLoaded) {
              if (hasCards == false) {
                body = renderNoCard(context);
              } else {
                body = _renderFeed(context, state);
              }
            }
            return Scaffold(
              appBar: SGLAppBar(
                'Follow feed',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                hideBackButton: false,
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderFeed(BuildContext context, FollowsFeedBlocStateLoaded state) {
    return BlocProvider(
      create: (context) => FeedBloc(FollowsFeedBlocDelegate()),
      child: FeedPage(
        title: '',
        color: Colors.white,
        feedColor: Colors.white,
        elevate: false,
        appBarEnabled: false,
        onLoaded: (bool hasCards) {
          setState(() {
            this.hasCards = hasCards;
          });
        },
        cardActions: (BuildContext context, FeedEntryState state) {
          return [
            IconButton(
              icon: Text(
                'Open plant',
                style: TextStyle(fontSize: 12.0, color: Color(0xff3bb30b), fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(
                    MainNavigateToPublicPlant(state.plantID!, name: state.plantName, feedEntryID: state.feedEntryID));
              },
            )
          ];
        },
      ),
    );
  }

  Widget renderNoCard(BuildContext context) {
    return Fullscreen(
      title: 'Not following any plants yet',
      subtitle: 'You can follow plant diaries, only their cards will show up here.',
      child: Icon(
        Icons.follow_the_signs,
        color: Color(0xff3bb30b),
        size: 100,
      ),
    );
  }
}
