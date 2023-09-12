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
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/red_button.dart';

class ChecklistLogButtonBottomBar extends StatelessWidget {

  final Function() onCheck;
  final Function() onSkip;

  const ChecklistLogButtonBottomBar({Key? key, required this.onCheck, required this.onSkip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RedButton(
            fontSize: 11,
            onPressed: this.onSkip,
            title: 'Skip',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GreenButton(
              fontSize: 11,
              onPressed: this.onCheck,
              title: 'Check',
            ),
          ),
        ],
      ),
    );
  }
}
