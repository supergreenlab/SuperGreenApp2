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
import 'package:intl/intl.dart';
import 'package:share_extend/share_extend.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

class SocialBarPage extends StatelessWidget {
  static String socialBarPagePageLikedBy(int count) {
    return Intl.plural(
      count,
      one: 'Liked by 1',
      other: 'Liked by $count',
      args: [count],
      name: 'socialBarPagePageLikedBy',
      desc: 'Number of likes on a post',
      locale: SGLLocalizations.current.localeName,
    );
  }

  final FeedEntryState state;
  final FeedState feedState;

  const SocialBarPage({Key key, this.state, this.feedState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return renderLoaded(context);
  }

  Widget renderLoaded(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
              renderButton(
                  context,
                  state.socialState is FeedEntrySocialStateLoaded &&
                          (state.socialState as FeedEntrySocialStateLoaded).isBookmarked
                      ? 'button_bookmark_on'
                      : 'button_bookmark',
                  () => onBookmark(context),
                  last: true),
            ],
          ),
          state.socialState is FeedEntrySocialStateLoaded &&
                  (state.socialState as FeedEntrySocialStateLoaded).nLikes > 0
              ? Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                  child: Text(
                    SocialBarPage.socialBarPagePageLikedBy((state.socialState as FeedEntrySocialStateLoaded).nLikes),
                    style: TextStyle(color: Color(0xff565656), fontSize: 15),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget renderButton(BuildContext context, String icon, Function onClick, {bool last = false}) {
    if (!feedState.loggedIn) {
      onClick = () => createAccountOrLogin(context);
    } else {
      onClick = state.socialState is FeedEntrySocialStateLoaded ? onClick : null;
    }
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.only(right: last ? 0 : 8),
        child: Opacity(
            opacity: onClick == null ? 0.4 : 1,
            child: Image.asset('assets/feed_card/$icon.png', width: 30, height: 30)),
      ),
    );
  }

  void onLike(BuildContext context) {
    BlocProvider.of<FeedBloc>(context).add(FeedBlocEventLikeFeedEntry(state));
  }

  void onComment(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCommentFormEvent(true, state));
  }

  void onShare(BuildContext context) async {
    await ShareExtend.share(state.shareLink, 'text');
  }

  void onBookmark(BuildContext context) {
    BlocProvider.of<FeedBloc>(context).add(FeedBlocEventBookmarkFeedEntry(state));
  }

  void createAccountOrLogin(BuildContext context) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(CommonL10N.loginRequiredDialogTitle),
            content: Text(CommonL10N.loginRequiredDialogBody),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.loginCreateAccount),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth());
    }
  }
}
