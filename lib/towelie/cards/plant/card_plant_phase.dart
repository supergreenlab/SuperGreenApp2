import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_phase.dart';

class CardPlantPhase {
  static String get toweliePlantPhase {
    return Intl.message(
      '''Is the plant in **veg** or **bloom**?''',
      name: 'toweliePlantPhase',
      desc: 'Towelie plant phase',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantPhase(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantPhase.toweliePlantPhase,
        'buttons': [
          TowelieButtonPlantSeedPhase.createButton(),
          TowelieButtonPlantSeedlingPhase.createButton(),
          TowelieButtonPlantVegPhase.createButton(),
          TowelieButtonPlantBloomPhase.createButton(),
        ]
      })),
    ));
  }
}
