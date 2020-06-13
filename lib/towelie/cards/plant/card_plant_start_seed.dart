import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/helpers/feed_entry_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/misc/towelie_button_create_account.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_start_seedling.dart';

class CardPlantStartSeedling {
  static String get toweliePlantStartSeedling {
    return Intl.message(
      '''Alright, let me know when you're **ready to start** by pressing the button below.
In the meantime you can also **create an account**:P that will enable backups, remote control, sharing, etc...''',
      name: 'toweliePlantStartSeedling',
      desc: 'Towelie plant start seedling',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createPlantStartSeedling(Feed feed) async {
    await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardPlantStartSeedling.toweliePlantStartSeedling,
        'buttons': [
          TowelieButtonStartSeedling.createButton(),
          TowelieButtonCreateAccount.createButton(),
        ]
      })),
    ));
  }
}
