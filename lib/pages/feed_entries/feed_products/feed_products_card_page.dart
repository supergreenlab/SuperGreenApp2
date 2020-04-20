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
import 'package:super_green_app/pages/feed_entries/feed_products/feed_products_card_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedProductsCardPage extends StatelessWidget {
  final Animation animation;

  const FeedProductsCardPage(this.animation, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedProductsCardBloc, FeedProductsCardBlocState>(
        bloc: BlocProvider.of<FeedProductsCardBloc>(context),
        builder: (context, state) {
          List<Widget> content = [
            FeedCardTitle('assets/feed_card/icon_towelie.png', 'Towelie',
                state.feedEntry),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 24.0),
              child: _renderBody(context, state),
            ),
          ];
          if (state.params['buttons'] != null &&
              state.params['buttons'].length > 0) {
            content
                .add(_renderButtonBar(context, state, state.params['buttons']));
          } else if (state.params['selectedButton'] != null) {
            content.add(_renderSelectedButton(
                context, state, state.params['selectedButton']));
          }
          return FeedCard(
              animation: animation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: content,
              ));
        });
  }

  Widget _renderBody(BuildContext context, FeedProductsCardBlocState state) {
    final body = <Widget>[
      FeedCardText(state.params['text']),
    ];
    if (state.params['top_pic'] != null) {
      body.insert(
          0,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SvgPicture.asset(state.params['top_pic']),
          ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: body,
    );
  }

  ButtonBar _renderButtonBar(
      BuildContext context, FeedProductsCardBlocState state, List buttons) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      buttonPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      children: buttons.map((b) => _renderButton(context, state, b)).toList(),
    );
  }

  Widget _renderButton(BuildContext context, FeedProductsCardBlocState state,
      Map<String, dynamic> button) {
    return FlatButton(
      child: Text(button['title'].toUpperCase(),
          style: TextStyle(color: Colors.blue, fontSize: 12)),
      onPressed: () {
        BlocProvider.of<TowelieBloc>(context).add(
            TowelieBlocEventButtonPressed(
                button, feed: state.feed, feedEntry: state.feedEntry));
      },
    );
  }

  Widget _renderSelectedButton(BuildContext context,
      FeedProductsCardBlocState state, Map<String, dynamic> button) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 24),
      child: Text('➡️ ${button['title'].toUpperCase()}',
          style: TextStyle(color: Color(0xff565656), fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
