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

class PlantInfosDropdownInput extends StatelessWidget {
  final String? value;
  final String labelText;
  final String hintText;
  final List<List<String>> items;
  final Function(String? value) onChanged;

  const PlantInfosDropdownInput(
      {Key? key,
      required this.value,
      required this.labelText,
      required this.hintText,
      required this.items,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Theme(
        data: ThemeData(
          canvasColor: Colors.black87,
        ),
        child: DropdownButtonFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              filled: true,
              fillColor: Colors.white10,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white30),
              labelText: labelText,
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            selectedItemBuilder: (BuildContext context) {
              return items.map((i) => Text(i[1], style: TextStyle(color: Colors.white))).toList();
            },
            items: items
                .map((i) => DropdownMenuItem<String>(
                      value: i[0],
                      child: Text(i[1], style: TextStyle(color: Colors.white)),
                    ))
                .toList(),
            value: value,
            onChanged: onChanged),
      ),
    );
  }
}
