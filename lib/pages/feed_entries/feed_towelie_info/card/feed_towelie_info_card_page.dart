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
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_towelie_info.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedTowelieInfoCardPage extends StatelessWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;
  final List<Widget> Function(FeedEntryState feedEntryState) cardActions;

  const FeedTowelieInfoCardPage(this.animation, this.feedState, this.state,
      {Key key, this.cardActions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedEntryStateLoaded) {
      return _renderLoaded(context, state);
    }
    return _renderLoading(context);
  }

  Widget _renderLoading(BuildContext context) {
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              'assets/feed_card/icon_towelie.png', 'Towelie', state.synced,
              actions: cardActions != null ? cardActions(state) : []),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, feedState),
          ),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedTowelieInfoState state) {
    FeedTowelieInfoParams params = state.params;
    List<Widget> content = [
      FeedCardTitle(
          'assets/feed_card/icon_towelie.png', 'Towelie', state.synced),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 24.0),
        child: _renderBody(context, state),
      ),
    ];
    if (params.selectedButton != null) {
      content.add(_renderSelectedButton(context, params.selectedButton));
    } else if (params.buttons != null && params.buttons.length > 0) {
      content.add(_renderButtonBar(context, params.buttons));
    }
    return FeedCard(
        animation: animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: content,
        ));
  }

  Widget _renderBody(BuildContext context, FeedTowelieInfoState state) {
    FeedTowelieInfoParams params = state.params;
    final body = <Widget>[
      FeedCardText(params.text),
    ];
    if (params.topPic != null) {
      body.insert(
          0,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SvgPicture.asset(params.topPic),
          ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: body,
    );
  }

  ButtonBar _renderButtonBar(
      BuildContext context, List<FeedTowelieParamsButton> buttons) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      buttonPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      children: buttons.map((b) => _renderButton(context, b)).toList(),
    );
  }

  Widget _renderButton(BuildContext context, FeedTowelieParamsButton button) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      child: Text(button.title.toUpperCase(),
          style: TextStyle(color: Colors.blue, fontSize: 12)),
      onPressed: () {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventButtonPressed(
            button.params,
            feed: state.feedID,
            feedEntry: state.feedEntryID));
      },
    );
  }

  Widget _renderSelectedButton(
      BuildContext context, FeedTowelieParamsButton button) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 24),
      child: Text('➡️ ${button.title.toUpperCase()}',
          style: TextStyle(
              color: Color(0xff565656),
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }
}
