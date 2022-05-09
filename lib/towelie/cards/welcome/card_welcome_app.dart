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
import 'package:super_green_app/towelie/buttons/welcome/towelie_button_i_need_help.dart';

class CardWelcomeApp {
  static String get towelieWelcomeApp {
    return Intl.message(
      '''Welcome to SuperGreenLab's grow diary app!
===
Hey man, **welcome here**, my name’s **Towelie**, I’m here to make sure you don’t forget anything about your plant!

To start off on a right foot, we made a **quick start checklist** of all the stuffs you'll need to **start growing**.

Do you need a hand to start growing?
''',
      name: 'towelieWelcomeApp',
      desc: 'Towelie Welcome App',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static Future createWelcomeAppCard(Feed feed) async {
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': towelieWelcomeApp,
        'buttons': [
          TowelieButtonINeedHelp.createButton(),
          TowelieButtonIDontNeedHelp.createButton(),
        ],
      })),
    ));
  }
}
