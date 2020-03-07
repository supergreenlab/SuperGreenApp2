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

class Fullscreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool childFirst;
  final double fontSize;
  final FontWeight fontWeight;

  const Fullscreen({
    @required this.title,
    @required this.child,
    this.subtitle,
    this.childFirst = true,
    this.fontSize = 25,
    this.fontWeight = FontWeight.w500,
  }) : super();

  @override
  Widget build(BuildContext context) {
    List<Widget> titles = [
      Text(
        title,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Color(0xff565656)),
        textAlign: TextAlign.center,
      )
    ];
    if (subtitle != null) {
      titles.add(Text(
        subtitle,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
        textAlign: TextAlign.center,
      ));
    }
    List<Widget> children = [];
    if (childFirst) {
      children = <Widget>[
        child,
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: titles,
            )),
      ];
    } else {
      children = <Widget>[
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: titles,
            )),
        child,
      ];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(child: Column(children: children)),
      ],
    );
  }
}
