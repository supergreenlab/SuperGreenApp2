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

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';
import 'package:tuple/tuple.dart';

class ChecklistDuration extends StatefulWidget {

  final int? duration;
  final String? unit;
  final Function(int? duration, String? unit) onUpdate;

  const ChecklistDuration({Key? key, required this.onUpdate, required this.unit, required this.duration}) : super(key: key);

  @override
  State<ChecklistDuration> createState() => _ChecklistDurationState();
}

class _ChecklistDurationState extends State<ChecklistDuration> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.duration == null ? '' : widget.duration.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tuple2<String, String>> choices = [
      Tuple2('MINUTES', 'Minutes'),
      Tuple2('HOURS', 'Hours'),
      Tuple2('DAYS', 'Days'),
      Tuple2('WEEKS', 'Weeks'),
      Tuple2('MONTHS', 'Months'),
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: FeedFormTextarea(
              onChanged: (value) {
                widget.onUpdate(int.parse(_controller.text), widget.unit);
              },
              placeholder: ' ',
              soloLine: true,
              noPadding: true,
              textEditingController: _controller,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: DropdownButton<String>(
                value: widget.unit,
                onChanged: (String? value) {
                  widget.onUpdate(widget.duration, value!);
                },
                items: choices.map((c) {
                  return DropdownMenuItem(
                    value: c.item1,
                    child: Text(c.item2),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}