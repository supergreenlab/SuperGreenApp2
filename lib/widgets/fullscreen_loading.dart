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
import 'package:super_green_app/widgets/fullscreen.dart';

class FullscreenLoading extends StatelessWidget {
  final String title;
  final double percent;

  const FullscreenLoading({this.title, this.percent});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (percent != null) {
      child = Stack(
        children: [
          SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 4.0,
              )),
          SizedBox(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${(percent * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xffababab))),
                ],
              )),
        ],
      );
    } else {
      child = CircularProgressIndicator(
        value: percent,
        strokeWidth: 4.0,
      );
    }
    return Fullscreen(
      title: title,
      child: child,
    );
  }
}
