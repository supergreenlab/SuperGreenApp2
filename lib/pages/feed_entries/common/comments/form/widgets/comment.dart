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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/pages/feed_entries/common/widgets/user_avatar.dart';

class CommentView extends StatelessWidget {
  final Comment comment;
  final bool first;

  const CommentView({Key key, this.comment, this.first = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pic = comment.pic;
    if (pic != null) {
      pic = BackendAPI().feedsAPI.absoluteFileURL(pic);
    }
    return Padding(
      padding: EdgeInsets.only(
          left: 8.0, right: 8.0, top: this.first ? 16.0 : 4.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(icon: pic),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: MarkdownBody(
              data: '**${comment.from}** ${comment.text}',
              styleSheet: MarkdownStyleSheet(
                  p: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
