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
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';

class FeedVentilationLegacyFormPage extends StatefulWidget {
  final FeedVentilationFormBlocStateLoaded state;

  const FeedVentilationLegacyFormPage(this.state, {Key key}) : super(key: key);

  @override
  _FeedVentilationLegacyFormPageState createState() =>
      _FeedVentilationLegacyFormPageState();
}

class _FeedVentilationLegacyFormPageState
    extends State<FeedVentilationLegacyFormPage> {
  int _blowerDay = 0;
  int _blowerNight = 0;

  @override
  void initState() {
    _blowerDay = widget.state.blowerDay.value;
    _blowerNight = widget.state.blowerNight.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: BlocProvider.of<FeedVentilationFormBloc>(context),
        listener: (BuildContext context, FeedVentilationFormBlocState state) {
          if (state is FeedVentilationFormBlocStateLoaded) {
            setState(() {
              _blowerDay = state.blowerDay.value;
              _blowerNight = state.blowerNight.value;
            });
          }
        },
        child: ListView(
          children: [
            SliderFormParam(
              key: Key('day'),
              title: 'Blower day',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _blowerDay.toDouble(),
              min: 0,
              max: 100,
              color: Colors.yellow,
              onChanged: (double newValue) {
                setState(() {
                  _blowerDay = newValue.toInt();
                });
              },
              onChangeEnd: (double newValue) {
                BlocProvider.of<FeedVentilationFormBloc>(context).add(
                    FeedVentilationFormBlocParamsChangedEvent(
                        blowerDay: widget.state.blowerDay
                            .copyWith(value: _blowerDay)));
              },
            ),
            SliderFormParam(
              key: Key('night'),
              title: 'Blower night',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _blowerNight.toDouble(),
              min: 0,
              max: 100,
              color: Colors.blue,
              onChanged: (double newValue) {
                setState(() {
                  _blowerNight = newValue.toInt();
                });
              },
              onChangeEnd: (double newValue) {
                BlocProvider.of<FeedVentilationFormBloc>(context).add(
                    FeedVentilationFormBlocParamsChangedEvent(
                        blowerNight: widget.state.blowerNight
                            .copyWith(value: _blowerNight)));
              },
            ),
          ],
        ));
  }
}
