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

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_create_plant.dart';

class CardCreatePlant {
  static String get towelieCreatePlant {
    return Intl.message(
      '''Alright we're ready to start your **first plant!**

The app works like this:
- you **create a plant**
- setup **your green lab**
- control and monitor it with a **SuperGreenController** (optional)

Once this is done, you will have access to it's **feed**, it's like a timeline of the **plant's life**.
Whenever you **water**, change **light power**, **train the plant**, or any other action,
it will **log** it in the plant's feed, so you can **share it**, or **replay it** for your next grow!

Press the **Create plant** button below.
''',
      name: 'towelieCreatePlant',
      desc: 'Towelie Create Plant',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static Future createCreatePlantCard(Feed feed) async {
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardCreatePlant.towelieCreatePlant,
        'buttons': [
          TowelieButtonCreatePlant.createButton(),
        ],
      })),
    ));
  }
}
