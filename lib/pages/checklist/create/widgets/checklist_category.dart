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
import 'package:super_green_app/data/rel/checklist/categories.dart';
import 'package:tuple/tuple.dart';

class ChecklistCategory extends StatelessWidget {
  final String? category;
  final Function(String phase) onChange;

  const ChecklistCategory({Key? key, required this.category, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tuple3> choices = [
      Tuple3(CH_FEEDING, ChecklistCategoryNames[CH_FEEDING], ChecklistCategoryIcons[CH_FEEDING]),
      Tuple3(CH_PESTS, ChecklistCategoryNames[CH_PESTS], ChecklistCategoryIcons[CH_PESTS]),
      Tuple3(CH_TRAINING, ChecklistCategoryNames[CH_TRAINING], ChecklistCategoryIcons[CH_TRAINING]),
      Tuple3(CH_ENVIRONMENT, ChecklistCategoryNames[CH_ENVIRONMENT], ChecklistCategoryIcons[CH_ENVIRONMENT]),
      Tuple3(CH_SUPPLY, ChecklistCategoryNames[CH_SUPPLY], ChecklistCategoryIcons[CH_SUPPLY]),
      Tuple3(CH_OTHER, ChecklistCategoryNames[CH_OTHER], ChecklistCategoryIcons[CH_OTHER]),
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
