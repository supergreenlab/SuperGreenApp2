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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';

class FeedFormDatePicker extends StatelessWidget {
  final DateTime date;
  final Function(DateTime?) onChange;

  const FeedFormDatePicker(this.date, {required this.onChange});

  @override
  Widget build(BuildContext context) {
    String format = AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy HH:mm' : 'dd/MM/yyyy HH:mm';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/feed_form/icon_calendar.svg', width: 30, height: 30),
            ),
            Expanded(child: Text('Event date: ${DateFormat(format).format(date)}')),
            TextButton(
                onPressed: () async {
                  DateTime? newDate = await DatePicker.showDateTimePicker(
                      context,
                      currentTime: date,
                      minTime: DateTime.fromMillisecondsSinceEpoch(0),);
                  onChange(newDate);
                },
                child: Text('change'))
          ],
        ),
      ),
    );
  }
}
