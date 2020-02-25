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
import 'package:super_green_app/widgets/feed_form/feed_form_button.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class YesNoFormParam extends StatelessWidget {
  final String title;
  final String icon;
  final bool yes;
  final void Function(bool) onPressed;

  const YesNoFormParam({this.icon, this.title, this.yes, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FeedFormParamLayout(
      icon: icon,
      title: title,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FeedFormButton(
                title: 'YES',
                border: yes == true,
                onPressed: () {
                  this.onPressed(yes == true ? null : true);
                },
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            FeedFormButton(
                title: 'NO',
                border: yes == false,
                onPressed: () {
                  this.onPressed(yes == false ? null : false);
                },
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
