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

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_extend/share_extend.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

class SocialBarPage extends StatelessWidget {
  final FeedEntryState state;
  final FeedState feedState;

  const SocialBarPage({Key key, this.state, this.feedState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedEntrySocialStateNotLoaded) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text('Loading..'),
      );
    }
    return renderLoaded(context);
  }

  Widget renderLoaded(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: Row(
        children: [
          renderButton(
              context,
              state.socialState is FeedEntrySocialStateLoaded &&
                      (state.socialState as FeedEntrySocialStateLoaded).isLiked
                  ? 'button_like_on'
                  : 'button_like',
              () => onLike(context)),
          renderButton(context, 'button_comment', () => onComment(context)),
          renderButton(context, 'button_share', () => onShare(context)),
          Expanded(child: Container()),
          renderButton(context, 'button_bookmark', () => onBookmark(context),
              last: true),
        ],
      ),
    );
  }

  Widget renderButton(BuildContext context, String icon, Function onClick,
      {bool last = false}) {
    return InkWell(
      onTap: state.synced ? onClick : null,
      child: Padding(
        padding: EdgeInsets.only(right: last ? 0 : 8),
        child: Opacity(
            opacity: !state.synced ? 0.4 : 1,
            child: Image.asset('assets/feed_card/$icon.png',
                width: 30, height: 30)),
      ),
    );
  }

  void onLike(BuildContext context) {
    BlocProvider.of<FeedBloc>(context).add(FeedBlocEventLikeFeedEntry(state));
  }

  void onComment(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToCommentFormEvent(true, state));
  }

  void onShare(BuildContext context) async {
    await ShareExtend.share(state.shareLink, 'text');
  }

  void onBookmark(BuildContext context) {}
}
