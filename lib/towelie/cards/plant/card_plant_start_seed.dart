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
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/misc/towelie_button_create_account.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_start_seedling.dart';

class CardPlantStartSeedling {
  static String get toweliePlantStartSeedling {
    return Intl.message(
      '''Alright, let me know when you're **ready to put the seed to germinate** by pressing the **start** button below.
In the meantime you can also **create an account**:P that will enable backups, remote control, sharing, etc...''',
      name: 'toweliePlantStartSeedling',
      desc: 'Towelie plant start seedling',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static Future createPlantStartSeedling(Feed feed) async {
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantStartSeedling.toweliePlantStartSeedling,
        'buttons': [
          TowelieButtonStartSeedling.createButton(),
          TowelieButtonCreateAccount.createButton(),
        ]
      })),
    ));
  }
}
