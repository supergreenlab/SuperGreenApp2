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
import 'package:super_green_app/data/assets/feed_entry.dart';

class ChecklistCardType extends StatelessWidget {
  final bool creatableCards;
  final String? cardType;
  final Function(String type) onChange;

  const ChecklistCardType({Key? key, required this.onChange, required this.cardType, this.creatableCards = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> choices = [
      FE_WATER,
      FE_LIGHT,
      FE_VENTILATION,
      FE_MEDIA,
      FE_MEASURE,
      FE_NUTRIENT_MIX,
      FE_TRANSPLANT,
      FE_BENDING,
      FE_CLONING,
      FE_FIMMING,
      FE_TOPPING,
      FE_DEFOLIATION,
      FE_LIFE_EVENT,
      FE_LIFE_EVENT_CLONING,
      FE_LIFE_EVENT_GERMINATING,
      FE_LIFE_EVENT_VEGGING,
      FE_LIFE_EVENT_BLOOMING,
      FE_LIFE_EVENT_DRYING,
      FE_LIFE_EVENT_CURING,
      FE_TIMELAPSE,
      FE_SCHEDULE,
      FE_SCHEDULE_VEG,
      FE_SCHEDULE_BLOOM,
      FE_SCHEDULE_AUTO,
    ];
    if (creatableCards) {
      choices = choices.where((element) => element != FE_TIMELAPSE).toList();
    } else {
      choices = choices
          .where((element) =>
              element != FE_LIFE_EVENT &&
              element != FE_LIFE_EVENT_CLONING &&
              element != FE_LIFE_EVENT_GERMINATING &&
              element != FE_LIFE_EVENT_VEGGING &&
              element != FE_LIFE_EVENT_BLOOMING &&
              element != FE_LIFE_EVENT_DRYING &&
              element != FE_LIFE_EVENT_CURING)
          .toList();
    }
    return DropdownButton<String?>(
      hint: Text('Select card type'),
      value: cardType,
      onChanged: (String? value) {
        onChange(value == null ? '' : value);
      },
      items: choices.map<DropdownMenuItem<String>>((c) {
        return DropdownMenuItem<String>(
          value: c,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset(FeedEntryIcons[c]!),
              ),
              Text(FeedEntryNames[c]!),
            ],
          ),
        );
      }).toList(),
    );
  }
}
