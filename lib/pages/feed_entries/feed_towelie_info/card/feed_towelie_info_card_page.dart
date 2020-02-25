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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedTowelieInfoCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedTowelieInfoCardBloc, FeedTowelieInfoCardBlocState>(
        bloc: BlocProvider.of<FeedTowelieInfoCardBloc>(context),
        builder: (context, state) {
          List<Widget> content = [
            FeedCardTitle('assets/feed_card/icon_towelie.png', 'Towelie',
                state.feedEntry),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
              child: _renderBody(context, state),
            ),
          ];
          if (state.params['buttons'] != null &&
              state.params['buttons'].length > 0) {
            content.add(_renderButtonBar(context, state.params['buttons']));
          }
          return FeedCard(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: content,
          ));
        });
  }

  Widget _renderBody(BuildContext context, FeedTowelieInfoCardBlocState state) {
    final body = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        child: Text(state.params['text']),
      ),
    ];
    if (state.params['top_pic'] != null) {
      body.insert(0, Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: SvgPicture.asset(state.params['top_pic']),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: body,
    );
  }

  ButtonBar _renderButtonBar(BuildContext context, List buttons) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      buttonPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      children: buttons.map((b) => _renderButtonFromName(context, b)).toList(),
    );
  }

  Widget _renderButtonFromName(
      BuildContext context, Map<String, dynamic> button) {
    if (button['type'] == 'CREATE_BOX') {
      return FlatButton(
        child: Text(button['title'], style: TextStyle(color: Colors.blue)),
        onPressed: () {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToNewBoxInfosEvent());
        },
      );
    }
    return Text('NO_SUCH_BUTTON');
  }
}
