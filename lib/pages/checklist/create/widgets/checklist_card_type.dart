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

class ChecklistCardType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: 0,
      onChanged: (int? value) {},
      items: [
        DropdownMenuItem(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset('assets/feed_card/icon_media.svg'),
              Text('Temperature'),
            ],
          ),
        ),
      ],
    );
  }
}
