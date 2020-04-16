import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_type.dart';

class PlantAutoOrPhoto {
  static String get toweliePlantAutoOrPhoto {
    return Intl.message(
      '''To better guide you to a **successful harvest**, I'll need a bit **more informations** about your plant:)
Is this plant an **auto** or **photo** strain?''',
      name: 'toweliePlantAutoOrPhoto',
      desc: 'Towelie Plant auto or photo',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantAutoOrPhoto(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': PlantAutoOrPhoto.toweliePlantAutoOrPhoto,
        'buttons': [
          TowelieButtonPlantAuto.createButton(),
          TowelieButtonPlantPhoto.createButton(),
        ]
      })),
    ));
  }
}
