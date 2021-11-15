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
import 'dart:math' as math;
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
  final bool loading;
  final bool disable;

  const SliderFormParam({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
    required this.color,
    this.min = 0,
    this.max = 100,
    required this.loading,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeedFormParamLayout(
      title: title,
      icon: icon,
      child: Column(
        children: <Widget>[
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: disable == true
                    ? null
                    : () {
                        double newValue = math.max(min, value - 1);
                        onChanged(newValue);
                        onChangeEnd(newValue);
                      },
                child: Text('-', style: TextStyle(fontSize: 50, color: Colors.grey)),
              ),
              Text('$value%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff3bb30b))),
              TextButton(
                onPressed: disable == true
                    ? null
                    : () {
                        double newValue = math.min(max, value + 1);
                        onChanged(newValue);
                        onChangeEnd(newValue);
                      },
                child: Text('+', style: TextStyle(fontSize: 30, color: Colors.grey)),
              ),
              loading == true
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff3bb30b)),
                      ),
                    )
                  : Container(),
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text('0%'),
                Expanded(
                  child: Slider(
                    min: min,
                    max: max,
                    onChangeEnd: disable == true ? null : onChangeEnd,
                    value: value,
                    activeColor: color,
                    onChanged: disable == true ? null : onChanged,
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
