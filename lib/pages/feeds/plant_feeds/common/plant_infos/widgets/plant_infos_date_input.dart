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

class PlantInfosDateInput extends StatelessWidget {
  final String hintText;
  final String labelText;
  final DateTime date;
  final Function(DateTime) onChange;

  const PlantInfosDateInput(
      {Key key,
      @required this.hintText,
      @required this.labelText,
      @required this.date,
      @required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String format =
        AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'Since: ${DateFormat(format).format(date)}',
              style: TextStyle(color: Colors.white),
            )),
            FlatButton(
                onPressed: () async {
                  DateTime newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now().subtract(Duration(days: 100)),
                      lastDate: DateTime.now());
                  onChange(newDate);
                },
                child: Text('change', style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
