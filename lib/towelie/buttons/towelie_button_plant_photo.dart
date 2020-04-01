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

import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_cards_factory.dart';

class TowelieButtonPlantPhoto extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'PLANT_PHOTO',
      'title': 'Photo',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'PLANT_PHOTO') {
      final db = RelDB.get();
      Plant plant = await db.plantsDAO.getPlantWithFeed(event.feed.id);
      Box box = await db.plantsDAO.getBox(plant.box);
      Map<String, dynamic> plantSettings = db.plantsDAO.plantSettings(plant);
      plantSettings['plantType'] = 'PHOTO';
      await db.plantsDAO.updatePlant(PlantsCompanion(
          id: Value(plant.id),
          settings: Value(JsonEncoder().convert(plantSettings))));

      final Map<String, dynamic> boxSettings = db.plantsDAO.boxSettings(box);
      boxSettings['schedule'] = 'VEG';
      await db.plantsDAO.updateBox(BoxesCompanion(
          id: Value(box.id),
          settings: Value(JsonEncoder().convert(boxSettings))));

      await TowelieCardsFactory.createPlantAlreadyStartedCard(event.feed);
      await removeButtons(event.feedEntry);
    }
  }
}
