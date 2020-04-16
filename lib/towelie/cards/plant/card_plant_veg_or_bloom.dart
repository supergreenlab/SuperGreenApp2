import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_phase.dart';

class CardPlantVegOrBloom {
  static String get toweliePlantVegOrBloom {
    return Intl.message(
      '''Is the plant in **veg** or **bloom**?''',
      name: 'toweliePlantVegOrBloom',
      desc: 'Towelie Plant Veg or bloom',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantVegOrBloom(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantVegOrBloom.toweliePlantVegOrBloom,
        'buttons': [
          TowelieButtonPlantVegStage.createButton(),
          TowelieButtonPlantBloomStage.createButton(),
        ]
      })),
    ));
  }
}
