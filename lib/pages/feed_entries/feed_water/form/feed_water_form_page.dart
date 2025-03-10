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
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/form/feed_water_form_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_date_picker.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';
import 'package:super_green_app/widgets/feed_form/number_form_param.dart';
import 'package:super_green_app/widgets/feed_form/yesno_form_param.dart';

class FeedWaterFormPage extends StatefulWidget {
  @override
  _FeedWaterFormPageState createState() => _FeedWaterFormPageState();
}

class _FeedWaterFormPageState extends State<FeedWaterFormPage> {
  bool? tooDry;
  double volume = 1;
  bool? nutrient;
  late bool freedomUnits;
  bool wateringLab = false;
  DateTime date = DateTime.now();
  TextEditingController phController = TextEditingController();
  TextEditingController ecController = TextEditingController();
  TextEditingController tdsController = TextEditingController();

  final ScrollController listScrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    freedomUnits = AppDB().getUserSettings().freedomUnits == true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<FeedWaterFormBloc>(context),
        listener: (BuildContext context, FeedWaterFormBlocState state) {
          if (state is FeedWaterFormBlocStateDone) {
            BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, state.feedEntry));
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: state.feedEntry, mustPop: true));
          }
        },
        child: BlocBuilder<FeedWaterFormBloc, FeedWaterFormBlocState>(
            bloc: BlocProvider.of<FeedWaterFormBloc>(context),
            builder: (context, state) {
              return FeedFormLayout(
                title: '💧',
                fontSize: 35,
                body: ListView(
                  controller: listScrollController,
                  children: _renderBody(context, state),
                ),
                onOK: () => BlocProvider.of<FeedWaterFormBloc>(context).add(
                  FeedWaterFormBlocEventCreate(
                      date,
                      tooDry,
                      volume,
                      nutrient,
                      wateringLab,
                      phController.value.text == '' ? null : double.parse(phController.value.text.replaceAll(',', '.')),
                      ecController.value.text == '' ? null : double.parse(ecController.value.text.replaceAll(',', '.')),
                      tdsController.value.text == ''
                          ? null
                          : double.parse(tdsController.value.text.replaceAll(',', '.')),
                      messageController.text),
                ),
              );
            }));
  }

  List<Widget> _renderBody(BuildContext context, FeedWaterFormBlocState state) {
    return [
      FeedFormDatePicker(
        date,
        onChange: (DateTime? newDate) {
          setState(() {
            date = newDate!;
          });
        },
      ),
      NumberFormParam(
          icon: 'assets/feed_form/icon_volume.svg',
          title: 'Approx. volume',
          value: volume,
          step: 0.25,
          displayMultiplier: freedomUnits ? 0.25 : 1,
          unit: freedomUnits ? ' gal' : ' L',
          onChange: (newValue) {
            setState(() {
              if (newValue > 0) {
                volume = newValue;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child:
                renderOptionCheckbx(context, 'Watering all plants in the lab with the **same quantity**.', (newValue) {
              setState(() {
                wateringLab = newValue!;
              });
            }, wateringLab),
          )),
      YesNoFormParam(
          icon: 'assets/feed_form/icon_dry.svg',
          title: 'Was it too dry?',
          yes: tooDry,
          onPressed: (yes) {
            setState(() {
              tooDry = yes;
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
        },
        /*child: nutrient == true
                            ? renderNutrientList(context)
                            : Container()*/
      ),
      renderWaterMetrics(context),
      _renderTextrea(context, state),
    ];
  }

  Widget renderWaterMetrics(BuildContext context) {
    return FeedFormParamLayout(
        icon: 'assets/feed_form/icon_metrics.svg',
        title: 'End mix metrics',
        child: Container(
          height: 245,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 36.0),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text('PH:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: TextField(
                                    decoration: InputDecoration(hintText: 'ex: 6.5'),
                                    textCapitalization: TextCapitalization.words,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    controller: phController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            Text('EC (μS/cm):',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: TextField(
                                decoration: InputDecoration(hintText: 'ex: 1800'),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                controller: ecController,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('OR', style: TextStyle(fontSize: 20))),
                      Expanded(
                        child: Column(
                          children: [
                            Text('TDS (ppm):',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: TextField(
                                decoration: InputDecoration(hintText: 'ex: 1200'),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                controller: tdsController,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget renderNutrientList(BuildContext context) {
    return Text('');
  }

  Widget renderOptionCheckbx(BuildContext context, String text, Function(bool?) onChanged, bool value) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            onChanged: onChanged,
            value: value,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                onChanged(!value);
              },
              child: MarkdownBody(
                fitContent: true,
                data: text,
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderTextrea(BuildContext context, FeedWaterFormBlocState state) {
    return Container(
      height: 200,
      key: Key('TEXTAREA'),
      child: FeedFormParamLayout(
        title: 'Observations',
        icon: 'assets/feed_form/icon_note.svg',
        child: Expanded(
          child: FeedFormTextarea(
            textEditingController: messageController,
          ),
        ),
      ),
    );
  }
}
