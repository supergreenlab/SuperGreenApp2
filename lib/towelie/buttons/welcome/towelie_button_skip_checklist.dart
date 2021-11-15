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

import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/cards/welcome/card_create_plant.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _id = 'SKIP_CHECKLIST';

class TowelieButtonSkipChecklist extends TowelieButton {
  static String get towelieButtonSkipChecklist {
    return Intl.message(
      'Skip checklist',
      name: 'towelieButtonSkipChecklist',
      desc: 'Towelie button skip checklist',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  String get id => _id;

  static Map<String, dynamic> createButton() => TowelieButton.createButton(_id, {
        'title': TowelieButtonSkipChecklist.towelieButtonSkipChecklist,
      });

  @override
  Stream<TowelieBlocState> buttonPressed(TowelieBlocEventButtonPressed event) async* {
    Feed feed = await RelDB.get().feedsDAO.getFeed(event.feed);
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(event.feedEntry);
    await CardCreatePlant.createCreatePlantCard(feed);
    await selectButtons(feedEntry, selectedButtonID: id);
  }
}
