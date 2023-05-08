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
import 'package:super_green_app/data/rel/rel_db.dart';
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

  final Param humidity;
  final Param temperature;
  final VentilationParamsController paramsController;

  const FeedVentilationManualFormPage(this.humidity, this.temperature, this.paramsController, {Key? key}) : super(key: key);

  @override
  _FeedVentilationManualFormPageState createState() => _FeedVentilationManualFormPageState();
}

class _FeedVentilationManualFormPageState extends State<FeedVentilationManualFormPage> {
  int _value = 0;

  @override
  void didChangeDependencies() {
    _value = widget.paramsController.min.value;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          value: _value.toDouble(),
          min: 0,
          max: 100,
          color: Colors.yellow,
          onChanged: (double newValue) {
            setState(() {
              _value = newValue.toInt();
            });
          },
          onChangeEnd: (double newValue) {
            BlocProvider.of<FeedVentilationFormBloc>(context).add(FeedVentilationFormBlocParamsChangedEvent(
              blowerParamsController: widget.paramsController.copyWithValues({
                "min": _value,
              }) as BlowerParamsController,
            ));
          },
        ),
      ],
    );
  }
}
