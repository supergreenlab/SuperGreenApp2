import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/helpers/feed_entry_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/combo/towelie_button_push_route_feed_media.dart';

class CardPlantTutoTakePic {
  static String get toweliePlantTutoTakePic {
    return Intl.message(
      '''Alright **let's start**!
One first thing you can do to **start** this journey is to **take a picture** of your **plant**.''',
      name: 'toweliePlantTutoTakePic',
      desc: 'Towelie Plant tuto take pic',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantTutoTakePic(Feed feed) async {
    final db = RelDB.get();
    Plant plant = await db.plantsDAO.getPlantWithFeed(feed.id);
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantTutoTakePic.toweliePlantTutoTakePic,
        'buttons': [
          TowelieButtonPushRouteFeedMedia.createButton('Take pic', plant.id),
        ]
      })),
    ));
  }
}
