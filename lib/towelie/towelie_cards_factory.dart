/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_box_already_started.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_box_auto.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_box_bloom_stage.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_box_not_started.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_box_photo.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_box_veg_stage.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_create_box.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_dont_want_to_buy.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_got_sgl_bundle.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_i_ordered_one.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_i_want_one.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_no_sgl_bundle.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_not_received.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_tuto_take_pic.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_view_plant.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_yes_received.dart';

class TowelieCardsFactory {
  static Future createWelcomeAppCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
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
      isNew: Value(true),
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
      isNew: Value(true),
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
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieCreateBox,
        'buttons': [
          TowelieButtonCreateBox.createButton(),
        ],
      })),
    ));
  }

  static Future createWelcomePlantCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeBox,
        'buttons': [],
      })),
    ));
  }

  static Future createBoxCreatedCard(Feed feed, Plant box) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieBoxCreated,
        'buttons': [
          TowelieButtonViewPlant.createButton(box),
        ]
      })),
    ));
  }

  static Future createBoxAlreadyStartedCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieBoxAlreadyStarted,
        'buttons': [
          TowelieButtonBoxAlreadyStarted.createButton(),
          TowelieButtonBoxNotStarted.createButton(),
        ]
      })),
    ));
  }

  static Future createPlantAutoOrPhoto(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieBoxAutoOrPhoto,
        'buttons': [
          TowelieButtonBoxAuto.createButton(),
          TowelieButtonBoxPhoto.createButton(),
        ]
      })),
    ));
  }

  static Future createBoxVegOrBloom(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieBoxVegOrBloom,
        'buttons': [
          TowelieButtonBoxVegStage.createButton(),
          TowelieButtonBoxBloomStage.createButton(),
        ]
      })),
    ));
  }

  static Future createBoxTutoTakePic(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieBoxTutoTakePic,
        'buttons': [
          TowelieButtonTutoTakePic.createButton(),
        ]
      })),
    ));
  }
}
