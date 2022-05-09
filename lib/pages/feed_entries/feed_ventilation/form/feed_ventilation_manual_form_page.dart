/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';

class FeedVentilationManualFormPage extends TraceableStatefulWidget {
  static String get instructionsManualTimerModeDescription {
    return Intl.message(
      'This is the **manual blower control** mode, just set a value and the blower will stay at this power.',
      name: 'instructionsManualTimerModeDescription',
      desc: 'Instructions for blower manual mode',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final FeedVentilationFormBlocStateLoaded state;

  const FeedVentilationManualFormPage(this.state, {Key? key}) : super(key: key);

  @override
  _FeedVentilationManualFormPageState createState() => _FeedVentilationManualFormPageState();
}

class _FeedVentilationManualFormPageState extends State<FeedVentilationManualFormPage> {
  int _blowerValue = 0;

  @override
  void initState() {
    _blowerValue = widget.state.minMaxParams!.blowerMin.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<FeedVentilationFormBloc>(context),
        listener: (BuildContext context, FeedVentilationFormBlocState state) {
          if (state is FeedVentilationFormBlocStateLoaded) {
            setState(() {
              _blowerValue = state.minMaxParams!.blowerMin.value;
            });
          }
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MarkdownBody(
                data: FeedVentilationManualFormPage.instructionsManualTimerModeDescription,
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
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
                BlocProvider.of<FeedVentilationFormBloc>(context).add(FeedVentilationFormBlocParamsChangedEvent(
                  minMaxController: widget.state.minMaxParams!.copyWithValues({
                    "blowerMin": _blowerValue,
                  }) as MinMaxParamsController,
                ));
              },
            ),
          ],
        ));
  }
}
