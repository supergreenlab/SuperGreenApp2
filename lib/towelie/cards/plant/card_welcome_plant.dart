import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';

class CardWelcomePlant {
  static String get towelieWelcomePlant {
    return Intl.message(
      '''**Welcome to your plant feed!**
This is where you will modify your plant’s parameters, everytime you change your **light dimming**, change from **veg to bloom**, or change your **ventilation**, **it will log a card here**, so you’ll have a clear history of all changes you did, and how it affected the plant’s environment.

This is also where you will log the actions **you want to remember**: last time you watered for example.

The app will also add log entries for temperature or humidity **heads up and reminders** you can set or
receive from the app.

And all this feed can be reviewed, shared or replayed later, **and that’s awesome**.''',
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
