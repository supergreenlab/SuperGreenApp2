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

import 'package:hive/hive.dart';

part 'app_data.g.dart';

@HiveType(typeId: 35)
class AppData {
  @HiveField(0)
  bool firstStart = true;
  @HiveField(1)
  int? lastPlantID;
  @HiveField(2)
  bool allowAnalytics = false;
  @HiveField(3)
  bool freedomUnits = true;
  @HiveField(4)
  String? jwt;
  @HiveField(5)
  String? storeGeo;
  @HiveField(6)
  bool syncOverGSM = false;
  @HiveField(7)
  String? notificationToken;
  @HiveField(8)
  bool notificationTokenSent = false;
  @HiveField(9)
  bool notificationOnStartAsked = false;
  @HiveField(10)
  List<String>? filters = [];
  @HiveField(11)
  String? pinLock;
}
