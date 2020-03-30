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

import 'package:hive/hive.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';

class AppDB {
  static final AppDB _instance = AppDB._newInstance();

  Box _settingsDB;
  Box _miscDB;
  Box _boxDB;

  factory AppDB() => _instance;

  AppDB._newInstance();

  Future<void> init() async {
    _settingsDB = await Hive.openBox('settings');
    _miscDB = await Hive.openBox('misc');
    _boxDB = await Hive.openBox('box');
  }

  AppData getAppData() {
    return _settingsDB.get('data', defaultValue: AppData());
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

  void setAppData(AppData appData) {
    _settingsDB.put('data', appData);
  }

  void setTipDone(String tipID) {
    _miscDB.put('$tipID.done', true);
  }

  bool isTipDone(String tipID) {
    return _miscDB.get('$tipID.done', defaultValue: false);
  }

  Future setBoxSettings(String boxID, Map<String, dynamic> settings) async {
    await _boxDB.put('$boxID.settings', JsonEncoder().convert(settings));
    await _boxDB.put('$boxID.dirty', true);
  }

  Map<String, dynamic> getBoxSettings(String boxID) {
    Map<String, dynamic> settings = JsonDecoder()
        .convert(_boxDB.get('$boxID.settings', defaultValue: '{}'));
    return {
      'schedule':
          settings['schedule'] ?? 'VEG', // Any of the schedule keys below
      'schedules': {
        'VEG': {
          'ON_HOUR': settings['schedules']['VEG']['ON_HOUR'] ?? 3,
          'ON_MIN': settings['schedules']['VEG']['ON_MIN'] ?? 0,
          'OFF_HOUR': settings['schedules']['VEG']['OFF_HOUR'] ?? 21,
          'OFF_MIN': settings['schedules']['VEG']['OFF_MIN'] ?? 0,
        },
        'BLOOM': {
          'ON_HOUR': settings['schedules']['BLOOM']['ON_HOUR'] ?? 6,
          'ON_MIN': settings['schedules']['BLOOM']['ON_MIN'] ?? 0,
          'OFF_HOUR': settings['schedules']['BLOOM']['OFF_HOUR'] ?? 18,
          'OFF_MIN': settings['schedules']['BLOOM']['OFF_MIN'] ?? 0,
        },
        'AUTO': {
          'ON_HOUR': settings['schedules']['AUTO']['ON_HOUR'] ?? 0,
          'ON_MIN': settings['schedules']['AUTO']['ON_MIN'] ?? 0,
          'OFF_HOUR': settings['schedules']['AUTO']['OFF_HOUR'] ?? 0,
          'OFF_MIN': settings['schedules']['AUTO']['OFF_MIN'] ?? 0,
        },
      }
    };
  }
}
