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
import 'package:super_green_app/towelie/buttons/towelie_button_create_plant.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_dont_want_to_buy.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_got_sgl_bundle.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_i_ordered_one.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_i_want_one.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_no_sgl_bundle.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_not_received.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_plant_already_started.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_plant_auto.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_plant_bloom_stage.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_plant_not_started.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_plant_photo.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_plant_veg_stage.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_push_route_feed_media.dart';
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

  static Future createCreatePlantCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieCreatePlant,
        'buttons': [
          TowelieButtonCreatePlant.createButton(),
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
        'text': SGLLocalizations.current.towelieWelcomePlant,
        'buttons': [],
      })),
    ));
  }

  static Future createPlantCreatedCard(Feed feed, Plant plant) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.toweliePlantCreated,
        'buttons': [
          TowelieButtonViewPlant.createButton(plant),
        ]
      })),
    ));
  }

  static Future createPlantAlreadyStartedCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.toweliePlantAlreadyStarted,
        'buttons': [
          TowelieButtonPlantAlreadyStarted.createButton(),
          TowelieButtonPlantNotStarted.createButton(),
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
        'text': SGLLocalizations.current.toweliePlantAutoOrPhoto,
        'buttons': [
          TowelieButtonPlantAuto.createButton(),
          TowelieButtonPlantPhoto.createButton(),
        ]
      })),
    ));
  }

  static Future createPlantVegOrBloom(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.toweliePlantVegOrBloom,
        'buttons': [
          TowelieButtonPlantVegStage.createButton(),
          TowelieButtonPlantBloomStage.createButton(),
        ]
      })),
    ));
  }

  static Future createPlantTutoTakePic(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    final db = RelDB.get();
    Plant plant = await db.plantsDAO.getPlantWithFeed(feed.id);
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      isNew: Value(true),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.toweliePlantTutoTakePic,
        'buttons': [
          TowelieButtonPushRouteFeedMedia.createButton('Take pic', plant.id),
        ]
      })),
    ));
  }
}
