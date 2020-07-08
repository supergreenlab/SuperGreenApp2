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

import 'dart:async';

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/params/plant_infos_settings.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/plant_infos_bloc.dart';

class LocalPlantInfosBloc extends PlantInfosBloc {
  final Plant plant;

  StreamSubscription<Plant> plantStream;
  StreamSubscription<FeedMedia> feedMediaStream;

  LocalPlantInfosBloc(this.plant) : super();

  @override
  Stream<PlantInfosState> loadPlant() async* {
    this.plantInfos = PlantInfos(plant.name, null, null, null);
    plantStream =
        RelDB.get().plantsDAO.watchPlant(plant.id).listen(plantUpdated);
    feedMediaStream = RelDB.get()
        .feedsDAO
        .watchLastFeedMedia(plant.feed)
        .listen(feedMediaUpdated);
  }

  @override
  Stream<PlantInfosState> updatePlant(PlantInfosSettings settings) async* {
    PlantsCompanion plant = PlantsCompanion(
        id: Value(this.plant.id), settings: Value(settings.toJSON()));
    await RelDB.get().plantsDAO.updatePlant(plant);
    plantInfosLoaded(plantInfos.copyWith(settings: settings));
  }

  void plantUpdated(Plant plant) {
    PlantInfosSettings settings = PlantInfosSettings.fromJSON(plant.settings);
    plantInfosLoaded(plantInfos.copyWith(name: plant.name, settings: settings));
  }

  void feedMediaUpdated(FeedMedia feedMedia) {
    plantInfosLoaded(plantInfos.copyWith(
        filePath: FeedMedias.makeAbsoluteFilePath(feedMedia.filePath),
        thumbnailPath:
            FeedMedias.makeAbsoluteFilePath(feedMedia.thumbnailPath)));
  }

  @override
  Future<void> close() {
    plantStream.cancel();
    feedMediaStream.cancel();
    return super.close();
  }
}
