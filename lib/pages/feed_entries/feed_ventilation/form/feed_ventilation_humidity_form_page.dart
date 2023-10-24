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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/number_form_param.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';

class FeedVentilationHumidityFormPage extends StatefulWidget {
  static String get instructionsBlowerHumidityModeDescription {
    return Intl.message(
      '''This is the **Humidity based blower control**, in this mode the blower is **in sync with the box humidity sensor**.''',
      name: 'instructionsBlowerHumidityModeDescription',
      desc: 'Instructions for blower humidity mode',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get instructionsFanHumidityModeDescription {
    return Intl.message(
      '''This is the **Humidity based fan control**, in this mode the fan is **in sync with the box humidity sensor**.\n\nMake sure your motor port is configured in the settings.''',
      name: 'instructionsFanHumidityModeDescription',
      desc: 'Instructions for fan humidity mode',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  String get instructionsHumidityModeDescription => paramsController is BlowerParamsController ? FeedVentilationHumidityFormPage.instructionsBlowerHumidityModeDescription : FeedVentilationHumidityFormPage.instructionsFanHumidityModeDescription;

  final Param humidity;
  final Param temperature;
  final VentilationParamsController paramsController;

  const FeedVentilationHumidityFormPage(this.humidity, this.temperature, this.paramsController, {Key? key}) : super(key: key);

  @override
  _FeedVentilationHumidityFormPageState createState() => _FeedVentilationHumidityFormPageState();
}

class _FeedVentilationHumidityFormPageState extends State<FeedVentilationHumidityFormPage> {
  int _min = 0;
  int _max = 0;
  int _refMin = 0;
  int _refMax = 0;
  int? _previousHashCode;

  void refreshParamsController() {
    if (widget.paramsController.hashCode == this._previousHashCode) { // WTF is there anything better, keeping the object reference would change that reference without assignment oO
      return;
    }
    setState(() {
      this._previousHashCode = widget.paramsController.hashCode;
      _min = widget.paramsController.min.value;
      _max = widget.paramsController.max.value;
      _refMin = widget.paramsController.refMin.value;
      _refMax = widget.paramsController.refMax.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.refreshParamsController();
    String unit = '%';
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownBody(
            data: widget.instructionsHumidityModeDescription,
            styleSheet: MarkdownStyleSheet(p: TextStyle(color: Color(0xff454545), fontSize: 16)),
          ),
        ),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      Text(
                        'Low ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
                      ),
                      Text(
                        'humidity settings',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                      ),
                    ]),
                    Text('Current box humidity: ${widget.humidity.ivalue}$unit'),
                  ],
                )),
            NumberFormParam(
              title: 'Humidity low',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _refMin.toDouble(),
              unit: unit,
              displayFn: (v) => '$v',
              step: 1,
              onChange: (double newValue) {
                setState(() {
                  _refMin = newValue.toInt();
                });
                BlocProvider.of<FeedVentilationFormBloc>(context).add(FeedVentilationFormBlocParamsChangedEvent(
                  paramsController: widget.paramsController.copyWithValues({
                    "refMin": newValue.toInt(),
                  }) as FeedVentilationParamsController,
                ));
              },
            ),
            SliderFormParam(
              key: Key('blower_humi_min'),
              title: 'Power at ${_refMin.toDouble()}$unit',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _min.toDouble(),
              min: 0,
              max: 100,
              color: Colors.blue,
              onChanged: (double newValue) {
                setState(() {
                  _min = newValue.toInt();
                });
              },
              onChangeEnd: (double newValue) {
                BlocProvider.of<FeedVentilationFormBloc>(context).add(FeedVentilationFormBlocParamsChangedEvent(
                    paramsController: widget.paramsController.copyWithValues({
                  "min": _min,
                }) as FeedVentilationParamsController));
              },
            ),
          ],
        ),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      Text(
                        'High ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
                      ),
                      Text(
                        'humidity settings',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                      ),
                    ]),
                    Text('Current box humidity: ${widget.humidity.ivalue}$unit'),
                  ],
                )),
            NumberFormParam(
              title: 'Humidity high',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _refMax.toDouble(),
              unit: unit,
              displayFn: (v) => '$v',
              step: 1,
              onChange: (double newValue) {
                setState(() {
                  _refMax = newValue.toInt();
                });
                BlocProvider.of<FeedVentilationFormBloc>(context).add(
                  FeedVentilationFormBlocParamsChangedEvent(
                      paramsController: widget.paramsController.copyWithValues({
                    "refMax": newValue.toInt(),
                  }) as FeedVentilationParamsController),
                );
              },
            ),
            SliderFormParam(
              key: Key('blower_humi_max'),
              title: 'Power at ${_refMax.toDouble()}$unit',
              icon: 'assets/feed_form/icon_blower.svg',
              value: _max.toDouble(),
              min: 0,
              max: 100,
              color: Colors.yellow,
              onChanged: (double newValue) {
                setState(() {
                  _max = newValue.toInt();
                });
              },
              onChangeEnd: (double newValue) {
                BlocProvider.of<FeedVentilationFormBloc>(context).add(FeedVentilationFormBlocParamsChangedEvent(
                  paramsController: widget.paramsController.copyWithValues({
                    "max": _max,
                  }) as FeedVentilationParamsController,
                ));
              },
            ),
          ],
        ),
      ],
    );
  }
}
