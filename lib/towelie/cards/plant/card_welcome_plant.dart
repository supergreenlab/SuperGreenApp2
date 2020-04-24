import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';

class CardWelcomePlant {
  static String get towelieWelcomePlant {
    return Intl.message(
      '''**Welcome to your plant feed!**
This is where you can **keep a history** of your plant's life.

Everytime you **water**, **train**, or even just **observe something** about your plant,
you can **add an item** to the feed.

So you can see the **evolution** of your plant, **repeat it** later, or **share it!**''',
      name: 'towelieWelcomePlant',
      desc: 'Towelie Welcome Plant',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createWelcomePlantCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardWelcomePlant.towelieWelcomePlant,
        'buttons': [],
      })),
    ));
  }
}
