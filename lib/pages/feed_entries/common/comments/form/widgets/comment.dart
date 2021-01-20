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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/comments_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/widgets/user_avatar.dart';

class CommentView extends StatelessWidget {
  final Comment comment;
  final bool first;
  final Function replyTo;

  const CommentView({Key key, this.comment, this.first = false, this.replyTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pic = comment.pic;
    if (pic != null) {
      pic = BackendAPI().feedsAPI.absoluteFileURL(pic);
    }
    Duration diff = DateTime.now().difference(comment.createdAt);
    return Padding(
      padding: EdgeInsets.only(
          left: comment.replyTo != null ? 24 : 8.0,
          right: 8.0,
          top: this.first ? 16.0 : 4.0,
          bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(icon: pic),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: MarkdownBody(
                    data: '**${comment.from}** ${comment.text}',
                    styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          renderDuration(diff),
                          style: TextStyle(color: Color(0xffababab)),
                        ),
                      ),
                      comment.replyTo == null
                          ? InkWell(
                              onTap: () {
                                replyTo();
                              },
                              child: Text(
                                'Reply',
                                style: TextStyle(color: Color(0xff717171)),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<CommentsFormBloc>(context)
                  .add(CommentsFormBlocEventLike(comment));
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                  'assets/feed_card/button_like${comment.liked ? '_on' : ''}.png',
                  width: 20,
                  height: 20),
            ),
          ),
        ],
      ),
    );
  }

  String renderDuration(Duration diff, {suffix = ''}) {
    int minuteDiff = diff.inMinutes;
    int hourDiff = diff.inHours;
    int dayDiff = diff.inDays;
    String format;
    if (minuteDiff < 1) {
      format = 'few seconds$suffix';
    } else if (minuteDiff < 60) {
      format = '$minuteDiff min';
    } else if (hourDiff < 24) {
      format = '${hourDiff}h';
    } else {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''}';
    }
    return format;
  }
}
