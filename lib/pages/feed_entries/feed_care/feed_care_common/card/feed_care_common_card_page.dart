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
import 'package:super_green_app/pages/feed_entries/entry_params/feed_care.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/media_list.dart';

abstract class FeedCareCommonCardPage extends StatefulWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;

  const FeedCareCommonCardPage(this.animation, this.feedState, this.state,
      {Key key})
      : super(key: key);

  @override
  _FeedCareCommonCardPageState createState() => _FeedCareCommonCardPageState();

  String title();

  String iconPath();
}

class _FeedCareCommonCardPageState extends State<FeedCareCommonCardPage> {
  bool editText;

  @override
  Widget build(BuildContext context) {
    if (widget.state is FeedEntryStateLoaded) {
      return _renderLoaded(context, widget.state);
    }
    return _renderLoading(context);
  }

  Widget _renderLoading(BuildContext context) {
    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(widget.iconPath(), widget.title(), widget.state.synced),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(widget.state.date),
          ),
          Container(
            height: 700,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedCareCommonState state) {
    FeedCareParams params = state.params;
    List<Widget> body = [
      FeedCardTitle(
        widget.iconPath(),
        widget.title(),
        widget.state.synced,
        onEdit: () {
          setState(() {
            editText = true;
          });
        },
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FeedCardDate(widget.state.date),
      ),
      FeedCardText(
        params.message ?? '',
        edit: editText,
        onEdited: (value) {
          BlocProvider.of<FeedBloc>(context).add(FeedBlocEventEditParams(
              state.feedEntryID, params.copyWith(value)));
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
              BlocProvider.of<MainNavigatorBloc>(context).add(
                  MainNavigateToFullscreenMedia(
                      media.thumbnailPath, media.filePath));
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
                BlocProvider.of<MainNavigatorBloc>(context).add(
                    MainNavigateToFullscreenMedia(
                        media.thumbnailPath, media.filePath));
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
  }
}
