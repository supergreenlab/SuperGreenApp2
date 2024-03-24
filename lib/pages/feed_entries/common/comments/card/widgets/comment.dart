/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class SmallCommentView extends StatelessWidget {
  final FeedEntryStateLoaded feedEntry;
  final Comment comment;
  final bool loggedIn;

  const SmallCommentView(
      {Key? key,
      required this.feedEntry,
      required this.comment,
      required this.loggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MarkdownBody(
            data: '**${comment.from}** ${comment.text}',
            styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: Color(0xff454545), fontSize: 16)),
          ),
        ),
        InkWell(
          onTap: () {
            if (!loggedIn) {
              createAccountOrLogin(context);
              return;
            }
            BlocProvider.of<FeedBloc>(context)
                .add(FeedBlocEventLikeComment(comment, feedEntry));
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 4.0, top: 4.0, bottom: 8.0),
            child: Image.asset(
                'assets/feed_card/button_like${comment.liked ? '_on' : ''}.png',
                width: 20,
                height: 20),
          ),
        ),
      ],
    );
  }

  void createAccountOrLogin(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
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
    if (confirm ?? false) {
      BlocProvider.of<MainNavigatorBloc>(context)
          .add(MainNavigateToSettingsAuth());
    }
  }
}
