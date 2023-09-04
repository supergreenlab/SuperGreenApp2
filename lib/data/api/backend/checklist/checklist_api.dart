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
import 'package:super_green_app/data/api/backend/userend/userend_helper.dart';
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

  Future<List<ChecklistCollectionsCompanion>> getChecklistCollections() async {
    Response resp =
        await BackendAPI().apiClient.get(Uri.parse('${BackendAPI().serverHost}/checklistcollections'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    Map<String, dynamic> maps = JsonDecoder().convert(resp.body)['checklistcollections'];
    List<ChecklistCollectionsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        ChecklistCollectionsCompanion fe = await ChecklistCollections.fromMap(maps[i]);
        results.add(fe);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future subscribeCollection(String collectionID, String plantID) async {
    await BackendAPI().apiClient.post(Uri.parse('${BackendAPI().serverHost}/checklistcollection/$collectionID/sub/$plantID'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
  }

  Future syncChecklistSeed(ChecklistSeed checklistSeed) async {
    Map<String, dynamic> obj = await ChecklistSeeds.toMap(checklistSeed);
    if (checklistSeed.serverID != null) {
      obj.remove('checklistID');
    }
    String? serverID = await BackendAPI().postPut('/checklistseed', obj);

    ChecklistSeedsCompanion checklistSeedsCompanion =
        ChecklistSeedsCompanion(id: Value(checklistSeed.id), synced: Value(true));
    if (serverID != null) {
      checklistSeedsCompanion = checklistSeedsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().checklistsDAO.updateChecklistSeed(checklistSeedsCompanion);
  }

  Future<List<ChecklistSeedsCompanion>> unsyncedChecklistSeeds() async {
    Map<String, dynamic> syncData = await UserEndHelper.unsynced("ChecklistSeeds");
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

  Future<String?> syncChecklist(Checklist checklist) async {
    Map<String, dynamic> obj = await Checklists.toMap(checklist);
    String? serverID = await BackendAPI().postPut('/checklist', obj);

    ChecklistsCompanion checklistsCompanion = ChecklistsCompanion(id: Value(checklist.id), synced: Value(true));
    if (serverID != null) {
      checklistsCompanion = checklistsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().checklistsDAO.updateChecklist(checklistsCompanion);
    return serverID;
  }

  Future<List<ChecklistsCompanion>> unsyncedChecklists() async {
    Map<String, dynamic> syncData = await UserEndHelper.unsynced("Checklists");
    List<dynamic> maps = syncData['items'];
    List<ChecklistsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        ChecklistsCompanion fe = await Checklists.fromMap(maps[i]);
        if (fe is SkipChecklistsCompanion) {
          continue;
        }
        results.add(fe);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future syncChecklistLog(ChecklistLog checklistLog) async {
    Map<String, dynamic> obj = await ChecklistLogs.toMap(checklistLog);
    String? serverID = await BackendAPI().postPut('/checklistlog', obj);

    ChecklistLogsCompanion checklistLogsCompanion =
        ChecklistLogsCompanion(id: Value(checklistLog.id), synced: Value(true));
    if (serverID != null) {
      checklistLogsCompanion = checklistLogsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().checklistsDAO.updateChecklistLog(checklistLogsCompanion);
  }

  Future<List<ChecklistLogsCompanion>> unsyncedChecklistLog() async {
    Map<String, dynamic> syncData = await UserEndHelper.unsynced("ChecklistLogs");
    List<dynamic> maps = syncData['items'];
    List<ChecklistLogsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        ChecklistLogsCompanion fe = await ChecklistLogs.fromMap(maps[i]);
        if (fe is SkipChecklistLogsCompanion) {
          continue;
        }
        results.add(fe);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }
}
