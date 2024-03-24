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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/date_renderer.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/comments_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/comments_form_page.dart';
import 'package:super_green_app/pages/feed_entries/common/widgets/user_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentView extends StatelessWidget {
  static String get commentsFormPageSendingCommentLoading {
    return Intl.message(
      'Sending comment..',
      name: 'commentsFormPageSendingCommentLoading',
      desc: 'Comments page auto-loading message at end of scroll',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String commentsFormPageCommentLikeCount(int count) {
    return Intl.plural(
      count,
      one: '1 like',
      other: '$count likes',
      args: [count],
      name: 'commentsFormPageCommentLikeCount',
      desc: 'Number of likes on a comment',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get commentsFormPageReplyButton {
    return Intl.message(
      'Reply',
      name: 'commentsFormPageReplyButton',
      desc: 'Comments page reply button for comments',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get commentsFormPageReportButton {
    return Intl.message(
      'Report&Block',
      name: 'commentsFormPageReportButton',
      desc: 'Comments page report button for comments',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String commentsFormPageReportDialogBody(String comment) {
    return Intl.message(
      'Comment was: "$comment". This will also block this user.',
      args: [comment],
      name: 'commentsFormPageReportDialogBody',
      desc: 'Comments page report dialog body',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get commentsFormPageReportDialogTitle {
    return Intl.message(
      'Report this comment?',
      name: 'commentsFormPageReportDialogTitle',
      desc: 'Comments page report dialog title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Comment comment;
  final bool first;
  final Function replyTo;
  final bool loggedIn;

  const CommentView({
    Key? key,
    required this.comment,
    this.first = false,
    required this.replyTo,
    required this.loggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? pic = comment.pic;
    if (pic != null) {
      pic = BackendAPI().feedsAPI.absoluteFileURL(pic);
    }
    Duration diff = DateTime.now().difference(comment.createdAt);
    Widget avatar = UserAvatar(icon: pic);
    if (comment.type != CommentType.COMMENT) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffcdcdcd), width: 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Image.asset(commentTypes[comment.type]!['pic']!,
                    width: 30, height: 30),
              )),
        ],
      );
    }
    Widget recommendations = Container();
    if (comment.type == CommentType.RECOMMEND) {
      CommentParam params =
          CommentParam.fromMap(JsonDecoder().convert(comment.params));
      recommendations = Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ...params.recommend!.map((p) {
            return Row(
              children: [
                Text(p.name, style: TextStyle(fontWeight: FontWeight.bold)),
                p.supplier != null
                    ? Expanded(
                        child: InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(p.supplier!.url));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            p.supplier!.url,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                      ))
                    : Container(),
              ],
            );
          }),
        ]),
      );
    }
    return Padding(
      padding: EdgeInsets.only(
          left: comment.replyTo != null ? 24 : 8.0,
          right: 8.0,
          top: this.first ? 16.0 : 4.0,
          bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: MarkdownBody(
                    data: '**${comment.from}** ${comment.text}',
                    styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: Color(0xff454545), fontSize: 16)),
                  ),
                ),
                recommendations,
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          DateRenderer.renderDuration(diff),
                          style: TextStyle(color: Color(0xffababab)),
                        ),
                      ),
                      comment.nLikes > 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                CommentView.commentsFormPageCommentLikeCount(
                                    comment.nLikes),
                                style: TextStyle(color: Color(0xffababab)),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            if (!loggedIn) {
                              createAccountOrLogin(context);
                              return;
                            }
                            replyTo();
                          },
                          child: Text(
                            CommentView.commentsFormPageReplyButton,
                            style: TextStyle(color: Color(0xff717171)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!loggedIn) {
                            createAccountOrLogin(context);
                            return;
                          }
                          createReport(context);
                        },
                        child: Text(
                          CommentView.commentsFormPageReportButton,
                          style: TextStyle(color: Color(0xff717171)),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      this.comment.isNew == true
                          ? Text(
                              CommentView.commentsFormPageSendingCommentLoading,
                              style: TextStyle(color: Colors.red))
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (!loggedIn) {
                createAccountOrLogin(context);
                return;
              }
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

  void createReport(BuildContext context) async {
    String c = comment.text;
    if (c.length > 40) {
      c = '${c.substring(0, 40)}...';
    }
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text(CommentView.commentsFormPageReportDialogTitle),
            content: Text(CommentView.commentsFormPageReportDialogBody(c)),
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
                child: Text(CommonL10N.ok),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<CommentsFormBloc>(context)
          .add(CommentsFormBlocEventReport(comment));
    }
  }
}
