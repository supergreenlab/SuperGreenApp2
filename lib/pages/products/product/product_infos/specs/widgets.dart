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

class SpecTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool autofocus;

  const SpecTextField(
      {Key? key, this.labelText, this.hintText, this.controller, this.onChanged, this.autofocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: TextFormField(
        autofocus: autofocus,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
        controller: controller,
        onChanged: onChanged,
      ),
    );
  }
}
