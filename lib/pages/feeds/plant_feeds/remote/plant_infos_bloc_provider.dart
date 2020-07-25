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

import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';

class RemotePlantInfosBlocProvider extends PlantInfosBlocProvider {
  final String plantID;

  RemotePlantInfosBlocProvider(this.plantID);

  @override
  void loadPlant() async {
    Map<String, dynamic> plant = await FeedsAPI().publicPlant(plantID);
    plantInfosLoaded(PlantInfos(
        plant['name'],
        FeedsAPI().absoluteFileURL(plant['filePath']),
        FeedsAPI().absoluteFileURL(plant['thumbnailPath']),
        BoxSettings.fromJSON(plant['boxSettings']),
        PlantSettings.fromJSON(plant['settings']),
        false));
  }

  @override
  Stream<PlantInfosState> updateSettings(PlantInfos plantInfos) async* {}

  @override
  Stream<PlantInfosState> updatePhase(PlantPhases phase, DateTime date) async*{}

  @override
  Future<void> close() async {}
}
