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

import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _id = 'TAKE_PIC';

class TowelieButtonPushRouteFeedMedia extends TowelieButton {
  @override
  String get id => _id;

  static Map<String, dynamic> createButton(String title, int plantID) => TowelieButton.createButton(_id, {
        'title': title,
        'plantID': plantID,
      });

  @override
  Stream<TowelieBlocState> buttonPressed(TowelieBlocEventButtonPressed event) async* {
    int plantID = event.params['plantID'];
    Plant plant = await RelDB.get().plantsDAO.getPlant(plantID);
    yield TowelieBlocStateMainNavigation(MainNavigateToFeedMediaFormEvent(plant: plant));
    if (event.feedEntry != null) {
      FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(event.feedEntry);
      await selectButtons(feedEntry, selectedButtonID: id);
    }
  }
}
