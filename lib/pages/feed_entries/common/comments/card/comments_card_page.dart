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

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/card/widgets/comment.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_social_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

class CommentsCardPage extends StatefulWidget {
  final FeedEntryState state;
  final FeedState feedState;

  const CommentsCardPage({Key? key, required this.state, required this.feedState}) : super(key: key);

  @override
  _CommentsCardPageState createState() => _CommentsCardPageState();
}

class _CommentsCardPageState extends State<CommentsCardPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.state.socialState is FeedEntrySocialStateNotLoaded) {
      return Container();
    }
    return AnimatedSizeAndFade(
        fadeDuration: Duration(milliseconds: 200),
        sizeDuration: Duration(milliseconds: 200),
        child: renderLoaded(context, widget.state.socialState as FeedEntrySocialStateLoaded));
  }

  Widget renderLoaded(BuildContext context, FeedEntrySocialStateLoaded socialState) {
    List<Widget> content = [];
    if (socialState.comments?.length == 2) {
      content.add(SmallCommentView(
        feedEntry: widget.state as FeedEntryStateLoaded,
        comment: socialState.comments![0],
        loggedIn: widget.feedState.loggedIn,
      ));
      content.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          'View all ${socialState.nComments} comments',
          style: TextStyle(color: Color(0xff898989)),
        ),
      ));
      content.add(SmallCommentView(
          feedEntry: widget.state as FeedEntryStateLoaded,
          comment: socialState.comments![1],
          loggedIn: widget.feedState.loggedIn));
    } else if (socialState.comments?.length == 1) {
      content.add(SmallCommentView(
          feedEntry: widget.state as FeedEntryStateLoaded,
          comment: socialState.comments![0],
          loggedIn: widget.feedState.loggedIn));
    }
    return InkWell(
        onTap: () {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToCommentFormEvent(false, widget.state as FeedEntryStateLoaded));
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
