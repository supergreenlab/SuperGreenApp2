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

import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:super_green_app/towelie/cards/plant/card_plant_tuto_take_pic.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _id = 'PLANT_GERMINATE';

class TowelieButtonPlantGerminate extends TowelieButton {
  @override
  String get id => _id;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_id, {
        'title': 'Germinated',
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    Plant plant = await RelDB.get().plantsDAO.getPlantWithFeed(event.feed);
    await PlantHelper.updatePlantPhase(
        plant, PlantPhases.GERMINATING, DateTime.now());

    Feed feed = await RelDB.get().feedsDAO.getFeed(event.feed);
    await CardPlantTutoTakePic.createPlantTutoTakePic(feed);
    FeedEntry feedEntry =
        await RelDB.get().feedsDAO.getFeedEntry(event.feedEntry);
    await selectButtons(feedEntry, selectedButtonID: id);
  }
}
