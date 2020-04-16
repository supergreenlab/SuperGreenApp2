import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_view_plant.dart';

class CardPlantCreated {
  static String get toweliePlantCreated {
    return Intl.message(
      '''Awesome, **you created your first plant**!

You can access your newly plant feed either by **pressing the home button below**, or the **View plant** button below.
''',
      name: 'toweliePlantCreated',
      desc: 'Towelie Plant Created',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantCreatedCard(Feed feed, Plant plant) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantCreated.toweliePlantCreated,
        'buttons': [
          TowelieButtonViewPlant.createButton(plant),
        ]
      })),
    ));
  }
}
