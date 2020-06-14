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

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/helpers/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_show_products_nutrients.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_skip_checklist.dart';
import 'package:yaml/yaml.dart';

class CardProductsGrowingMedium {
  static String get towelieProductsGrowingMedium {
    return Intl.message(
      '''**Your plants' new favorite diet - simple and efficient**

The **trick** to growing in soil: water **only** when the top soil is dry **1 knuckle deep**
and the pot feels light. Simple as that.
''',
      name: 'towelieProductsGrowingMedium',
      desc: 'Towelie seeds products',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createProductsGrowingMedium(Feed feed) async {
    YamlMap yml =
        loadYaml(await rootBundle.loadString('assets/products/initial_checklist_growing_medium.yml'));
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_PRODUCTS',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardProductsGrowingMedium.towelieProductsGrowingMedium,
        'products': yml['products'],
        'buttons': [
          TowelieButtonShowProductsNutrients.createButton(),
          TowelieButtonSkipChecklist.createButton(),
        ],
      })),
    ));
  }
}
