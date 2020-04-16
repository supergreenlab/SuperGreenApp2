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
import 'package:super_green_app/towelie/cards/plant/card_plant_already_started.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _autoID = 'PLANT_AUTO';

class TowelieButtonPlantAuto extends TowelieButton {
  @override
  String get id => _autoID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_autoID, {
        'title': 'Auto',
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    final db = RelDB.get();
    Plant plant = await db.plantsDAO.getPlantWithFeed(event.feed.id);
    Map<String, dynamic> settings = db.plantsDAO.plantSettings(plant);
    settings['plantType'] = 'AUTO';
    await db.plantsDAO.updatePlant(PlantsCompanion(
        id: Value(plant.id), settings: Value(JsonEncoder().convert(settings))));

    Box box = await db.plantsDAO.getBox(plant.box);
    final Map<String, dynamic> boxSettings = db.plantsDAO.boxSettings(box);
    boxSettings['schedule'] = 'AUTO';
    await db.plantsDAO.updatePlant(PlantsCompanion(
        id: Value(box.id),
        settings: Value(JsonEncoder().convert(boxSettings))));

    await CardPlantAlreadyStarted.createPlantAlreadyStartedCard(event.feed);
    await removeButtons(event.feedEntry, selectedButtonID: id);
  }
}

const _photoID = 'PLANT_PHOTO';

class TowelieButtonPlantPhoto extends TowelieButton {
  @override
  String get id => _photoID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_photoID, {
        'title': 'Photo',
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
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

    await CardPlantAlreadyStarted.createPlantAlreadyStartedCard(event.feed);
    await removeButtons(event.feedEntry, selectedButtonID: id);
  }
}
