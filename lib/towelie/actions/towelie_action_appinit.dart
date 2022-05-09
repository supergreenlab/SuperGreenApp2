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
import 'package:super_green_app/towelie/cards/welcome/card_welcome_app.dart';
import 'package:super_green_app/towelie/towelie_action.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionAppInit extends TowelieAction {
  @override
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventAppInit) {
      final fdb = RelDB.get().feedsDAO;
      int feedID = await fdb.addFeed(FeedsCompanion(name: Value("SuperGreenLab"), isNewsFeed: Value(true)));
      Feed feed = await fdb.getFeed(feedID);
      await CardWelcomeApp.createWelcomeAppCard(feed);
    }
  }
}
