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

import 'dart:async';

import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  final Widget child;
  final bool animate;

  const FeedCard({Key key, @required this.child, @required this.animate}) : super(key: key);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  double opacity = 1;

  @override
  void initState() {
    if (widget.animate) {
      opacity = 0;
      Timer(
          Duration(milliseconds: 500),
          () => setState(() {
                opacity = 1;
              }));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffdedede), width: 2),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: widget.child),
      );
    if (widget.animate) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 500),
      child: body,
    );
    }
    return body;
  }
}
