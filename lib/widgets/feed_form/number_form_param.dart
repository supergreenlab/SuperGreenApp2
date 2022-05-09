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
import 'package:super_green_app/widgets/feed_form/feed_form_button.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class NumberFormParam extends StatelessWidget {
  final String title;
  final String icon;
  final double value;
  final String unit;
  final double step;
  final void Function(double) onChange;
  final String Function(double)? displayFn;
  final double displayMultiplier;
  final Widget? child;

  const NumberFormParam(
      {required this.title,
      required this.icon,
      required this.value,
      this.step = 0.5,
      required this.onChange,
      this.unit = '',
      this.displayMultiplier = 1,
      this.displayFn,
      this.child});

  @override
  Widget build(BuildContext context) {
    String Function(double) displayFn = this.displayFn ?? (v) => '${value * displayMultiplier}';
    return FeedFormParamLayout(
      icon: icon,
      title: title,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), //adds padding inside the button
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
                    height: 36,
                    minWidth: 60, //wraps child's width
                    child: FeedFormButton(
                      title: '-',
                      onPressed: () {
                        onChange(value - step);
                      },
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${displayFn(value)}$unit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                ButtonTheme(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), //adds padding inside the button
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
                    height: 36,
                    minWidth: 60, //wraps child's width
                    child: FeedFormButton(
                      title: '+',
                      onPressed: () {
                        onChange(value + step);
                      },
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ],
            ),
            this.child ?? Container(),
          ],
        ),
      ),
    );
  }
}
