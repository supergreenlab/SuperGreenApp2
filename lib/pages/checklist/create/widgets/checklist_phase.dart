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
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:tuple/tuple.dart';

class ChecklistPhase extends StatelessWidget {
  final String? phase;
  final Function(String phase) onChange;

  const ChecklistPhase({Key? key, required this.phase, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tuple3> choices = [
      Tuple3(PH_CLONE, PlantPhaseNames[PH_CLONE], PlantPhaseIcons[PH_CLONE]),
      Tuple3(PH_SEED, PlantPhaseNames[PH_SEED], PlantPhaseIcons[PH_SEED]),
      Tuple3(PH_VEGGING, PlantPhaseNames[PH_VEGGING], PlantPhaseIcons[PH_VEGGING]),
      Tuple3(PH_BLOOMING, PlantPhaseNames[PH_BLOOMING], PlantPhaseIcons[PH_BLOOMING]),
      Tuple3(PH_DRYING, PlantPhaseNames[PH_DRYING], PlantPhaseIcons[PH_DRYING]),
      Tuple3(PH_CURING, PlantPhaseNames[PH_CURING], PlantPhaseIcons[PH_CURING]),
    ];

    return DropdownButton<String>(
      hint: Text('Select plant phase'),
      value: phase,
      onChanged: (String? value) {
        onChange(value!);
      },
      items: choices.map<DropdownMenuItem<String>>((c) {
        return DropdownMenuItem(
          value: c.item1,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset(c.item3),
              ),
              Text(c.item2),
            ],
          ),
        );
      }).toList(),
    );
  }
}
