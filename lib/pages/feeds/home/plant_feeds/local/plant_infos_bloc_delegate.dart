/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class LocalPlantInfosBlocDelegate extends PlantInfosBlocDelegate {
  late Box box;
  late Plant plant;

  StreamSubscription<Box>? boxStream;
  StreamSubscription<Plant>? plantStream;
  StreamSubscription<FeedMedia>? feedMediaStream;

  LocalPlantInfosBlocDelegate(this.plant);

  @override
  void loadPlant() async {
    plant = await RelDB.get().plantsDAO.getPlant(plant.id);
    box = await RelDB.get().plantsDAO.getBox(plant.box);
    this.plantInfos = PlantInfos(plant.name, null, null, null, null, true);
    plantStream = RelDB.get().plantsDAO.watchPlant(plant.id).listen(plantUpdated);
    boxStream = RelDB.get().plantsDAO.watchBox(plant.box).listen(boxUpdated);
    feedMediaStream = RelDB.get().feedsDAO.watchLastFeedMedia(plant.feed).listen(feedMediaUpdated);
  }

  @override
  Stream<PlantInfosBlocState> updateSettings(PlantInfos plantInfos) async* {
    String plantSettingsJSON = plantInfos.plantSettings!.toJSON();
    if (plant.settings != plantSettingsJSON) {
      PlantsCompanion plant =
          PlantsCompanion(id: Value(this.plant.id), settings: Value(plantSettingsJSON), synced: Value(false));
      await RelDB.get().plantsDAO.updatePlant(plant);
    }
    String boxSettingsJSON = plantInfos.boxSettings!.toJSON();
    if (box.settings != boxSettingsJSON) {
      BoxesCompanion box =
          BoxesCompanion(id: Value(this.box.id), settings: Value(boxSettingsJSON), synced: Value(false));
      await RelDB.get().plantsDAO.updateBox(box);
    }
  }

  @override
  Stream<PlantInfosBlocState> updatePhase(PlantPhases phase, DateTime date) async* {
    await PlantHelper.updatePlantPhase(plant, phase, date);
  }

  void plantUpdated(Plant plant) {
    this.plant = plant;
    PlantSettings settings = PlantSettings.fromJSON(plant.settings);
    plantInfosLoaded(plantInfos!.copyWith(name: plant.name, plantSettings: settings));
  }

  void boxUpdated(Box box) {
    this.box = box;
    BoxSettings settings = BoxSettings.fromJSON(box.settings);
    plantInfosLoaded(plantInfos!.copyWith(boxSettings: settings));
  }

  void feedMediaUpdated(FeedMedia feedMedia) {
    plantInfosLoaded(plantInfos!.copyWith(
        filePath: FeedMedias.makeAbsoluteFilePath(feedMedia.filePath),
        thumbnailPath: FeedMedias.makeAbsoluteFilePath(feedMedia.thumbnailPath)));
  }

  @override
  Future<void> close() async {
    await boxStream?.cancel();
    await plantStream?.cancel();
    await feedMediaStream?.cancel();
  }
}
