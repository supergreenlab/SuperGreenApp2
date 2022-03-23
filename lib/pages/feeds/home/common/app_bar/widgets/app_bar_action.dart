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
import 'package:flutter_svg/svg.dart';

class AppBarAction extends StatelessWidget {
  final String icon;
  final Color color;
  final String title;
  final Widget? titleIcon;
  final Widget body;
  final Widget? action;

  const AppBarAction(
      {Key? key,
      required this.icon,
      required this.color,
      required this.title,
      this.titleIcon,
      required this.body,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: 1.0,
            blurRadius: 2.0,
            offset: Offset(2, 3),
          )
        ],
      ),
      child: Row(
        children: [
          renderIcon(context),
          Expanded(child: renderBody(context)),
          action != null ? renderButton(context) : Container(),
        ],
      ),
    );
  }

  Widget renderIcon(BuildContext context) {
    const iconSize = 40.0;
    return Container(
      color: color,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(iconSize / 2),
                  color: Colors.white,
                ),
                child: SvgPicture.asset(icon, width: iconSize, height: iconSize, fit: BoxFit.contain)),
          ),
        ],
      ),
    );
  }

  Widget renderBody(BuildContext context) {
    Widget top = Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold));
    if (titleIcon != null) {
      top = Row(children: [top, titleIcon!]);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [top, body],
      ),
    );
  }

  Widget renderButton(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: action),
        ),
      ],
    );
  }
}
