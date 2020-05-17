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
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedMediaCardPage extends StatefulWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;

  const FeedMediaCardPage(this.animation, this.feedState, this.state, {Key key})
      : super(key: key);

  @override
  _FeedMediaCardPageState createState() => _FeedMediaCardPageState();
}

class _FeedMediaCardPageState extends State<FeedMediaCardPage> {
  bool editText = false;

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
          FeedCardTitle('assets/feed_card/icon_schedule.svg', 'Schedule change',
              widget.state.synced),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedMediaState state) {
    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
            'assets/feed_card/icon_media.svg',
            'Grow log',
            state.synced,
            onEdit: () {
              setState(() {
                editText = true;
              });
            },
          ),
          state.medias.length > 0
              ? MediaList(
                  state.medias,
                  onMediaTapped: (media) {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToFullscreenMedia(media));
                  },
                )
              : Container(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: FeedCardDate(state.date),
          ),
          FeedCardText(
            state.params.message ?? '',
            edit: editText,
            onEdited: (value) {
              //BlocProvider.of<FeedMediaCardBloc>(context)
              //    .add(FeedMediaCardBlocEventEdit(value));
              setState(() {
                editText = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
