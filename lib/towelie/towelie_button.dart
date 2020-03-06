import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

abstract class TowelieButton {
  Stream<TowelieBlocState> buttonPressed(TowelieBlocEventCardButtonPressed event);

  Future removeButtons(FeedEntry feedEntry) async {
    final fdb = RelDB.get().feedsDAO;
    final Map<String, dynamic> params = JsonDecoder().convert(feedEntry.params);
    params['buttons'] = [];
    await fdb.updateFeedEntry(feedEntry
        .createCompanion(true)
        .copyWith(params: Value(JsonEncoder().convert(params))));
  }
}
