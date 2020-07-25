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

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/helpers/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/misc/towelie_button_show_tip.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_germinate.dart';

class CardPlantGermination {
  static String get toweliePlantGermination {
    return Intl.message(
      '''Ok, place your seed in water, follow the guide, and press the "germinated" button below\nwhen you're ready to place the seed in its growing medium.''',
      name: 'toweliePlantGermination',
      desc: 'Towelie plant germination',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantGermination(Feed feed) async {
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantGermination.toweliePlantGermination,
        'buttons': [
          TowelieButtonPlantGerminate.createButton(),
          TowelieButtonShowTip.createButton('Germination guide', 't/supergreenlab/SuperGreenTips/master/s/how_to_germinate_your_seed/l/en'),
        ]
      })),
    ));
  }
}
