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
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/red_button.dart';

class PlantInfosForm extends StatelessWidget {
  final String? icon;
  final String title;
  final Widget child;

  final Function onCancel;
  final Function()? onSubmit;

  const PlantInfosForm(
      {Key? key, this.icon, required this.title, required this.child, required this.onCancel, required this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon != null ? SvgPicture.asset("assets/plant_infos/$icon", height: 25,) : Container(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
        child,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RedButton(
              title: 'Cancel',
              onPressed: onCancel,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: GreenButton(
                title: 'OK',
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
