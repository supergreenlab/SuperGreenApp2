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

class FeedFormTextarea extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool noPadding;

  const FeedFormTextarea({required this.textEditingController, this.noPadding=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(noPadding ? 0 : 8.0),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black26), borderRadius: BorderRadius.circular(3)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            decoration: null,
            style: TextStyle(fontSize: 15),
            expands: true,
            maxLines: null,
            controller: textEditingController,
          ),
        ),
      ),
    );
  }
}
