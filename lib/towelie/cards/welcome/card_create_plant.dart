import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_create_plant.dart';

class CardCreatePlant {
  static String get towelieCreatePlant {
    return Intl.message(
      '''Alright we're ready to start your **first plant!**

The app works like this:
- you **create a plant**
- setup **your green lab**
- control and monitor it with a **SuperGreenController** (optional)

Once this is done, you will have access to it's **feed**, it's like a timeline of the **plant's life**.
Whenever you water, change light parameters, or train the plant, or any other action,
it will log it in the plant's feed, so you can **share it**, or **replay it** for your next grow!

Press the **Create plant** button below.
''',
      name: 'towelieCreatePlant',
      desc: 'Towelie Create Plant',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static Future createCreatePlantCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardCreatePlant.towelieCreatePlant,
        'buttons': [
          TowelieButtonCreatePlant.createButton(),
        ],
      })),
    ));
  }
}
