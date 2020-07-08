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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';

class PlantInfosWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Function onEdit;

  const PlantInfosWidget({Key key, this.icon, @required this.title, @required this.value, @required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget valueWidget = InkWell(
        onTap: onEdit,
        child: value == null ? _renderNoValue() : _renderValue());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon != null
                  ? SvgPicture.asset("assets/plant_infos/$icon")
                  : Container(),
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
      ),
    );
  }

  Widget _renderNoValue() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(2)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "Tap to set",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              )),
              SvgPicture.asset("assets/plant_infos/edit.svg"),
            ],
          ),
        ));
  }

  Widget _renderValue() {
    return Container(
        decoration: BoxDecoration(
            color: value == null ? Colors.white24 : Colors.transparent,
            borderRadius: BorderRadius.circular(2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: MarkdownBody(
                data: value,
                styleSheet: MarkdownStyleSheet(
                    p: TextStyle(color: Colors.white, fontSize: 16),
                    h1: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    strong: TextStyle(color: Color(0xff3bb30b), fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              SvgPicture.asset("assets/plant_infos/edit.svg"),
            ],
          ),
        ));
  }
}
