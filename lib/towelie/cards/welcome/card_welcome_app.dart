import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_i_need_help.dart';

class CardWelcomeApp {
  static String get towelieWelcomeApp {
    return Intl.message(
      '''Welcome to SuperGreenLab's grow diary app!
===
Hey man, **welcome here**, my name’s **Towelie**, I’m here to make sure you don’t forget anything about your plant!

To start off on a right foot, we made a checklist of all the stuffs you'll need to start growing.

Do you need a hand to start growing?
''',
      name: 'towelieWelcomeApp',
      desc: 'Towelie Welcome App',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createWelcomeAppCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
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
