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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class PublicPlant extends Equatable {
  final String id;
  final String name;
  final DateTime lastUpdate;
  final String? thumbnailPath;
  final bool followed;
  final int nFollows;
  final PlantSettings settings;
  final BoxSettings boxSettings;

  PublicPlant(
      {required this.id,
      required this.name,
      this.thumbnailPath,
      required this.lastUpdate,
      required this.followed,
      required this.nFollows,
      required this.settings,
      required this.boxSettings});

  static PublicPlant fromMap(Map<String, dynamic> map) => PublicPlant(
      id: map['id'],
      name: map['name'],
      thumbnailPath: map['thumbnailPath'],
      lastUpdate: DateTime.parse(map['lastUpdate'] as String),
      followed: map['followed'],
      nFollows: map['nFollows'],
      settings: PlantSettings.fromJSON(map['settings'] ?? '{}'),
      boxSettings: BoxSettings.fromJSON(map['boxSettings'] ?? '{}'));

  @override
  List<Object?> get props => [id, name, lastUpdate, thumbnailPath, followed, nFollows, settings, boxSettings];
}
