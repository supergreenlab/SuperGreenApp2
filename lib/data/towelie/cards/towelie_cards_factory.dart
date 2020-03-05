import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_create_box.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_dont_want_to_buy.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_got_sgl_bundle.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_i_ordered_one.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_i_want_one.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_no_sgl_bundle.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_not_received.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_view_box.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button_yes_received.dart';
import 'package:super_green_app/l10n.dart';

class TowelieCardsFactory {
  static Future createWelcomeAppCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeApp,
        'buttons': [
          TowelieButtonGotSGLBundle.createButton(),
          TowelieButtonNoSGLBundle.createButton(),
        ],
      })),
    ));
  }

  static Future createGotSGLBundleCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeAppHasBundle,
        'buttons': [
          TowelieButtonYesReceived.createButton(),
          TowelieButtonNotReceived.createButton(),
        ],
      })),
    ));
  }

  static Future createNoSGLBundleCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeAppNoBundle,
        'buttons': [
          TowelieButtonIWantOne.createButton(),
          TowelieButtonIOrderedOne.createButton(),
          TowelieButtonDontWantToBuy.createButton(),
        ],
      })),
    ));
  }

  static Future createCreateBoxCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieCreateBox,
        'buttons': [
          TowelieButtonCreateBox.createButton(),
        ],
      })),
    ));
  }

  static Future createWelcomeBoxCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeBox,
        'buttons': [],
      })),
    ));
  }

  static Future createBoxCreatedCard(Feed feed, Box box) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieBoxCreated,
        'buttons': [
          TowelieButtonViewBox.createBox(box),
        ]
      })),
    ));
  }
}
