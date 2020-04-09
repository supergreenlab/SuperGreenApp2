import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/kv/app_db.dart';
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

  factory FeedsAPI() => _instance;

  FeedsAPI._newInstance() {
    if (kReleaseMode) {
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
      _serverHost = 'http://192.168.1.123:8080';
      _storageServerHost = 'http://192.168.1.123:9000';
    } else {
      _serverHost = 'http://10.0.2.2:8080';
      _storageServerHost = 'http://10.0.2.2:9000';
    }
    _storageServerHostHeader = 'minio:9000';
  }

  Future login(String nickname, String password) async {
    Response resp = await post('$_serverHost/login',
        headers: {'Content-Type': 'application/json'},
        body: JsonEncoder().convert({
          'handle': nickname,
          'password': password,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      throw 'Access denied';
    }
    AppDB().setJWT(resp.headers['x-sgl-token']);
  }

  Future createUser(String nickname, String password) async {
    Response resp = await post('$_serverHost/user',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JsonEncoder().convert({
          'nickname': nickname,
          'password': password,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      throw 'createUser failed';
    }
  }

  Future createUserEnd() async {
    return _postPut('/userend', {});
  }

  Future syncPlant(Plant plant) async {
    Feed feed = await RelDB.get().feedsDAO.getFeed(plant.feed);
    if (feed.serverID == null) {
      throw 'Missing serverID for feed relation';
    }
    Box box = await RelDB.get().plantsDAO.getBox(plant.box);
    if (box.serverID == null) {
      throw 'Missing serverID for box relation';
    }
    Map<String, dynamic> obj = {
      'id': plant.serverID,
      'feedID': feed.serverID,
      'boxID': box.serverID,
      'name': plant.name,
      'single': plant.single,
      'settings': plant.settings,
    };
    String id = await _postPut('/plant', obj);

    PlantsCompanion plantsCompanion =
        plant.createCompanion(true).copyWith(synced: Value(true));
    if (id != null) {
      plantsCompanion = plantsCompanion.copyWith(serverID: Value(id));
    }
    RelDB.get().plantsDAO.updatePlant(plantsCompanion);
  }

  Future syncBox(Box box) async {
    Map<String, dynamic> obj = {
      'id': box.serverID,
      'name': box.name,
      'settings': box.settings,
    };
    if (box.device != null) {
      Device device = await RelDB.get().devicesDAO.getDevice(box.device);
      if (device.serverID == null) {
        throw 'Missing serverID for device relation';
      }
      obj['deviceID'] = device.serverID;
      obj['deviceBox'] = box.deviceBox;
    }
    String id = await _postPut('/box', obj);

    BoxesCompanion boxesCompanion =
        box.createCompanion(true).copyWith(synced: Value(true));
    if (id != null) {
      boxesCompanion = boxesCompanion.copyWith(serverID: Value(id));
    }
    RelDB.get().plantsDAO.updateBox(boxesCompanion);
  }

  Future syncTimelapse(Timelapse timelapse) async {
    Plant plant = await RelDB.get().plantsDAO.getPlant(timelapse.plant);
    if (plant.serverID == null) {
      throw 'Missing serverID for plant relation';
    }
    Map<String, dynamic> obj = {
      'id': timelapse.serverID,
      'plantID': plant.serverID,
      'controllerID': timelapse.controllerID,
      'rotate': timelapse.rotate,
      'name': timelapse.name,
      'strain': timelapse.strain,
      'dropboxToken': timelapse.dropboxToken,
      'uploadName': timelapse.uploadName,
    };
    String id = await _postPut('/timelapse', obj);

    TimelapsesCompanion timelapsesCompanion =
        timelapse.createCompanion(true).copyWith(synced: Value(true));
    if (id != null) {
      timelapsesCompanion = timelapsesCompanion.copyWith(serverID: Value(id));
    }
    RelDB.get().plantsDAO.updateTimelapse(timelapsesCompanion);
  }

  Future syncDevice(Device device) async {
    Map<String, dynamic> obj = {
      'id': device.serverID,
      'identifier': device.identifier,
      'name': device.name,
      'ip': device.ip,
      'mdns': device.mdns,
      'config': device.config,
    };
    String id = await _postPut('/device', obj);

    DevicesCompanion devicesCompanion =
        device.createCompanion(true).copyWith(synced: Value(true));
    if (id != null) {
      devicesCompanion = devicesCompanion.copyWith(serverID: Value(id));
    }
    RelDB.get().devicesDAO.updateDevice(devicesCompanion);
  }

  Future syncFeed(Feed feed) async {
    Map<String, dynamic> obj = {
      'id': feed.serverID,
      'name': feed.name,
    };
    String id = await _postPut('/feed', obj);

    FeedsCompanion feedsCompanion =
        feed.createCompanion(true).copyWith(synced: Value(true));
    if (id != null) {
      feedsCompanion = feedsCompanion.copyWith(serverID: Value(id));
    }
    RelDB.get().feedsDAO.updateFeed(feedsCompanion);
  }

  Future syncFeedEntry(FeedEntry feedEntry) async {
    Feed feed = await RelDB.get().feedsDAO.getFeed(feedEntry.feed);
    if (feed.serverID == null) {
      throw 'Missing serverID for feed relation';
    }
    Map<String, dynamic> obj = {
      'id': feedEntry.serverID,
      'feedID': feed.serverID,
      'date': feedEntry.date.toUtc().toIso8601String(),
      'type': feedEntry.type,
      'params': feedEntry.params,
    };
    String id = await _postPut('/feedEntry', obj);

    FeedEntriesCompanion feedEntriesCompanion =
        feedEntry.createCompanion(true).copyWith(synced: Value(true));
    if (id != null) {
      feedEntriesCompanion = feedEntriesCompanion.copyWith(serverID: Value(id));
    }
    RelDB.get().feedsDAO.updateFeedEntry(feedEntriesCompanion);
  }

  Future syncFeedMedia(FeedMedia feedMedia) async {
    FeedEntry feedEntry =
        await RelDB.get().feedsDAO.getFeedEntry(feedMedia.feedEntry);
    if (feedEntry.serverID == null) {
      throw 'Missing serverID for feedEntry relation';
    }
    Response resp = await post('$_serverHost/feedMediaUploadURL',
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert({
          'fileName': feedMedia.filePath,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      throw 'fetchServerSync failed';
    }
    Map<String, dynamic> uploadUrls = JsonDecoder().convert(resp.body);

    {
      Response resp = await put('$_storageServerHost${uploadUrls['filePath']}',
          body: File(feedMedia.filePath).readAsBytesSync(),
          headers: {'Host': _storageServerHostHeader});
      if (resp.statusCode ~/ 100 != 2) {
        throw 'upload failed';
      }
    }

    {
      Response resp = await put(
          '$_storageServerHost${uploadUrls['thumbnailPath']}',
          body: File(feedMedia.thumbnailPath).readAsBytesSync(),
          headers: {'Host': _storageServerHostHeader});
      if (resp.statusCode ~/ 100 != 2) {
        throw 'upload failed';
      }
    }

    Map<String, dynamic> obj = {
      'id': feedMedia.serverID,
      'feedEntryID': feedEntry.serverID,
      'filePath': Uri.parse(uploadUrls['filePath']).path.split('/')[2],
      'thumbnailPath':
          Uri.parse(uploadUrls['thumbnailPath']).path.split('/')[2],
      'params': feedMedia.params,
    };
    String id = await _postPut('/feedMedia', obj);

    FeedMediasCompanion feedMediasCompanion = feedMedia
        .createCompanion(true)
        .copyWith(id: Value(feedMedia.id), synced: Value(true));
    if (id != null) {
      feedMediasCompanion = feedMediasCompanion.copyWith(serverID: Value(id));
    }
    RelDB.get().feedsDAO.updateFeedMedia(feedMediasCompanion);
  }

  Future<List<PlantsCompanion>> unsyncedPlants() async {
    Map<String, dynamic> syncData = await _unsynced("Plants");
    List<dynamic> maps = syncData['items'];
    List<PlantsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Plants.fromJSON(maps[i]));
    }
    return results;
  }

  Future<List<BoxesCompanion>> unsyncedBoxes() async {
    Map<String, dynamic> syncData = await _unsynced("Boxes");
    List<dynamic> maps = syncData['items'];
    List<BoxesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Boxes.fromJSON(maps[i]));
    }
    return results;
  }

  Future<List<TimelapsesCompanion>> unsyncedTimelapses() async {
    Map<String, dynamic> syncData = await _unsynced("Timelapses");
    List<dynamic> maps = syncData['items'];
    List<TimelapsesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Timelapses.fromJSON(maps[i]));
    }
    return results;
  }

  Future<List<DevicesCompanion>> unsyncedDevices() async {
    Map<String, dynamic> syncData = await _unsynced("Devices");
    List<dynamic> maps = syncData['items'];
    return maps.map<DevicesCompanion>((m) => Devices.fromJSON(m)).toList();
  }

  Future<List<FeedsCompanion>> unsyncedFeeds() async {
    Map<String, dynamic> syncData = await _unsynced("Feeds");
    List<dynamic> maps = syncData['items'];
    List<FeedsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await Feeds.fromJSON(maps[i]));
    }
    return results;
  }

  Future<List<FeedEntriesCompanion>> unsyncedFeedEntries() async {
    Map<String, dynamic> syncData = await _unsynced("FeedEntries");
    List<dynamic> maps = syncData['items'];
    List<FeedEntriesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await FeedEntries.fromJSON(maps[i]));
    }
    return results;
  }

  Future<List<FeedMediasCompanion>> unsyncedFeedMedias() async {
    Map<String, dynamic> syncData = await _unsynced("FeedMedias");
    List<dynamic> maps = syncData['items'];
    List<FeedMediasCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      results.add(await FeedMedias.fromJSON(maps[i]));
    }
    return results;
  }

  Future download(String from, String to) async {
    Response fileResp = await get('$_storageServerHost$from', headers: {'Host': _storageServerHostHeader});
    await File(to).writeAsBytes(fileResp.bodyBytes);
  }

  Future setSynced(String type, String id) async {
    Response resp = await post('$_serverHost/$type/$id/sync', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'setSynced failed';
    }
  }

  Future<Map<String, dynamic>> _unsynced(String type) async {
    Response resp = await get('$_serverHost/sync$type', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'fetchServerSync failed';
    }
    return JsonDecoder().convert(resp.body);
  }

  Future<String> _postPut(String path, Map<String, dynamic> obj) async {
    Function postPut = obj['id'] != null ? put : post;
    Response resp = await postPut('$_serverHost$path',
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert(obj));
    if (resp.statusCode ~/ 100 != 2) {
      throw '_postPut failed';
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
