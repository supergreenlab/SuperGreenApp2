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

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:super_green_app/towelie/cards/plant/card_plant_start_seed.dart';
import 'package:super_green_app/towelie/cards/plant/card_plant_tuto_take_pic.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _seedID = 'PLANT_SEED_STAGE';

class TowelieButtonPlantSeedPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _seedID;

  static Map<String, dynamic> createButton() => TowelieButton.createButton(_seedID, {
        'title': 'Seed',
      });

  TowelieButtonPlantSeedPhase() : super(null, 'VEG');

  Future createNextCard(Feed feed) async {
    await CardPlantStartSeedling.createPlantStartSeedling(feed);
  }
}

const _seedlingID = 'PLANT_SEEDLING_STAGE';

class TowelieButtonPlantSeedlingPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _seedlingID;

  static Map<String, dynamic> createButton() => TowelieButton.createButton(_seedlingID, {
        'title': 'Seedling',
      });

  TowelieButtonPlantSeedlingPhase() : super(PlantPhases.GERMINATING, 'VEG');
}

const _vegID = 'PLANT_VEG_STAGE';

class TowelieButtonPlantVegPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _vegID;

  static Map<String, dynamic> createButton() => TowelieButton.createButton(_vegID, {
        'title': 'Veg',
      });

  TowelieButtonPlantVegPhase() : super(PlantPhases.VEGGING, 'VEG');
}

const _bloomID = 'PLANT_BLOOM_STAGE';

class TowelieButtonPlantBloomPhase extends TowelieButtonPlantPhase {
  @override
  String get id => _bloomID;

  static Map<String, dynamic> createButton() => TowelieButton.createButton(_bloomID, {
        'title': 'Bloom',
      });

  TowelieButtonPlantBloomPhase() : super(PlantPhases.BLOOMING, 'BLOOM');
}

abstract class TowelieButtonPlantPhase extends TowelieButton {
  final PlantPhases? phase;
  final String schedule;

  TowelieButtonPlantPhase(this.phase, this.schedule);

  @override
  Stream<TowelieBlocState> buttonPressed(TowelieBlocEventButtonPressed event) async* {
    final db = RelDB.get();
    Plant plant = await db.plantsDAO.getPlantWithFeed(event.feed);
    Box box = await db.plantsDAO.getBox(plant.box);
    PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);

    if (phase != null) {
      yield TowelieBlocStateMainNavigation(MainNavigateToFeedLifeEventFormEvent(plant, phase!));
    }

    BoxSettings boxSettings = BoxSettings.fromJSON(box.settings);
    if (plantSettings.plantType == 'PHOTO') {
      boxSettings = boxSettings.copyWith(schedule: schedule);
    }
    await db.plantsDAO.updateBox(BoxesCompanion(
      id: Value(box.id),
      settings: Value(boxSettings.toJSON()),
      synced: Value(false),
    ));

    Feed feed = await RelDB.get().feedsDAO.getFeed(event.feed);
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(event.feedEntry);
    await createNextCard(feed);
    await selectButtons(feedEntry, selectedButtonID: id);
  }

  Future createNextCard(Feed feed) async {
    await CardPlantTutoTakePic.createPlantTutoTakePic(feed);
  }
}
