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
import 'package:super_green_app/data/helpers/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_life_event.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';

class PlantHelper {
  static Future deletePlant(Plant plant, {addDeleted: true}) async {
    plant = await RelDB.get().plantsDAO.getPlant(plant.id);
    await RelDB.get().plantsDAO.deletePlant(plant);
    if (addDeleted && plant.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(DeletesCompanion(
          serverID: Value(plant.serverID), type: Value('plants')));
    }
    Feed feed = await RelDB.get().feedsDAO.getFeed(plant.feed);
    await FeedEntryHelper.deleteFeed(feed);
  }

  static Future deleteBox(Box box, {addDeleted: true}) async {
    box = await RelDB.get().plantsDAO.getBox(box.id);
    await RelDB.get().plantsDAO.deleteBox(box);
    if (addDeleted && box.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(DeletesCompanion(
          serverID: Value(box.serverID), type: Value('boxes')));
    }
  }

  static Future deleteTimelapse(Timelapse timelapse, {addDeleted: true}) async {
    timelapse = await RelDB.get().plantsDAO.getTimelapse(timelapse.id);
    await RelDB.get().plantsDAO.deleteTimelapse(timelapse);
    if (addDeleted && timelapse.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(DeletesCompanion(
          serverID: Value(timelapse.serverID), type: Value('timelapses')));
    }
  }

  static Future updatePlantPhase(
      Plant plant, PlantPhases phase, DateTime date) async {
    plant = await RelDB.get().plantsDAO.getPlant(plant.id);

    List<FeedEntry> lifeEvents = await RelDB.get()
        .feedsDAO
        .getFeedEntriesForFeedWithType(plant.feed, 'FE_LIFE_EVENT');
    FeedEntry lifeEvent = lifeEvents.firstWhere((fe) {
      FeedLifeEventParams params = FeedLifeEventParams.fromJSON(fe.params);
      return params.phase == phase;
    }, orElse: () => null);
    if (lifeEvent == null) {
      FeedLifeEventParams params = FeedLifeEventParams(phase);
      FeedEntriesCompanion lifeEventCompanion = FeedEntriesCompanion.insert(
        feed: plant.feed,
        date: date,
        type: 'FE_LIFE_EVENT',
        params: Value(params.toJSON()),
      );
      await FeedEntryHelper.addFeedEntry(lifeEventCompanion);
    } else {
      FeedEntriesCompanion lifeEventCompanion = FeedEntriesCompanion(
        id: Value(lifeEvent.id),
        date: Value(date),
        synced: Value(false),
      );
      await FeedEntryHelper.updateFeedEntry(lifeEventCompanion);
    }

    PlantSettings plantSettings = PlantSettings.fromJSON(plant.settings);
    plantSettings = plantSettings.setDateForPhase(phase, date);
    PlantsCompanion plantsCompanion = PlantsCompanion(
      id: Value(plant.id),
      settings: Value(plantSettings.toJSON()),
      synced: Value(false),
    );
    await RelDB.get().plantsDAO.updatePlant(plantsCompanion);
  }
}
