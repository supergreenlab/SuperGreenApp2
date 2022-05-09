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

class SGLTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController controller;
  final bool? enabled;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? error;
  final TextCapitalization textCapitalization;

  SGLTextField(
      {required this.hintText,
      required this.controller,
      required this.onChanged,
      this.enabled,
      this.textInputAction = TextInputAction.next,
      this.onFieldSubmitted,
      this.focusNode,
      this.obscureText = false,
      this.error,
      this.textCapitalization = TextCapitalization.sentences});

  @override
  Widget build(BuildContext context) {
    Widget field = Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black26), borderRadius: BorderRadius.circular(3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        child: TextField(
          textInputAction: textInputAction,
          onSubmitted: onFieldSubmitted,
          enabled: enabled,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 15),
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          obscureText: obscureText,
        ),
      ),
    );
    if (error != null) {
      field = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          field,
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(error!, style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    }
    return field;
  }
}
