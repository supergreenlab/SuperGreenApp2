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
import 'package:super_green_app/pages/feed_entries/feed_water/form/feed_water_form_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/number_form_param.dart';
import 'package:super_green_app/widgets/feed_form/yesno_form_param.dart';

class FeedWaterFormPage extends StatefulWidget {
  @override
  _FeedWaterFormPageState createState() => _FeedWaterFormPageState();
}

class _FeedWaterFormPageState extends State<FeedWaterFormPage> {
  bool tooDry;
  double volume = 1;
  bool nutrient;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<FeedWaterFormBloc>(context),
        listener: (BuildContext context, FeedWaterFormBlocState state) {
          if (state is FeedWaterFormBlocStateDone) {
            BlocProvider.of<TowelieBloc>(context).add(
                TowelieBlocEventFeedEntryCreated(state.box, state.feedEntry));
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(mustPop: true));
          }
        },
        child: BlocBuilder<FeedWaterFormBloc, FeedWaterFormBlocState>(
          bloc: BlocProvider.of<FeedWaterFormBloc>(context),
          builder: (context, state) => FeedFormLayout(
            title: 'New watering record',
            body: ListView(
              children: <Widget>[
                YesNoFormParam(
                    icon: 'assets/feed_form/icon_dry.svg',
                    title: 'Was it too dry?',
                    yes: tooDry,
                    onPressed: (yes) {
                      setState(() {
                        tooDry = yes;
                      });
                    }),
                NumberFormParam(
                    icon: 'assets/feed_form/icon_volume.svg',
                    title: 'Approx. volume',
                    value: volume,
                    unit: 'L',
                    onChange: (newValue) {
                      setState(() {
                        if (newValue > 0) {
                          volume = newValue;
                        }
                      });
                    }),
                YesNoFormParam(
                    icon: 'assets/feed_form/icon_nutrient.svg',
                    title: 'Nutrient?',
                    yes: nutrient,
                    onPressed: (yes) {
                      setState(() {
                        nutrient = yes;
                      });
                    }),
              ],
            ),
            onOK: () => BlocProvider.of<FeedWaterFormBloc>(context).add(
              FeedWaterFormBlocEventCreate(tooDry, volume, nutrient),
            ),
          ),
        ));
  }
}
