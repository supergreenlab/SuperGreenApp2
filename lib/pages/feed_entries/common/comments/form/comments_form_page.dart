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

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/comments_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/widgets/comments.dart';
import 'package:super_green_app/pages/feed_entries/common/widgets/user_avatar.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class CommentsFormPage extends StatefulWidget {
  @override
  _CommentsFormPageState createState() => _CommentsFormPageState();
}

class _CommentsFormPageState extends State<CommentsFormPage> {
  final List<Comment> comments = [];

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final FocusNode inputFocus = FocusNode();
  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  String type = 'COMMENT';

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentsFormBloc, CommentsFormBlocState>(
      listener: (BuildContext context, CommentsFormBlocState state) {
        if (state is CommentsFormBlocStateLoaded) {
          setState(() {
            state.comments.forEach((comment) {
              int index = comments
                  .indexWhere((c) => c.createdAt.isAfter(comment.createdAt));
              index = index < 0 ? 0 : index;
              listKey.currentState
                  .insertItem(index, duration: Duration(milliseconds: 200));
              comments.insert(index, comment);
            });
          });
          Timer(
              Duration(milliseconds: 100),
              () => scrollController.animateTo(0,
                  duration: Duration(milliseconds: 500), curve: Curves.linear));
        }
      },
      child: BlocBuilder<CommentsFormBloc, CommentsFormBlocState>(
          builder: (BuildContext context, CommentsFormBlocState state) {
        Widget body;
        if (state is CommentsFormBlocStateInit) {
          body = FullscreenLoading();
        } else if (state is CommentsFormBlocStateLoaded) {
          body = renderLoaded(context);
        } else if (state is CommentsFormBlocStateLoading) {
          body = Stack(
            children: [
              renderLoaded(context),
              FullscreenLoading(),
            ],
          );
        }
        return Scaffold(
          appBar: SGLAppBar(
            'Comments',
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            iconColor: Colors.black,
            elevation: 2,
          ),
          body: AnimatedSwitcher(
              duration: Duration(milliseconds: 200), child: body),
        );
      }),
    );
  }

  Widget renderLoaded(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: AnimatedList(
          key: listKey,
          controller: scrollController,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) =>
                  FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                          sizeFactor: animation,
                          child: CommentView(
                              comment: comments[index], first: index == 0))),
          initialItemCount: comments.length,
        )),
        renderInputContainer(context),
      ],
    );
  }

  Widget renderInputContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 1,
          color: Color(0xffcdcdcd),
          margin: EdgeInsets.only(bottom: 10.0),
        ),
        Text(
          'What kind of post do you want to do?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xff787878), fontSize: 17),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            renderType(context, 'Comment', 'assets/feed_card/icon_comment.png',
                'COMMENT'),
            renderType(context, 'Tips&tricks', 'assets/feed_card/icon_tips.png',
                'TIPS'),
            renderType(context, 'Diagnosis',
                'assets/feed_card/icon_diagnosis.png', 'DIAGNOSIS'),
            renderType(context, 'Recommend',
                'assets/feed_card/icon_recommend.png', 'RECOMMEND'),
          ],
        ),
        renderInput(context),
      ],
    );
  }

  Widget renderInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          UserAvatar(
            icon: 'assets/feed_card/icon_noavatar.png',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black26),
                  borderRadius: BorderRadius.circular(25.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: TextField(
                        focusNode: inputFocus,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add a comment as stant...'),
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: 17),
                        minLines: 1,
                        maxLines: 4,
                        controller: textEditingController,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<CommentsFormBloc>(context).add(
                          CommentsFormBlocEventPostComment(
                              textEditingController.text, type));
                      FocusScope.of(context).unfocus();
                      textEditingController.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text('Post',
                          style: TextStyle(
                              color: Color(0xff001AFF),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderType(
      BuildContext context, String name, String icon, String type) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
                color: Color(0xff474747),
                fontSize: 16,
                fontWeight:
                    this.type == type ? FontWeight.bold : FontWeight.normal),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(
                    width: this.type == type ? 2 : 1,
                    color: this.type == type
                        ? Color(0xff3bb30b)
                        : Color(0xffbdbdbd)),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: InkWell(
              onTap: () {
                setState(() {
                  this.type = type;
                  inputFocus.requestFocus();
                });
              },
              child: Image.asset(icon, width: 25, height: 25),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    inputFocus.dispose();
    super.dispose();
  }
}
