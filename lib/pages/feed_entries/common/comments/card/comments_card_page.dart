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
import 'package:super_green_app/pages/feed_entries/common/comments/card/comments_card_bloc.dart';

class CommentsCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCardBloc, CommentsCardBlocState>(
      builder: (BuildContext context, CommentsCardBlocState state) {
        if (state is CommentsCardBlocStateInit) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Loading..'),
          );
        } else if (state is CommentsCardBlocStateNotSynced) {
          return Container();
        }
        return renderLoaded(context, state);
      },
    );
  }

  Widget renderLoaded(BuildContext context, CommentsCardBlocStateLoaded state) {
    return InkWell(
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(MainNavigateToCommentFormEvent(state.feedEntry));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text('pouet'),
      ),
    );
  }
}
