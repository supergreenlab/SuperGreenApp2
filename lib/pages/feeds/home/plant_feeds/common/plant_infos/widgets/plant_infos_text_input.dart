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

class PlantInfosTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool number;

  const PlantInfosTextInput(
      {Key key,
      @required this.controller,
      @required this.hintText,
      @required this.labelText,
      this.number=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        keyboardType: number ? TextInputType.numberWithOptions(decimal: true) : null,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          filled: true,
          fillColor: Colors.white10,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white30),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
        controller: controller,
      ),
    );
  }
}
