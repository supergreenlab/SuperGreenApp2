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
  final Animation animation;

  const FeedWaterCardPage(this.animation, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedWaterCardBloc, FeedWaterCardBlocState>(
        bloc: BlocProvider.of<FeedWaterCardBloc>(context),
        builder: (context, state) {
          List<Widget> body = [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '${state.params['volume']}L',
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3bb30b)),
              ),
            ),
          ];
          if (state.params['tooDry'] != null ||
              state.params['nutrient'] != null) {
            List<Widget> details = [];
            if (state.params['tooDry'] != null) {
              details.add(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Was Dry: ${state.params['tooDry'] == true ? 'YES' : 'NO'}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ));
            }
            if (state.params['nutrient'] != null) {
              details.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'With nutes: ${state.params['nutrient'] == true ? 'YES' : 'NO'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            body.add(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details,
            ));
          }
          return FeedCard(
            animation: animation,
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
                  height: 110,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: body),
                ),
              ],
            ),
          );
        });
  }
}
