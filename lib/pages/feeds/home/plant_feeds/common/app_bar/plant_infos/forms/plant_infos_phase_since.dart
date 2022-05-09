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
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/widgets/plant_infos_date_input.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/widgets/plant_infos_form.dart';

class PlantInfosPhaseSince extends StatefulWidget {
  final String title;
  final String icon;
  final DateTime? date;

  final Function onCancel;
  final Function(DateTime date) onSubmit;

  PlantInfosPhaseSince(
      {required this.title, required this.icon, required this.date, required this.onCancel, required this.onSubmit});

  @override
  _PlantInfosPhaseSinceState createState() => _PlantInfosPhaseSinceState();
}

class _PlantInfosPhaseSinceState extends State<PlantInfosPhaseSince> {
  late String title;
  late DateTime date;

  @override
  void initState() {
    title = widget.title;
    date = widget.date ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlantInfosForm(
      title: widget.title,
      icon: widget.icon,
      onCancel: widget.onCancel,
      onSubmit: () {
        widget.onSubmit(date);
      },
      child: Column(
        children: <Widget>[
          PlantInfosDateInput(
            hintText: 'Since: ',
            labelText: 'Pick a date',
            date: date,
            onChange: (DateTime? date) {
              if (date == null) return;
              setState(() {
                this.date = date;
              });
            },
          ),
        ],
      ),
    );
  }
}
