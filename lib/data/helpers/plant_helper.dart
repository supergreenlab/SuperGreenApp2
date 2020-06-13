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

import 'package:moor/moor.dart';
import 'package:super_green_app/data/helpers/feed_entry_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class PlantHelper {
  static Future deletePlant(Plant plant) async {
    plant = await RelDB.get().plantsDAO.getPlant(plant.id);
    await RelDB.get().plantsDAO.deletePlant(plant);
    if (plant.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(DeletesCompanion(
          serverID: Value(plant.serverID), type: Value('plant')));
    }
    Feed feed = await RelDB.get().feedsDAO.getFeed(plant.feed);
    await FeedEntryHelper.deleteFeed(feed);
  }

  static Future deleteBox(Box box) async {
    box = await RelDB.get().plantsDAO.getBox(box.id);
    await RelDB.get().plantsDAO.deleteBox(box);
    if (box.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(
          DeletesCompanion(serverID: Value(box.serverID), type: Value('box')));
    }
  }

  static Future deleteTimelapse(Timelapse timelapse) async {
    timelapse = await RelDB.get().plantsDAO.getTimelapse(timelapse.id);
    await RelDB.get().plantsDAO.deleteTimelapse(timelapse);
    if (timelapse.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(DeletesCompanion(
          serverID: Value(timelapse.serverID), type: Value('timelapse')));
    }
  }
}
