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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/social_bar/social_bar_bloc.dart';

class SocialBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialBarBloc, SocialBarBlocState>(
      builder: (BuildContext context, SocialBarBlocState state) {
        if (state is SocialBarBlocStateInit) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Loading..'),
          );
        }
        return renderLoaded(context, state);
      },
    );
  }

  Widget renderLoaded(BuildContext context, SocialBarBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
      child: Row(
        children: [
          renderButton(
              context, state, 'button_like', () => onLike(context, state)),
          renderButton(context, state, 'button_comment',
              () => onComment(context, state)),
          renderButton(
              context, state, 'button_share', () => onShare(context, state)),
          Expanded(child: Container()),
          renderButton(context, state, 'button_bookmark',
              () => onBookmark(context, state),
              last: true),
        ],
      ),
    );
  }

  Widget renderButton(BuildContext context, SocialBarBlocStateLoaded state,
      String icon, Function onClick,
      {bool last = false}) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.only(right: last ? 0 : 8),
        child: Image.asset('assets/feed_card/$icon.png', width: 30, height: 30),
      ),
    );
  }

  void onLike(BuildContext context, SocialBarBlocStateLoaded state) {}

  void onComment(BuildContext context, SocialBarBlocStateLoaded state) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToCommentFormEvent(true, state.feedEntry));
  }

  void onShare(BuildContext context, SocialBarBlocStateLoaded state) {}

  void onBookmark(BuildContext context, SocialBarBlocStateLoaded state) {}
}
