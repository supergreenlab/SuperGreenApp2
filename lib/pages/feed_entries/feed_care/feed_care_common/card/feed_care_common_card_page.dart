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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/media_list.dart';

abstract class FeedCareCommonCardPage<CardBloc extends FeedCareCommonCardBloc>
    extends StatefulWidget {
  final Animation animation;

  const FeedCareCommonCardPage(this.animation, {Key key}) : super(key: key);

  @override
  _FeedCareCommonCardPageState<CardBloc> createState() =>
      _FeedCareCommonCardPageState<CardBloc>();

  String title();

  String iconPath();
}

class _FeedCareCommonCardPageState<CardBloc extends FeedCareCommonCardBloc>
    extends State<FeedCareCommonCardPage<CardBloc>> {
  bool editText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardBloc, FeedCareCommonCardBlocState>(
        bloc: BlocProvider.of<CardBloc>(context),
        builder: (context, state) {
          List<Widget> body = [
            FeedCardTitle(
              widget.iconPath(),
              widget.title(),
              state.feedEntry,
              onEdit: () {
                setState(() {
                  editText = true;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FeedCardDate(state.feedEntry),
            ),
            FeedCardText(
              state.params['message'] ?? '',
              edit: editText,
              onEdited: (value) {
                BlocProvider.of<CardBloc>(context)
                    .add(FeedCareCommonCardBlocEventEdit(value));
                setState(() {
                  editText = false;
                });
              },
            )
          ];
          if (state.beforeMedias.length > 0) {
            body.insert(
              1,
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MediaList(
                  state.beforeMedias,
                  prefix: 'Before ',
                  onMediaTapped: (media) {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToFullscreenMedia(media));
                  },
                ),
              ),
            );
          }
          if (state.afterMedias.length > 0) {
            body.insert(
                1,
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: MediaList(
                    state.afterMedias,
                    prefix: 'After ',
                    onMediaTapped: (media) {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigateToFullscreenMedia(media));
                    },
                  ),
                ));
          }
          return FeedCard(
            animation: widget.animation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: body,
            ),
          );
        });
  }
}
