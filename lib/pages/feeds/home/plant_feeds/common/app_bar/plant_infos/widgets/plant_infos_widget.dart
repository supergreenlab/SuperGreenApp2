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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_action.dart';

class PlantInfosWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String? value;
  final Widget? valueWidget;
  final Function()? onEdit;
  final Color color;
  final double height;

  const PlantInfosWidget(
      {Key? key,
      required this.icon,
      required this.title,
      this.value,
      this.valueWidget,
      this.onEdit,
      this.height = 65,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = value == null && this.valueWidget == null ? _renderNoValue() : _renderValue();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: AppBarAction(
        icon: icon,
        height: height,
        color: color,
        title: title,
        content: content,
        action: onEdit,
        addIcon: false,
        actionIcon: onEdit != null ? SvgPicture.asset("assets/plant_infos/edit.svg") : null,
      ),
    );
  }

  Widget _renderNoValue() {
    if (onEdit == null) {
      return Text("Not set", style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.w300));
    }
    return Text(
      "Tap to set",
      style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.w300),
      textAlign: TextAlign.center,
    );
  }

  Widget _renderValue() {
    if (valueWidget != null) {
      return valueWidget!;
    }
    return MarkdownBody(
      data: value ?? '',
      styleSheet: MarkdownStyleSheet(
          p: TextStyle(color: Color(0xFF494949), fontSize: 16),
          h1: TextStyle(color: Color(0xFF494949), fontSize: 20, fontWeight: FontWeight.bold),
          strong: TextStyle(color: Color(0xff3bb30b), fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
