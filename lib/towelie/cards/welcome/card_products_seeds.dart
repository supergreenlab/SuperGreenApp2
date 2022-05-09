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

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_show_products_growing_medium.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_skip_checklist.dart';
import 'package:yaml/yaml.dart';

class CardProductsSeeds {
  static String get towelieProductsSeeds {
    return Intl.message(
      '''**#1 rule of cannabis growing; genetics matter!**

With the overwhelming number of **strains available** and new ones coming out regularly;
it's essential that you pick something that **meets your needs**!
The **SuperGreenLab** community seebank list is here to help you find **the strain for you**.
''',
      name: 'towelieProductsSeeds',
      desc: 'Towelie seeds products',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static Future createProductsSeeds(Feed feed) async {
    YamlMap yml = loadYaml(await rootBundle.loadString('assets/products/initial_checklist_seeds.yml'));
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_PRODUCTS',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardProductsSeeds.towelieProductsSeeds,
        'products': yml['products'],
        'buttons': [
          TowelieButtonShowProductsGrowingMedium.createButton(),
          TowelieButtonSkipChecklist.createButton(),
        ],
      })),
    ));
  }
}
