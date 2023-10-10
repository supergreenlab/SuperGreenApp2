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
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/section_title.dart';

class FeedVentilationCardV3Values {

  final String type;
  final int refSource;
  final int refMin;
  final int refMax;
  final int min;
  final int max;

  FeedVentilationCardV3Values(this.type, this.refSource, this.refMin, this.refMax, this.min, this.max);

}

class FeedVentilationCardV3 extends StatelessWidget {

  final FeedVentilationCardV3Values values;

  FeedVentilationCardV3({Key? key, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTempSource(values.refSource)) {
      return _renderTemperatureMode();
    }
    if (isHumiSource(values.refSource)) {
      return _renderHumidityMode();
    } else if (isTimerSource(values.refSource)) {
      return _renderTimerMode();
    } else if (values.refSource == 0) {
      return _renderManualMode();
    }
    return Fullscreen(
      child: Icon(Icons.upgrade),
      title: FeedVentilationCardPage.feedVentilationCardPageUpgrade,
    );
  }

  Widget _renderTemperatureMode() {
    String unit = AppDB().getUserSettings().freedomUnits == true ? '°F' : '°C';
    List<Widget> cards = [
      renderCard(
          FeedEntryIcons[FE_VENTILATION]!,
          8,
          FeedVentilationCardPage.feedVentilationCardPageLowTempSettings,
          Column(
            children: [
              Text('${values.min}%',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.lightBlue)),
              Text('at ${_tempUnit(values.refMin.toDouble())}$unit',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
            ],
          )),
      renderCard(
          FeedEntryIcons[FE_VENTILATION]!,
          8,
          FeedVentilationCardPage.feedVentilationCardPageHighTempSettings,
          Column(
            children: [
              Text('${values.max}%',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.red)),
              Text('at ${_tempUnit(values.refMax.toDouble())}$unit',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
            ],
          )),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(FeedVentilationCardPage.feedVentilationCardPageTemperatureMode,
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      Container(
        height: 155,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards,
          ),
        ),
      )
    ]);
  }

  Widget _renderHumidityMode() {
    String unit = '%';

    List<Widget> cards = [
      renderCard(
          FeedEntryIcons[FE_VENTILATION]!,
          8,
          FeedVentilationCardPage.feedVentilationCardPageLowHumiSettings,
          Column(
            children: [
              Text('${values.min}%',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.lightBlue)),
              Text('at ${values.refMin.toDouble()}$unit',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
            ],
          )),
      renderCard(
          FeedEntryIcons[FE_VENTILATION]!,
          8,
          FeedVentilationCardPage.feedVentilationCardPageHighHumiSettings,
          Column(
            children: [
              Text('${values.max}%',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.red)),
              Text('at ${values.refMax.toDouble()}$unit',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
            ],
          )),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(FeedVentilationCardPage.feedVentilationCardPageHumidityMode,
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      Container(
        height: 155,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards,
          ),
        ),
      )
    ]);
  }

  Widget _renderTimerMode() {
    List<Widget> cards = [
      renderCard(
          FeedEntryIcons[FE_VENTILATION]!,
          8,
          FeedVentilationCardPage.feedVentilationCardPageNightSettings,
          Column(
            children: [
              Text('${values.min}%',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.blue)),
            ],
          )),
      renderCard(
          FeedEntryIcons[FE_VENTILATION]!,
          8,
          FeedVentilationCardPage.feedVentilationCardPageDaySettings,
          Column(
            children: [
              Text('${values.max}%',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.orange)),
            ],
          )),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(FeedVentilationCardPage.feedVentilationCardPageTimerMode,
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      Container(
        height: 130,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards,
          ),
        ),
      )
    ]);
  }

  Widget _renderManualMode() {
    List<Widget> cards = [
      renderCard(
          FeedEntryIcons[FE_VENTILATION]!,
          8,
          FeedVentilationCardPage.feedVentilationCardPagePower,
          Column(
            children: [
              Text('${values.min}%',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.grey)),
            ],
          )),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(FeedVentilationCardPage.feedVentilationCardPageManualMode,
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      Container(
        height: 130,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards,
          ),
        ),
      )
    ]);
  }



  Widget renderCard(String icon, double iconPadding, String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
          width: 200,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffdedede), width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              SectionTitle(
                icon: icon,
                iconPadding: iconPadding,
                title: title,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: child,
                ),
              )
            ],
          )),
    );
  }

  double _tempUnit(double temp) {
    if (AppDB().getUserSettings().freedomUnits == true) {
      return temp * 9 / 5 + 32;
    }
    return temp;
  }
}