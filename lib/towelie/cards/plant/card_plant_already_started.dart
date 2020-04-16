import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_already_started.dart';

class CardPlantAlreadyStarted {
  static String get toweliePlantAlreadyStarted {
    return Intl.message(
      '''Is this plant mid grow cycle?''',
      name: 'toweliePlantAlreadyStarted',
      desc: 'Towelie Plant already started',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantAlreadyStartedCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantAlreadyStarted.toweliePlantAlreadyStarted,
        'buttons': [
          TowelieButtonPlantAlreadyStarted.createButton(),
          TowelieButtonPlantNotStarted.createButton(),
        ]
      })),
    ));
  }
}
