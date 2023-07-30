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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';

class ChecklistCategory extends StatelessWidget {
  final String? category;
  final Function(String phase) onChange;

  const ChecklistCategory({Key? key, required this.category, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tuple3> choices = [
      Tuple3('FEEDING', 'Feeding', 'assets/checklist/icon_watering.svg'),
      Tuple3('PESTS', 'Pest/fungus/parasits control', 'assets/checklist/icon_pests.svg'),
      Tuple3('TRAINING', 'Plant care and training', 'assets/checklist/icon_training.svg'),
      Tuple3('ENVIRONMENT', 'Environment', 'assets/checklist/icon_environment.svg'),
      Tuple3('SUPPLY', 'Supply', 'assets/checklist/icon_supply.svg'),
      Tuple3('OTHER', 'Other', 'assets/checklist/icon_other.svg'),
    ];

    return DropdownButton<String>(
      hint: Text('Select category'),
      value: category,
      onChanged: (String? value) {
        onChange(value!);
      },
      items: choices.map<DropdownMenuItem<String>>((c) {
        return DropdownMenuItem(
          value: c.item1,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: SvgPicture.asset(c.item3, width: 24,),
              ),
              Text(c.item2),
            ],
          ),
        );
      }).toList(),
    );
  }
}
