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

class CardBaseProducts {
    static String get towelieProducts {
    return Intl.message(
      '''
''',
      name: 'towelieBaseProducts',
      desc: 'Towelie Base Products',
      locale: SGLLocalizations.current.localeName,
    );
  }
  
  static Future createBaseProducts(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_PRODUCTS',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardBaseProducts.towelieProducts,
        'products': [
          
        ],
      })),
    ));
  }
}
