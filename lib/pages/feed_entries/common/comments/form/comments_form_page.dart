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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsFormBloc, CommentsFormBlocState>(
        builder: (BuildContext context, CommentsFormBlocState state) {
      Widget body;
      if (state is CommentsFormBlocStateInit) {
        body = FullscreenLoading();
      } else if (state is CommentsFormBlocStateLoaded) {
        body = renderLoaded(context, state);
      }
      return Scaffold(
        appBar: SGLAppBar(
          'Comments',
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          iconColor: Colors.black,
          elevation: 2,
        ),
        body: body,
      );
    });
  }

  Widget renderLoaded(BuildContext context, CommentsFormBlocStateLoaded state) {
    List<Widget> children =
        state.comments.map((c) => CommentView(comment: c)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: AnimatedList(
          key: listKey,
          controller: scrollController,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) =>
                  children[index],
          initialItemCount: children.length,
        )),
        renderInputContainer(context, state),
      ],
    );
  }

  Widget renderInputContainer(
      BuildContext context, CommentsFormBlocStateLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'What kind of post do you want to do?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xff787878), fontSize: 17),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            renderType(
                context, state, 'Comment', 'assets/feed_card/icon_comment.png'),
            renderType(context, state, 'Tips&tricks',
                'assets/feed_card/icon_tips.png'),
            renderType(context, state, 'Diagnosis',
                'assets/feed_card/icon_diagnosis.png'),
            renderType(context, state, 'Recommend',
                'assets/feed_card/icon_recommend.png'),
          ],
        ),
        renderInput(context, state),
      ],
    );
  }

  Widget renderInput(BuildContext context, CommentsFormBlocStateLoaded state) {
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
                          horizontal: 20, vertical: 12.0),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: null,
                        style: TextStyle(fontSize: 18),
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<CommentsFormBloc>(context).add(
                          CommentsFormBlocEventPostComment(
                              textEditingController.text));
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

  Widget renderType(BuildContext context, CommentsFormBlocStateLoaded state,
      String name, String icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(color: Color(0xff474747), fontSize: 16),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffbdbdbd)),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: InkWell(
              child: Image.asset(icon, width: 25, height: 25),
            ),
          ),
        ],
      ),
    );
  }
}
