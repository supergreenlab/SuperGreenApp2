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

import 'package:hive/hive.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';

class AppDB {
  static final AppDB _instance = AppDB._newInstance();

  Box _settingsDB;
  Box _miscDB;

  String documentPath;
  String tmpPath;

  factory AppDB() => _instance;

  AppDB._newInstance();

  Future<void> init() async {
    _settingsDB = await Hive.openBox('settings');
    _miscDB = await Hive.openBox('misc');
  }

  AppData getAppData() {
    return _settingsDB.get('data', defaultValue: AppData());
  }

  Stream<BoxEvent> watchAppData() {
    return _settingsDB.watch(key: 'data');
  }

  void setFirstStart(firstStart) {
    AppData appData = getAppData();
    appData.firstStart = firstStart;
    setAppData(appData);
  }

  void setLastPlant(int plantID) {
    AppData appData = getAppData();
    appData.lastPlantID = plantID;
    setAppData(appData);
  }

  void setAllowAnalytics(bool allowAnalytics) {
    AppData appData = getAppData();
    appData.allowAnalytics = allowAnalytics;
    setAppData(appData);
  }

  void setFreedomUnits(bool freedomUnits) {
    AppData appData = getAppData();
    appData.freedomUnits = freedomUnits;
    setAppData(appData);
  }

  void setJWT(String jwt) {
    AppData appData = getAppData();
    appData.jwt = jwt;
    setAppData(appData);
  }

  void setStoreGeo(String storeGeo) {
    AppData appData = getAppData();
    appData.storeGeo = storeGeo;
    setAppData(appData);
  }

  void setAppData(AppData appData) {
    _settingsDB.put('data', appData);
  }

  void setTipDone(String tipID) {
    _miscDB.put('$tipID.done', true);
  }

  bool isTipDone(String tipID) {
    return _miscDB.get('$tipID.done', defaultValue: false);
  }
}
