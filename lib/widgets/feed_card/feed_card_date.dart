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

class FeedCardDate extends StatelessWidget {
  final DateTime date;

  const FeedCardDate(this.date);

  @override
  Widget build(BuildContext context) {
    Duration diff = DateTime.now().difference(date);
    int minuteDiff = diff.inMinutes;
    int hourDiff = diff.inHours;
    int dayDiff = diff.inDays;
    String format;
    if (minuteDiff < 60) {
      format = '$minuteDiff minute${minuteDiff > 1 ? 's' : ''} ago';
    } else if (hourDiff < 24) {
      format = '$hourDiff hour${hourDiff > 1 ? 's' : ''} ago';
    } else/* if (dayDiff < 5)*/ {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''} ago';
    } /*else {
      DateFormat f = DateFormat('yyyy-MM-dd');
      format = f.format(feedEntry.date);
    }*/
    return Text(format,
        style: TextStyle(color: Colors.black54));
  }
}
