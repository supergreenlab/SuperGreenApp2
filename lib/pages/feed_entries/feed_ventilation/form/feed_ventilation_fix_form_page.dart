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

class FeedVentilationFixFormPage extends StatefulWidget {
  final FeedVentilationFormBlocStateLoaded state;

  const FeedVentilationFixFormPage(this.state, {Key key}) : super(key: key);

  @override
  _FeedVentilationFixFormPageState createState() =>
      _FeedVentilationFixFormPageState();
}

class _FeedVentilationFixFormPageState
    extends State<FeedVentilationFixFormPage> {
  int _blowerValue = 0;

  @override
  void initState() {
    _blowerValue = widget.state.blowerMin.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: BlocProvider.of<FeedVentilationFormBloc>(context),
        listener: (BuildContext context, FeedVentilationFormBlocState state) {
          if (state is FeedVentilationFormBlocStateLoaded) {
            setState(() {
              _blowerValue = state.blowerMin.value;
            });
          }
        },
        child: ListView(
          children: [
            SliderFormParam(
              key: Key('blower_value'),
              title: 'Blower value',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _blowerValue.toDouble(),
              min: 0,
              max: 100,
              color: Colors.yellow,
              onChanged: (double newValue) {
                setState(() {
                  _blowerValue = newValue.toInt();
                });
              },
              onChangeEnd: (double newValue) {
                BlocProvider.of<FeedVentilationFormBloc>(context).add(
                    FeedVentilationFormBlocParamsChangedEvent(
                        blowerMin: widget.state.blowerMin
                            .copyWith(value: _blowerValue)));
              },
            ),
          ],
        ));
  }
}
