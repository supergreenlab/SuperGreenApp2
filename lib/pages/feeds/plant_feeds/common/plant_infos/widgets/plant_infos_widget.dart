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
import 'package:flutter_svg/svg.dart';

class PlantInfosWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Function onEdit;

  const PlantInfosWidget(this.icon, this.title, this.value, this.onEdit,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget valueWidget = InkWell(
        onTap: onEdit,
        child: Container(
            decoration: BoxDecoration(
                color: value == null ? Colors.white24 : Colors.transparent,
                borderRadius: BorderRadius.circular(2)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    value ?? "Tap to set",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            value == null ? FontWeight.w300 : FontWeight.w800),
                    textAlign: value == null ? TextAlign.center : null,
                  )),
                  SvgPicture.asset("assets/plant_infos/edit.svg"),
                ],
              ),
            )));
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset("assets/plant_infos/$icon"),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(title, style: TextStyle(color: Colors.white)),
                ),
                valueWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
