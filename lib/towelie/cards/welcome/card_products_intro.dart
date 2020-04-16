import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';

class CardProductsIntro {
    static String get towelieProductsIntro {
    return Intl.message(
      '''
''',
      name: 'towelieProductsIntro',
      desc: 'Towelie Products Intro',
      locale: SGLLocalizations.current.localeName,
    );
  }
  
  static Future createProductsIntro(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': CardProductsIntro.towelieProductsIntro,
        'products': [],
      })),
    ));
  }
}
