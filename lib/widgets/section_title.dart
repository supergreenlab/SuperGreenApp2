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
import 'package:flutter_svg/flutter_svg.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String icon;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool large;
  final double? elevation;
  final double iconPadding;
  final Widget? child;

  const SectionTitle({
      required this.title,
      required this.icon,
      this.large = false,
      this.backgroundColor,
      this.titleColor = Colors.black,
      this.elevation,
      this.iconPadding = 8,
      this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: elevation != null
            ? [BoxShadow(offset: Offset(0, elevation!), color: Colors.black12, blurRadius: elevation!)]
            : null,
        color: backgroundColor ?? Color(0xFFECECEC),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: large ? 16.0 : 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderIcon(),
            Text(
              this.title,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: large ? 20 : 16, color: this.titleColor),
            ),
            if (this.child != null)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: child,
                ),
              ),
        ]),
      ),
    );
  }

  Widget _renderIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 4.0),
      child: Container(
        width: large ? 50 : 40,
        height: large ? 50 : 40,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: iconPadding, horizontal: iconPadding),
          child: SvgPicture.asset(this.icon),
        ),
      ),
    );
  }
}
