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
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/helpers/feed_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/common/deletes.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/plant/plants.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedsAPI {
  static final FeedsAPI _instance = FeedsAPI._newInstance();

  bool get loggedIn => AppDB().getAppData().jwt != null;

  String _serverHost;
  String _storageServerHost;
  String _storageServerHostHeader;

  String get serverHost => _serverHost;

  final Client apiClient = Client();
  final Client storageClient = Client();

  factory FeedsAPI() => _instance;

  FeedsAPI._newInstance() {
    if (kReleaseMode || Platform.isIOS) {
      _serverHost = 'https://api2.supergreenlab.com';
      _storageServerHost = 'https://storage.supergreenlab.com';
      _storageServerHostHeader = 'storage.supergreenlab.com';
    } else {
      initUrls();
    }
  }

  void initUrls() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if ((await deviceInfo.androidInfo).isPhysicalDevice) {
      bool local = true;
      _serverHost = local
          ? 'http://192.168.1.122:8080'
          : 'https://devapi2.supergreenlab.com';
      _storageServerHost = local
          ? 'http://192.168.1.122:9000'
          : 'https://devstorage.supergreenlab.com';
      _storageServerHostHeader =
          local ? 'minio:9000' : 'devstorage.supergreenlab.com';
    } else {
      _serverHost = 'http://10.0.2.2:8080';
      _storageServerHost = 'http://10.0.2.2:9000';
      _storageServerHostHeader = 'minio:9000';
    }
  }

  Future login(String nickname, String password) async {
    Response resp = await apiClient.post('$_serverHost/login',
        headers: {'Content-Type': 'application/json'},
        body: JsonEncoder().convert({
          'handle': nickname,
          'password': password,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.log(resp.body);
      throw 'Access denied';
    }
    AppDB().setJWT(resp.headers['x-sgl-token']);
  }

  Future createUser(String nickname, String password) async {
    Response resp = await apiClient.post('$_serverHost/user',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JsonEncoder().convert({
          'nickname': nickname,
          'password': password,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.log(resp.body);
      throw 'createUser failed';
    }
  }

  Future createUserEnd() async {
    return _postPut('/userend', {});
  }

  Future sendDeletes(List<Delete> deletes) async {
    Response resp = await apiClient.post('$_serverHost/deletes',
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert({
          "deletes": deletes
              .map<Map<String, dynamic>>((d) => Deletes.toMap(d))
              .toList(),
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.log(resp.body);
      throw 'sendDeletes failed';
    }
  }

  Future syncPlant(Plant plant) async {
    Map<String, dynamic> obj = await Plants.toMap(plant);
    String serverID = await _postPut('/plant', obj);

    PlantsCompanion plantsCompanion =
        PlantsCompanion(id: Value(plant.id), synced: Value(true));
    if (serverID != null) {
      plantsCompanion = plantsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().plantsDAO.updatePlant(plantsCompanion);
  }

  Future syncBox(Box box) async {
    Map<String, dynamic> obj = await Boxes.toMap(box);
    String serverID = await _postPut('/box', obj);

    BoxesCompanion boxesCompanion =
        BoxesCompanion(id: Value(box.id), synced: Value(true));
    if (serverID != null) {
      boxesCompanion = boxesCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().plantsDAO.updateBox(boxesCompanion);
  }

  Future syncTimelapse(Timelapse timelapse) async {
    Map<String, dynamic> obj = await Timelapses.toMap(timelapse);
    String serverID = await _postPut('/timelapse', obj);

    TimelapsesCompanion timelapsesCompanion =
        TimelapsesCompanion(id: Value(timelapse.id), synced: Value(true));
    if (serverID != null) {
      timelapsesCompanion =
          timelapsesCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().plantsDAO.updateTimelapse(timelapsesCompanion);
  }

  Future syncDevice(Device device) async {
    Map<String, dynamic> obj = await Devices.toMap(device);
    String serverID = await _postPut('/device', obj);

    DevicesCompanion devicesCompanion =
        DevicesCompanion(id: Value(device.id), synced: Value(true));
    if (serverID != null) {
      devicesCompanion = devicesCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().devicesDAO.updateDevice(devicesCompanion);
  }

  Future syncFeed(Feed feed) async {
    Map<String, dynamic> obj = await Feeds.toMap(feed);
    String serverID = await _postPut('/feed', obj);

    FeedsCompanion feedsCompanion =
        FeedsCompanion(id: Value(feed.id), synced: Value(true));
    if (serverID != null) {
      feedsCompanion = feedsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().feedsDAO.updateFeed(feedsCompanion);
  }

  Future syncFeedEntry(FeedEntry feedEntry) async {
    Map<String, dynamic> obj = await FeedEntries.toMap(feedEntry);
    String serverID = await _postPut('/feedEntry', obj);

    FeedEntriesCompanion feedEntriesCompanion =
        FeedEntriesCompanion(id: Value(feedEntry.id), synced: Value(true));
    if (serverID != null) {
      feedEntriesCompanion =
          feedEntriesCompanion.copyWith(serverID: Value(serverID));
    }
    await FeedEntryHelper.updateFeedEntry(feedEntriesCompanion);
  }

  Future syncFeedMedia(FeedMedia feedMedia) async {
    Map<String, dynamic> obj = await FeedMedias.toMap(feedMedia);

    Response resp = await apiClient.post('$_serverHost/feedMediaUploadURL',
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert({
          'fileName': feedMedia.filePath,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      throw 'feedMediaUploadURL failed';
    }
    Map<String, dynamic> uploadUrls = JsonDecoder().convert(resp.body);

    {
      File file = File(FeedMedias.makeAbsoluteFilePath(feedMedia.filePath));
      if (await file.exists()) {
        Logger.log(
            'Trying to upload file ${feedMedia.filePath} (size: ${file.lengthSync()})');
        Response resp = await storageClient.put(
            '$_storageServerHost${uploadUrls['filePath']}',
            body: file.readAsBytesSync(),
            headers: {'Host': _storageServerHostHeader});
        if (resp.statusCode ~/ 100 != 2) {
          throw 'upload failed';
        }
      }
    }

    {
      File file =
          File(FeedMedias.makeAbsoluteFilePath(feedMedia.thumbnailPath));
      if (await file.exists()) {
        Logger.log(
            'Trying to upload file ${feedMedia.thumbnailPath} (size: ${file.lengthSync()})');
        Response resp = await storageClient.put(
            '$_storageServerHost${uploadUrls['thumbnailPath']}',
            body: file.readAsBytesSync(),
            headers: {'Host': _storageServerHostHeader});
        if (resp.statusCode ~/ 100 != 2) {
          throw 'upload failed';
        }
      }
    }

    obj['filePath'] = Uri.parse(uploadUrls['filePath']).path.split('/')[2];
    obj['thumbnailPath'] =
        Uri.parse(uploadUrls['thumbnailPath']).path.split('/')[2];

    String serverID = await _postPut('/feedMedia', obj);

    FeedMediasCompanion feedMediasCompanion =
        FeedMediasCompanion(id: Value(feedMedia.id), synced: Value(true));
    if (serverID != null) {
      feedMediasCompanion =
          feedMediasCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().feedsDAO.updateFeedMedia(feedMediasCompanion);
  }

  Future<List<PlantsCompanion>> unsyncedPlants() async {
    Map<String, dynamic> syncData = await _unsynced("Plants");
    List<dynamic> maps = syncData['items'];
    List<PlantsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Plants.fromMap(maps[i]));
    }
    return results;
  }

  Future<List<BoxesCompanion>> unsyncedBoxes() async {
    Map<String, dynamic> syncData = await _unsynced("Boxes");
    List<dynamic> maps = syncData['items'];
    List<BoxesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Boxes.fromMap(maps[i]));
    }
    return results;
  }

  Future<List<TimelapsesCompanion>> unsyncedTimelapses() async {
    Map<String, dynamic> syncData = await _unsynced("Timelapses");
    List<dynamic> maps = syncData['items'];
    List<TimelapsesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Timelapses.fromMap(maps[i]));
    }
    return results;
  }

  Future<List<DevicesCompanion>> unsyncedDevices() async {
    Map<String, dynamic> syncData = await _unsynced("Devices");
    List<dynamic> maps = syncData['items'];
    return maps.map<DevicesCompanion>((m) => Devices.fromMap(m)).toList();
  }

  Future<List<FeedsCompanion>> unsyncedFeeds() async {
    Map<String, dynamic> syncData = await _unsynced("Feeds");
    List<dynamic> maps = syncData['items'];
    List<FeedsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Feeds.fromMap(maps[i]));
    }
    return results;
  }

  Future<List<FeedEntriesCompanion>> unsyncedFeedEntries() async {
    Map<String, dynamic> syncData = await _unsynced("FeedEntries");
    List<dynamic> maps = syncData['items'];
    List<FeedEntriesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await FeedEntries.fromMap(maps[i]));
    }
    return results;
  }

  Future<List<FeedMediasCompanion>> unsyncedFeedMedias() async {
    Map<String, dynamic> syncData = await _unsynced("FeedMedias");
    List<dynamic> maps = syncData['items'];
    List<FeedMediasCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await FeedMedias.fromMap(maps[i]));
    }
    return results;
  }

  Future<List<dynamic>> publicPlants(int n, int offset) async {
    Response resp = await apiClient
        .get('$_serverHost/public/plants?limit=$n&offset=$offset', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'publicPlants failed: ${resp.body}';
    }
    Map<String, dynamic> results = JsonDecoder().convert(resp.body);
    return results['plants'];
  }

  Future<Map<String, dynamic>> publicPlant(String id) async {
    Response resp =
        await apiClient.get('$_serverHost/public/plant/$id', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'publicPlant failed: ${resp.body}';
    }
    return JsonDecoder().convert(resp.body);
  }

  Future<List<dynamic>> publicFeedEntries(String id, int n, int offset) async {
    Response resp = await apiClient.get(
        '$_serverHost/public/plant/$id/feedEntries?limit=$n&offset=$offset',
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
        });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'publicFeedEntries failed: ${resp.body}';
    }
    Map<String, dynamic> results = JsonDecoder().convert(resp.body);
    return results['entries'];
  }

  Future<List<dynamic>> publicFeedMediasForFeedEntry(String id) async {
    Response resp = await apiClient
        .get('$_serverHost/public/feedEntry/$id/feedMedias', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'publicFeedMediasForFeedEntry failed: ${resp.body}';
    }
    Map<String, dynamic> results = JsonDecoder().convert(resp.body);
    return results['medias'];
  }

  Future<Map<String, dynamic>> publicFeedMedia(String id) async {
    Response resp =
        await apiClient.get('$_serverHost/public/feedMedia/$id', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'publicFeedMedia failed: ${resp.body}';
    }
    return JsonDecoder().convert(resp.body);
  }

  Future download(String from, String to) async {
    Response fileResp = await storageClient.get('$_storageServerHost$from',
        headers: {'Host': _storageServerHostHeader});
    await File(to).writeAsBytes(fileResp.bodyBytes);
  }

  String absoluteFileURL(String path) {
    return '$_storageServerHost$path';
  }

  Future setSynced(String type, String id) async {
    Response resp =
        await apiClient.post('$_serverHost/$type/$id/sync', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'setSynced failed: ${resp.body}';
    }
  }

  Future<Map<String, dynamic>> _unsynced(String type) async {
    Response resp = await apiClient.get('$_serverHost/sync$type', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw '_unsynced failed: ${resp.body}';
    }
    return JsonDecoder().convert(resp.body);
  }

  Future<String> _postPut(String path, Map<String, dynamic> obj) async {
    Function postPut = obj['id'] != null ? apiClient.put : apiClient.post;
    Response resp = await postPut('$_serverHost$path',
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert(obj));
    if (resp.statusCode ~/ 100 != 2) {
      throw '_postPut failed: ${resp.body}';
    }
    if (resp.headers['x-sgl-token'] != null) {
      AppDB().setJWT(resp.headers['x-sgl-token']);
    }
    if (obj['id'] == null) {
      Map<String, dynamic> data = JsonDecoder().convert(resp.body);
      return data['id'];
    }
    return null;
  }
}
