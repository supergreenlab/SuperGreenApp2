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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarAction extends StatelessWidget {
  final String? icon;
  final Widget? iconWidget;
  final Color color;
  final String title;
  final Widget? titleIcon;
  final Widget? content;
  final Function()? action;
  final Widget? actionIcon;
  final Widget? body;
  final bool center;

  final double height;

  const AppBarAction({
    Key? key,
    this.icon,
    this.iconWidget,
    required this.color,
    required this.title,
    this.titleIcon,
    this.content,
    this.body,
    this.action,
    this.actionIcon,
    this.height = 65,
    this.center = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              spreadRadius: 2.0,
              blurRadius: 2.0,
              offset: Offset(1, 1),
            )
          ],
        ),
        child: Row(
          children: [
            renderIcon(context),
            Expanded(child: renderBody(context)),
            actionIcon != null ? renderButton(context) : Container(),
          ],
        ),
      ),
    );
  }

  Widget renderIcon(BuildContext context) {
    const iconSize = 40.0;
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(iconSize / 2),
                  color: Colors.white,
                ),
                child: this.iconWidget ?? SvgPicture.asset(this.icon!, width: iconSize, height: iconSize, fit: BoxFit.contain)),
          ),
        ],
      ),
    );
  }

  Widget renderBody(BuildContext context) {
    Widget top = AutoSizeText(title, maxLines: 1, style: TextStyle(color: color, fontWeight: FontWeight.bold));
    if (titleIcon != null) {
      top = Row(children: [top, titleIcon!]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          top,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
              children: [
                body ?? Container(),
                renderContent(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget renderButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: actionIcon),
        ),
      ],
    );
  }

  Widget renderContent(BuildContext context) {
    return content ?? Container();
  }
}
