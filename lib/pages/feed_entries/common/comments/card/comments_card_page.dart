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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/card/widgets/comment.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

class CommentsCardPage extends StatelessWidget {
  final FeedEntryState state;
  final FeedState feedState;

  const CommentsCardPage({Key key, this.state, this.feedState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.socialState is FeedEntrySocialStateNotLoaded) {
      return Container();
    } else if (state.synced == false) {
      return Container();
    }
    return renderLoaded(context, state.socialState);
  }

  Widget renderLoaded(
      BuildContext context, FeedEntrySocialStateLoaded socialState) {
    List<Widget> content = [];
    if ((socialState.comments?.length ?? 0) == 2) {
      content.add(SmallCommentView(
        feedEntry: state,
        comment: socialState.comments[0],
        loggedIn: feedState.loggedIn,
      ));
      content.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          'View all ${socialState.nComments} comments',
          style: TextStyle(color: Color(0xff898989)),
        ),
      ));
      content.add(SmallCommentView(
          feedEntry: state,
          comment: socialState.comments[1],
          loggedIn: feedState.loggedIn));
    } else if ((socialState.comments?.length ?? 0) == 1) {
      content.add(SmallCommentView(
          feedEntry: state,
          comment: socialState.comments[0],
          loggedIn: feedState.loggedIn));
    }
    return InkWell(
        onTap: () {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToCommentFormEvent(false, state));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: content,
          ),
        ));
  }
}
