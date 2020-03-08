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

import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieButtonViewBox extends TowelieButton {
  static Map<String, dynamic> createBox(Box box) => {
        'ID': 'VIEW_BOX',
        'title': 'View box',
        'boxID': box.id,
      };

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'VIEW_BOX') {
      final bdb = RelDB.get().boxesDAO;
      Box box = await bdb.getBox(event.params['boxID']);
      yield TowelieBlocStateHomeNavigation(HomeNavigateToBoxFeedEvent(box));
    }
  }
}
