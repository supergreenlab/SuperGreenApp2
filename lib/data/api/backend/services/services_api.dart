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

import 'package:http/http.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/services/models/alerts.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';

class ServicesAPI {
  Future<AlertsSettings> getPlantAlertSettings(String plantID) async {
    Response resp = await BackendAPI()
        .apiClient
        .get(Uri.parse('${BackendAPI().serverHost}/plant/$plantID/alerts/settings'), headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('getPlantAlertSettings failed: ${resp.body}', data: {'plantID': plantID});
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return AlertsSettings.fromMap(data);
  }

  Future setPlantAlertSettings(String plantID, AlertsSettings alertsSettings) async {
    Map<String, dynamic> obj = alertsSettings.toMap();
    Response resp =
        await BackendAPI().apiClient.put(Uri.parse('${BackendAPI().serverHost}/plant/$plantID/alerts/settings'),
            headers: {
              'Content-Type': 'application/json',
              'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
            },
            body: JsonEncoder().convert(obj));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('setPlantAlertSettings failed: ${resp.body}', data: {'plantID': plantID});
    }
  }
}
