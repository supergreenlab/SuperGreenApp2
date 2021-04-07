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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/pages/explorer/models/plants.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:tuple/tuple.dart';

class PlantPhase extends StatelessWidget {
  final PublicPlant plant;

  const PlantPhase({Key key, this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String germinationText = 'Not set.';
    if (plant.settings.germinationDate != null) {
      Duration diff = DateTime.now().difference(plant.settings.germinationDate);
      germinationText = renderDuration(diff);
    }
    String phaseTitle;
    String bloomingText = 'Not set.';
    Tuple3<PlantPhases, DateTime, Duration> phaseData = plant.settings.phaseAt(DateTime.now());
    if (phaseData != null && phaseData.item1 != PlantPhases.GERMINATING) {
      List<String> phases = [
        'Germinated:',
        'Vegging for:',
        'Blooming for:',
        'Drying for:',
        'Curing for:',
      ];
      phaseTitle = phases[phaseData.item1.index];
      bloomingText = renderDuration(phaseData.item3);
    }
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 8.0),
            child: SvgPicture.asset("assets/explorer/icon_phase.svg", width: 40, height: 40),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('Germinated: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    Text(germinationText,
                        style: TextStyle(
                          fontSize: 15,
                        )),
                  ],
                ),
                phaseTitle != null
                    ? Row(
                        children: [
                          Text(phaseTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text(bloomingText),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TODO DRY with feed_card_date.dart
  String renderSincePhase() {
    Tuple3<PlantPhases, DateTime, Duration> phaseData = plant.settings.phaseAt(DateTime.now());
    if (phaseData == null) {
      return 'Life events not set.';
    }
    List<String Function(Duration)> phases = [
      (Duration diff) => 'Germinated ${renderDuration(phaseData.item3)}',
      (Duration diff) => 'Vegging for ${renderDuration(phaseData.item3, suffix: '')}',
      (Duration diff) => 'Blooming for ${renderDuration(phaseData.item3, suffix: '')}',
      (Duration diff) => 'Drying for ${renderDuration(phaseData.item3, suffix: '')}',
      (Duration diff) => 'Curing for ${renderDuration(phaseData.item3, suffix: '')}'
    ];
    return phases[phaseData.item1.index](phaseData.item3);
  }

  String renderDuration(Duration diff, {suffix = ' ago'}) {
    int minuteDiff = diff.inMinutes;
    int hourDiff = diff.inHours;
    int dayDiff = diff.inDays;
    String format;
    if (minuteDiff < 1) {
      format = 'few seconds$suffix';
    } else if (minuteDiff < 60) {
      format = '$minuteDiff minute${minuteDiff > 1 ? 's' : ''}$suffix';
    } else if (hourDiff < 24) {
      format = '$hourDiff hour${hourDiff > 1 ? 's' : ''}$suffix';
    } else {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''}$suffix';
    }
    return format;
  }
}
