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
import 'package:super_green_app/theme.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class YesNoFormParam extends StatelessWidget {
  final String title;
  final String icon;
  final bool? yes;
  final Color? titleBackgroundColor;
  final void Function(bool?) onPressed;
  final Widget? child;

  const YesNoFormParam({
      required this.icon,
      required this.title,
      required this.yes,
      required this.onPressed,
      this.titleBackgroundColor,
      this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FeedFormParamLayout(
      icon: icon,
      title: title,
      titleBackgroundColor: titleBackgroundColor,
      inline: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: AnimatedSwitch(
          value: yes ?? false,
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}

class AnimatedSwitch extends StatefulWidget {
  AnimatedSwitch({
    Key? key,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  bool value;
  final void Function(bool x)? onPressed;

  @override
  _AnimatedSwitchState createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch> {
  final animationDuration = Duration(milliseconds: 300);

  Color get color {
    return isYes ? SglColor.green : SglColor.inactive;
  }

  bool get isYes {
    return widget.value == true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.value = !widget.value;
        });
        widget.onPressed!(widget.value);
      },
      child: AnimatedContainer(
        height: 40,
        width: 70,
        duration: animationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
          border: Border.all(
            color: Colors.white,
            width: 2
          ),
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: isYes ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
