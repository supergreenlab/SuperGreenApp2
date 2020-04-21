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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_show_products_growbox.dart';

class CardProductsIntro {
  static String get towelieProductsIntro {
    return Intl.message(
      '''**Thanks for checking out our quick start checklist:)**

This is a **selection** of products **we** and the **community** like and got **good results** with.

The topics covered are:

- Build a **growbox**
- Add **light and ventilation**
- Get some **seeds**
- **Growing medium**
- **Nutrients**
''',
      name: 'towelieProductsIntro',
      desc: 'Towelie Products Intro',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createProductsIntro(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert(
        {
          'text': CardProductsIntro.towelieProductsIntro,
          'buttons': [
            TowelieButtonShowProductsGrowbox.createButton(),
          ]
        },
      )),
    ));
  }
}
