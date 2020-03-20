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
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class SliderFormParam extends StatelessWidget {
  final double value;
  final void Function(double) onChanged;
  final void Function(double) onChangeEnd;
  final String title;
  final String icon;
  final Color color;
  final double min;
  final double max;

  const SliderFormParam(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.value,
      @required this.onChanged,
      @required this.onChangeEnd,
      @required this.color,
      this.min = 0,
      this.max = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeedFormParamLayout(
      title: title,
      icon: icon,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
                child: Text('$value%',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3bb30b)))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text('0%'),
                Expanded(
                  child: Slider(
                    min: min,
                    max: max,
                    onChangeEnd: onChangeEnd,
                    value: value,
                    activeColor: color,
                    onChanged: onChanged,
                  ),
                ),
                Text('100%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
