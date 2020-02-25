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
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedLightCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedLightCardBloc, FeedLightCardBlocState>(
        bloc: BlocProvider.of<FeedLightCardBloc>(context),
        builder: (context, state) => FeedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedCardTitle('assets/feed_card/icon_light.svg',
                      'Stretch control', state.feedEntry),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FeedCardDate(state.feedEntry),
                  ),
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'From:',
                          style: TextStyle(fontSize: 20),
                        ),
                        _renderValues(state.params['initialValues']),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            'To:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        _renderValues(state.params['values']),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget _renderValues(List<dynamic> values) {
    return Text(
      '${values.map((v) => '$v%').join(', ')}',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff3bb30b)),
    );
  }
}
