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
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_date_input.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_dropdown_input.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_form.dart';

class PlantInfosPhaseSince extends StatefulWidget {
  final String phase;
  final DateTime date;

  final Function onCancel;
  final Function(String phase, DateTime date) onSubmit;

  PlantInfosPhaseSince(
      {@required this.phase,
      @required this.date,
      @required this.onCancel,
      @required this.onSubmit});

  @override
  _PlantInfosPhaseSinceState createState() => _PlantInfosPhaseSinceState();
}

class _PlantInfosPhaseSinceState extends State<PlantInfosPhaseSince> {
  String phase;
  DateTime date;

  @override
  void initState() {
    phase = widget.phase;
    date = widget.date ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String phaseTitle = 'Current phase';
    if (phase == 'VEG') {
      phaseTitle = 'Vegging since';
    } else if (phase == 'BLOOM') {
      phaseTitle = 'Blooming since';
    }
    return PlantInfosForm(
      title: phaseTitle,
      icon: 'icon_vegging_since.svg',
      onCancel: widget.onCancel,
      onSubmit: () {
        widget.onSubmit(phase, date);
      },
      child: Column(
        children: <Widget>[
          PlantInfosDropdownInput(
            labelText: 'Plant phase',
            hintText: 'Choose a phase',
            items: [
              ['VEG', 'Vegetative'],
              ['BLOOM', 'Blooming'],
            ],
            value: widget.phase,
            onChanged: (String newValue) {
              setState(() {
                phase = newValue;
              });
            },
          ),
          PlantInfosDateInput(
            hintText: 'Since: ',
            labelText: 'Pick a date',
            date: date,
            onChange: (DateTime date) {
              this.date = date;
            },
          ),
        ],
      ),
    );
  }
}
