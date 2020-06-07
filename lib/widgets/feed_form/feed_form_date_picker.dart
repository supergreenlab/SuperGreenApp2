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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';

class FeedFormDatePicker extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) onChange;

  const FeedFormDatePicker(this.date, {this.onChange});

  @override
  Widget build(BuildContext context) {
    String format = AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(child: Text('Event date: ${DateFormat(format).format(date)}')),
            FlatButton(
                onPressed: () async {
                  DateTime newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now().subtract(Duration(days: 10)),
                      lastDate: DateTime.now());
                  onChange(newDate);
                },
                child: Text('change'))
          ],
        ),
      ),
    );
  }
}
