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
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedWaterCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedWaterCardBloc, FeedWaterCardBlocState>(
        bloc: BlocProvider.of<FeedWaterCardBloc>(context),
        builder: (context, state) {
          List<Widget> body = [
            Text(
              '${state.params['volume']}L',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3bb30b)),
            ),
          ];
          if (state.params['tooDry'] != null ||
              state.params['nutrient'] != null) {
            List<Widget> rowBody = [];
            if (state.params['tooDry'] != null) {
              rowBody.add(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Dried: ${state.params['tooDry'] == true ? 'yes' : 'no'}',
                  style: TextStyle(fontSize: 20),
                ),
              ));
            }
            if (state.params['nutrient'] != null) {
              rowBody.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nutes: ${state.params['nutrient'] == true ? 'yes' : 'no'}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            }
            body.add(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rowBody,
            ));
          }
          return FeedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FeedCardTitle('assets/feed_card/icon_watering.svg', 'Watering',
                    state.feedEntry),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FeedCardDate(state.feedEntry),
                ),
                Container(
                  height: 150,
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: body),
                ),
              ],
            ),
          );
        });
  }
}
