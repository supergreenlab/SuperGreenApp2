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
import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:super_green_app/data/rel/box/boxes.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/l10n.dart';

part 'rel_db.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [
  Devices,
  Modules,
  Params,
  Boxes,
  Feeds,
  FeedEntries,
  FeedMedias,
], daos: [
  DevicesDAO,
  BoxesDAO,
  FeedsDAO
])
class RelDB extends _$RelDB {
  static RelDB _instance;

  factory RelDB.get() {
    if (_instance == null) {
      _instance = RelDB();
    }
    return _instance;
  }

  // we tell the database where to store the data with this constructor
  RelDB() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          if (details.wasCreated) {
            int feed = await this
                .feedsDAO
                .addFeed(FeedsCompanion(name: Value("SuperGreenLab")));
            await this.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
                  type: 'FE_TOWELIE_INFO',
                  feed: feed,
                  date: DateTime.now(),
                  params: Value(JsonEncoder().convert({
                    'text': SGLLocalizations.current.towelieWelcomeApp,
                    'top_pic': 'assets/feed_card/logo_sgl.svg',
                    'buttons': [
                      {
                        'type': 'CREATE_BOX',
                        'title': 'CREATE FIRST BOX',
                      }
                    ],
                  })),
                ));
          }
        },
      );
}
