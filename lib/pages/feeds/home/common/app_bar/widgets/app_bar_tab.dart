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

class AppBarTab extends StatelessWidget {
  final Widget child;

  const AppBarTab({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 36.0, top: 12),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2.0), boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
              ),
              const BoxShadow(
                color: Colors.white,
                spreadRadius: -3.0,
                blurRadius: 3.0,
              ),
            ]),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [Expanded(child: Padding(padding: const EdgeInsets.all(6.0), child: child))]),
          ),
        ));
  }
}
