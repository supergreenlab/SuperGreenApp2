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
import 'package:super_green_app/towelie/cards/plant/card_plant_tuto_take_pic.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _seedID = 'PLANT_SEED_STAGE';

class TowelieButtonPlantSeedPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _seedID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_seedID, {
        'title': 'Seed',
      });

  TowelieButtonPlantSeedPhase() : super('SEED', 'VEG');
}

const _seedlingID = 'PLANT_SEEDLING_STAGE';

class TowelieButtonPlantSeedlingPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _seedlingID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_seedlingID, {
        'title': 'Seedling',
      });

  TowelieButtonPlantSeedlingPhase() : super('SEEDLING', 'VEG');
}

const _vegID = 'PLANT_VEG_STAGE';

class TowelieButtonPlantVegPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _vegID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_vegID, {
        'title': 'Veg',
      });

  TowelieButtonPlantVegPhase() : super('VEG', 'VEG');
}

const _bloomID = 'PLANT_BLOOM_STAGE';

class TowelieButtonPlantBloomPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _bloomID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_bloomID, {
        'title': 'Bloom',
      });

  TowelieButtonPlantBloomPhase() : super('BLOOM', 'BLOOM');
}

abstract class TowelieButtonPlantPhase extends TowelieButton {
  final String phase;
  final String schedule;

  TowelieButtonPlantPhase(this.phase, this.schedule);

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    final db = RelDB.get();
    Plant plant = await db.plantsDAO.getPlantWithFeed(event.feed.id);
    Box box = await db.plantsDAO.getBox(plant.box);
    Map<String, dynamic> plantSettings = db.plantsDAO.plantSettings(plant);
    plantSettings['phase'] = phase;
    await db.plantsDAO.updatePlant(PlantsCompanion(
        id: Value(plant.id),
        settings: Value(JsonEncoder().convert(plantSettings))));

    final Map<String, dynamic> boxSettings = db.plantsDAO.boxSettings(box);
    if (plantSettings['plantType'] == 'PHOTO') {
      boxSettings['schedule'] = schedule;
    }
    await db.plantsDAO.updateBox(BoxesCompanion(
        id: Value(box.id),
        settings: Value(JsonEncoder().convert(boxSettings))));

    await createNextCard(event.feed);
    await removeButtons(event.feedEntry, selectedButtonID: id);
  }

  Future createNextCard(Feed feed) async {
    await CardPlantTutoTakePic.createPlantTutoTakePic(feed);
  }
}
