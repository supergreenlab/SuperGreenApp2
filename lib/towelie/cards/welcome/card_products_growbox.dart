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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_show_products_bundle.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_show_products_seed.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_skip_checklist.dart';
import 'package:yaml/yaml.dart';

class CardProductsGrowbox {
  static String get towelieGrowboxProducts {
    return Intl.message(
      '''**First step to unlimited weed: The Growbox**
The most important part of the process is to choose your grow space.
When using the SuperGreenLab controller and its 6 LED panels,
you an use 4 or 5 LED panels for blooming, and keep 1 or 2 for vegging.
''',
      name: 'towelieGrowboxProducts',
      desc: 'Towelie Growbox Products',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createProductsGrowbox(Feed feed) async {
    YamlMap yml =
        loadYaml(await rootBundle.loadString('assets/products/initial_checklist_growbox.yml'));
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_PRODUCTS',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardProductsGrowbox.towelieGrowboxProducts,
        'products': yml['products'],
        'buttons': [
          TowelieButtonShowProductsBundle.createButton(),
          TowelieButtonSkipChecklist.createButton(),
        ],
      })),
    ));
  }
}
