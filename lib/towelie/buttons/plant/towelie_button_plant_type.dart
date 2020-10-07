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

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:super_green_app/towelie/cards/plant/card_plant_phase.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _autoID = 'PLANT_AUTO';

class TowelieButtonPlantAuto extends TowelieButtonPlantType {
  @override
  String get id => _autoID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_autoID, {
        'title': 'Auto',
      });

  TowelieButtonPlantAuto() : super('AUTO', 'AUTO');
}

const _photoID = 'PLANT_PHOTO';

class TowelieButtonPlantPhoto extends TowelieButtonPlantType {
  @override
  String get id => _photoID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_photoID, {
        'title': 'Photo',
      });

  TowelieButtonPlantPhoto() : super('PHOTO', 'VEG');
}

abstract class TowelieButtonPlantType extends TowelieButton {
  final String plantType;
  final String schedule;

  TowelieButtonPlantType(this.plantType, this.schedule);

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    final db = RelDB.get();
    Plant plant = await db.plantsDAO.getPlantWithFeed(event.feed);
    PlantSettings plantSettings =
        PlantSettings.fromJSON(plant.settings).copyWith(plantType: plantType);
    await db.plantsDAO.updatePlant(PlantsCompanion(
        id: Value(plant.id),
        settings: Value(plantSettings.toJSON()),
        synced: Value(false)));

    Box box = await db.plantsDAO.getBox(plant.box);
    BoxSettings boxSettings =
        BoxSettings.fromJSON(box.settings).copyWith(schedule: schedule);
    await db.plantsDAO.updateBox(BoxesCompanion(
        id: Value(box.id),
        settings: Value(boxSettings.toJSON()),
        synced: Value(false)));

    Feed feed = await RelDB.get().feedsDAO.getFeed(event.feed);
    FeedEntry feedEntry =
        await RelDB.get().feedsDAO.getFeedEntry(event.feedEntry);
    await CardPlantPhase.createPlantPhase(feed);
    await selectButtons(feedEntry, selectedButtonID: id);
  }
}
