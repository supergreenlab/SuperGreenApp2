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
import 'package:flutter_svg/flutter_svg.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String icon;

  const SectionTitle({@required this.title, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFECECEC),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _renderIcon(),
          Text(
            this.title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ]),
      ),
    );
  }

  Widget _renderIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 4.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: SvgPicture.asset(this.icon),
        ),
      ),
    );
  }
}
