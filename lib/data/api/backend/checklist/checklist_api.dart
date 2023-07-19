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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/checklist/checklists.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class ChecklistAPI {
  Future<ChecklistsCompanion> getChecklist(String plantID) async {
    Response resp =
        await BackendAPI().apiClient.get(Uri.parse('${BackendAPI().serverHost}/checklist/$plantID'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('/checklist/$plantID failed with error: ${resp.body}', fwdThrow: true);
    }
    Map<String, dynamic> checklistMap = JsonDecoder().convert(resp.body);
    return Checklists.fromMap(checklistMap);
  }

  Future<ChecklistSeedsCompanion> seeds() async {
    Response resp = await BackendAPI().apiClient.get(Uri.parse('${BackendAPI().serverHost}/seeds'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('/seeds failed with error: ${resp.body}', fwdThrow: true);
    }
    Map<String, dynamic> checklistMap = JsonDecoder().convert(resp.body);
    return ChecklistSeeds.fromMap(checklistMap);
  }

  Future syncChecklistSeed(ChecklistSeed checklistSeed) async {
    Map<String, dynamic> obj = await ChecklistSeeds.toMap(checklistSeed);
    String? serverID = await BackendAPI().postPut('/checklist/seed', obj);

    ChecklistSeedsCompanion checklistSeedsCompanion =
        ChecklistSeedsCompanion(id: Value(checklistSeed.id), synced: Value(true));
    if (serverID != null) {
      checklistSeedsCompanion = checklistSeedsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().checklistsDAO.updateChecklistSeed(checklistSeedsCompanion);
  }

  Future<List<ChecklistSeedsCompanion>> unsyncedCHecklistSeeds() async {
    Map<String, dynamic> syncData = await _unsynced("ChecklistSeeds");
    List<dynamic> maps = syncData['items'];
    List<ChecklistSeedsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        ChecklistSeedsCompanion fe = await ChecklistSeeds.fromMap(maps[i]);
        if (fe is SkipChecklistSeedsCompanion) {
          continue;
        }
        results.add(fe);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future<Map<String, dynamic>> _unsynced(String type) async {
    Response resp = await BackendAPI().apiClient.get(Uri.parse('${BackendAPI().serverHost}/sync$type'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('_unsynced failed: ${resp.body}', data: {"type": type});
    }
    return JsonDecoder().convert(resp.body);
  }
}
