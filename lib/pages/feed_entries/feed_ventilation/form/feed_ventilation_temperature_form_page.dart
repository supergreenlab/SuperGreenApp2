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

class FeedVentilationTemperatureFormPage extends StatefulWidget {
  final FeedVentilationFormBlocStateLoaded state;

  const FeedVentilationTemperatureFormPage(this.state, {Key key})
      : super(key: key);

  @override
  _FeedVentilationTemperatureFormPageState createState() =>
      _FeedVentilationTemperatureFormPageState();
}

class _FeedVentilationTemperatureFormPageState
    extends State<FeedVentilationTemperatureFormPage> {
  int _blowerMin = 0;
  int _blowerMax = 0;
  int _blowerRefMin = 0;
  int _blowerRefMax = 0;
  int _blowerRefSource = 0;

  @override
  void initState() {
    _blowerMin = widget.state.blowerMin.value;
    _blowerMax = widget.state.blowerMax.value;
    _blowerRefMin = widget.state.blowerRefMin.value;
    _blowerRefMax = widget.state.blowerRefMax.value;
    _blowerRefSource = widget.state.blowerRefSource.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: BlocProvider.of<FeedVentilationFormBloc>(context),
        listener: (BuildContext context, FeedVentilationFormBlocState state) {
          if (state is FeedVentilationFormBlocStateLoaded) {
            setState(() {
              _blowerMin = state.blowerMin.value;
              _blowerMax = state.blowerMax.value;
              _blowerRefMin = state.blowerRefMin.value;
              _blowerRefMax = state.blowerRefMax.value;
              _blowerRefSource = state.blowerRefSource.value;
            });
          }
        },
        child: ListView(
          children: [
            SliderFormParam(
              key: Key('max'),
              title: 'Blower min',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _blowerMin.toDouble(),
              min: 0,
              max: 100,
              color: Colors.yellow,
              onChanged: (double newValue) {
                setState(() {
                  _blowerMin = newValue.toInt();
                });
              },
              onChangeEnd: (double newValue) {
                BlocProvider.of<FeedVentilationFormBloc>(context).add(
                    FeedVentilationFormBlocParamsChangedEvent(
                        blowerMin: widget.state.blowerMin
                            .copyWith(value: _blowerMin)));
              },
            ),
            SliderFormParam(
              key: Key('max'),
              title: 'Blower max',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _blowerMax.toDouble(),
              min: 0,
              max: 100,
              color: Colors.blue,
              onChanged: (double newValue) {
                setState(() {
                  _blowerMax = newValue.toInt();
                });
              },
              onChangeEnd: (double newValue) {
                BlocProvider.of<FeedVentilationFormBloc>(context).add(
                    FeedVentilationFormBlocParamsChangedEvent(
                        blowerMax: widget.state.blowerMax
                            .copyWith(value: _blowerMax)));
              },
            ),
          ],
        ));
  }
}
