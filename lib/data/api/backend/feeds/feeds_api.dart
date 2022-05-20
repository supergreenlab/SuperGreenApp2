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
import 'dart:io';

import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/backend/feeds/models/bookmarks.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/data/api/backend/feeds/models/follows.dart';
import 'package:super_green_app/data/api/backend/feeds/models/likes.dart';
import 'package:super_green_app/data/api/backend/feeds/models/reports.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/common/deletes.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/plant/plants.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedsAPI {
  Future createUserEnd({String? notificationToken}) async {
    try {
      await BackendAPI().postPut('/userend', {'notificationToken': notificationToken});
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"notificationToken": notificationToken}, fwdThrow: true);
    }
  }

  Future updateNotificationToken(String token) async {
    try {
      BackendAPI().postPut(
          '/userend',
          {
            'notificationToken': token,
          },
          forcePut: true);
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"token": token}, fwdThrow: true);
    }
  }

  Future sendDeletes(List<Delete> deletes) async {
    Response resp = await BackendAPI().apiClient.post(Uri.parse('${BackendAPI().serverHost}/deletes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert({
          "deletes": deletes.map<Map<String, dynamic>>((d) => Deletes.toMap(d)).toList(),
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('SendDeletes failed with error: ${resp.body}', data: {"deletes": deletes});
    }
  }

  Future<List<Comment>> fetchCommentsForFeedEntry(String feedEntryID,
      {int offset = 0, int limit = 10, rootCommentsOnly = false}) async {
    Response resp = await BackendAPI().apiClient.get(
        Uri.parse(
            '${BackendAPI().serverHost}/feedEntry/$feedEntryID/comments?offset=$offset&limit=$limit&rootCommentsOnly=$rootCommentsOnly'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
        });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('fetchCommentsForFeedEntry failed: ${resp.body}',
          data: {"feedEntryID": feedEntryID, "offset": offset, "limit": limit, "rootCommentsOnly": rootCommentsOnly});
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    List<Comment> comments = [];
    for (int i = 0; i < data['comments'].length; ++i) {
      comments.add(Comment.fromMap(data['comments'][i]));
    }
    return comments;
  }

  Future<List<Comment>> fetchComment(String commentID) async {
    Response resp =
        await BackendAPI().apiClient.get(Uri.parse('${BackendAPI().serverHost}/comment/$commentID'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('fetchCommentsForFeedEntry failed: ${resp.body}', data: {"commentID": commentID});
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    List<Comment> comments = [];
    for (int i = 0; i < data['comments'].length; ++i) {
      comments.add(Comment.fromMap(data['comments'][i]));
    }
    return comments;
  }

  Future<Map<String, dynamic>> fetchSocialForFeedEntry(String feedEntryID, {int offset = 0, int n = 10}) async {
    Response resp = await BackendAPI()
        .apiClient
        .get(Uri.parse('${BackendAPI().serverHost}/feedEntry/$feedEntryID/social'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('fetchCommentsForFeedEntry failed: ${resp.body}',
          data: {"commentID": feedEntryID, "offset": offset, "n": n});
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return data;
  }

  Future<Map<String, dynamic>> fetchLatestTimelapseFrame(String timelapseID) async {
    Response resp = await BackendAPI()
        .apiClient
        .get(Uri.parse('${BackendAPI().serverHost}/timelapse/$timelapseID/latest'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('fetchLatestTimelapseFrame failed: ${resp.body}', data: {"timelapseID": timelapseID});
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return data;
  }

  Future<Uint8List> sglOverlay(Box box, Plant plant, Map<String, dynamic> meta, String url) async {
    Map<String, dynamic> params = {
      "box": await Boxes.toMap(box),
      "plant": await Plants.toMap(plant),
      "meta": meta,
      "url": url,
      "host": BackendAPI().storageServerHostHeader,
    };
    Response resp = await BackendAPI().apiClient.post(
          Uri.parse('${BackendAPI().serverHost}/sgloverlay'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
          },
          body: JsonEncoder().convert(params),
        );
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('sglOverlay failed: ${resp.body}', data: params);
    }
    return resp.bodyBytes;
  }

  Future<int> fetchCommentCountForFeedEntry(String feedEntryID) async {
    Response resp = await BackendAPI()
        .apiClient
        .get(Uri.parse('${BackendAPI().serverHost}/feedEntry/$feedEntryID/comments/count?allComments=true'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('fetchCommentsForFeedEntry failed: ${resp.body}', data: {"feedEntryID": feedEntryID});
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return data['n'];
  }

  Future<List<dynamic>> fetchBookmarks({int offset = 0, int limit = 10}) async {
    Response resp = await BackendAPI()
        .apiClient
        .get(Uri.parse('${BackendAPI().serverHost}/bookmarks?offset=$offset&limit=$limit'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('fetchBookmarks failed: ${resp.body}', data: {"offset": offset, "limit": limit});
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return data['bookmarks'];
  }

  Future syncPlant(Plant plant) async {
    Map<String, dynamic> obj = await Plants.toMap(plant);
    String? serverID = await BackendAPI().postPut('/plant', obj);

    PlantsCompanion plantsCompanion = PlantsCompanion(id: Value(plant.id), synced: Value(true));
    if (serverID != null) {
      plantsCompanion = plantsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().plantsDAO.updatePlant(plantsCompanion);
  }

  Future syncBox(Box box) async {
    Map<String, dynamic> obj = await Boxes.toMap(box);
    String? serverID = await BackendAPI().postPut('/box', obj);

    BoxesCompanion boxesCompanion = BoxesCompanion(id: Value(box.id), synced: Value(true));
    if (serverID != null) {
      boxesCompanion = boxesCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().plantsDAO.updateBox(boxesCompanion);
  }

  Future syncTimelapse(Timelapse timelapse) async {
    Map<String, dynamic> obj = await Timelapses.toMap(timelapse);
    String? serverID = await BackendAPI().postPut('/timelapse', obj);

    TimelapsesCompanion timelapsesCompanion = TimelapsesCompanion(id: Value(timelapse.id), synced: Value(true));
    if (serverID != null) {
      timelapsesCompanion = timelapsesCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().plantsDAO.updateTimelapse(timelapsesCompanion);
  }

  Future syncDevice(Device device) async {
    Map<String, dynamic> obj = await Devices.toMap(device);
    String? serverID = await BackendAPI().postPut('/device', obj);

    DevicesCompanion devicesCompanion = DevicesCompanion(id: Value(device.id), synced: Value(true));
    if (serverID != null) {
      devicesCompanion = devicesCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().devicesDAO.updateDevice(devicesCompanion);
  }

  Future syncFeed(Feed feed) async {
    Map<String, dynamic> obj = await Feeds.toMap(feed);
    String? serverID = await BackendAPI().postPut('/feed', obj);

    FeedsCompanion feedsCompanion = FeedsCompanion(id: Value(feed.id), synced: Value(true));
    if (serverID != null) {
      feedsCompanion = feedsCompanion.copyWith(serverID: Value(serverID));
    }
    await RelDB.get().feedsDAO.updateFeed(feedsCompanion);
  }

  Future syncFeedEntry(FeedEntry feedEntry) async {
    Map<String, dynamic> obj = await FeedEntries.toMap(feedEntry);
    String? serverID = await BackendAPI().postPut('/feedEntry', obj);

    FeedEntriesCompanion feedEntriesCompanion = FeedEntriesCompanion(id: Value(feedEntry.id), synced: Value(true));
    if (serverID != null) {
      feedEntriesCompanion = feedEntriesCompanion.copyWith(serverID: Value(serverID));
    }
    await FeedEntryHelper.updateFeedEntry(feedEntriesCompanion);
  }

  Future syncFeedMedia(FeedMedia feedMedia) async {
    Map<String, dynamic> obj = await FeedMedias.toMap(feedMedia);

    Response resp = await BackendAPI().apiClient.post(Uri.parse('${BackendAPI().serverHost}/feedMediaUploadURL'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert({
          'fileName': feedMedia.filePath,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('feedMediaUploadURL failed with error: ${resp.body}', data: {"feedMedia": feedMedia});
    }
    Map<String, dynamic> uploadUrls = JsonDecoder().convert(resp.body);

    {
      File file = File(FeedMedias.makeAbsoluteFilePath(feedMedia.filePath));
      // TODO check video files length in capture page (max 200mB, cloudflare limit)
      if (file.lengthSync() >= 199 * 1024 * 1024) {
        Logger.log('Ignoring feed medias sync: file too large (${file.lengthSync() / (1024 * 1024)} MB)');
        return; // TODO continue with thumbnail upload
      }
      if (await file.exists()) {
        Response resp = await BackendAPI().storageClient.put(
            Uri.parse('${BackendAPI().storageServerHost}${uploadUrls['filePath']}'),
            body: file.readAsBytesSync(),
            headers: {'Host': BackendAPI().storageServerHostHeader});
        if (resp.statusCode ~/ 100 != 2) {
          Logger.throwError('Upload failed with error: ${resp.body}',
              data: {"feedMedia": feedMedia, "filePath": feedMedia.filePath, "fileSize": file.lengthSync()});
        }
      }
    }

    {
      File file = File(FeedMedias.makeAbsoluteFilePath(feedMedia.thumbnailPath));
      if (await file.exists()) {
        Response resp = await BackendAPI().storageClient.put(
            Uri.parse('${BackendAPI().storageServerHost}${uploadUrls['thumbnailPath']}'),
            body: file.readAsBytesSync(),
            headers: {'Host': BackendAPI().storageServerHostHeader});
        if (resp.statusCode ~/ 100 != 2) {
          Logger.throwError('Upload failed with error: ${resp.body}',
              data: {"feedMedia": feedMedia, "thumbnailPath": feedMedia.thumbnailPath, "fileSize": file.lengthSync()});
        }
      }
    }

    obj['filePath'] = Uri.parse(uploadUrls['filePath']).path.split('/')[2];
    obj['thumbnailPath'] = Uri.parse(uploadUrls['thumbnailPath']).path.split('/')[2];

    String? serverID = await BackendAPI().postPut('/feedMedia', obj);

    try {
      FeedMediasCompanion feedMediasCompanion = FeedMediasCompanion(id: Value(feedMedia.id), synced: Value(true));
      if (serverID != null) {
        feedMediasCompanion = feedMediasCompanion.copyWith(serverID: Value(serverID));
      }
      await RelDB.get().feedsDAO.updateFeedMedia(feedMediasCompanion);
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"feedMedia": feedMedia}, fwdThrow: true);
    }
  }

  Future<List<PlantsCompanion>> unsyncedPlants() async {
    Map<String, dynamic> syncData = await _unsynced("Plants");
    List<dynamic> maps = syncData['items'];
    List<PlantsCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        results.add(await Plants.fromMap(maps[i]));
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future<List<BoxesCompanion>> unsyncedBoxes() async {
    Map<String, dynamic> syncData = await _unsynced("Boxes");
    List<dynamic> maps = syncData['items'];
    List<BoxesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        results.add(await Boxes.fromMap(maps[i]));
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future<List<TimelapsesCompanion>> unsyncedTimelapses() async {
    Map<String, dynamic> syncData = await _unsynced("Timelapses");
    List<dynamic> maps = syncData['items'];
    List<TimelapsesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        results.add(await Timelapses.fromMap(maps[i]));
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
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
      try {
        results.add(await Feeds.fromMap(maps[i]));
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future<List<FeedEntriesCompanion>> unsyncedFeedEntries() async {
    Map<String, dynamic> syncData = await _unsynced("FeedEntries");
    List<dynamic> maps = syncData['items'];
    List<FeedEntriesCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        FeedEntriesCompanion fe = await FeedEntries.fromMap(maps[i]);
        if (fe is SkipFeedEntriesCompanion) {
          continue;
        }
        results.add(fe);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future<List<FeedMediasCompanion>> unsyncedFeedMedias() async {
    Map<String, dynamic> syncData = await _unsynced("FeedMedias");
    List<dynamic> maps = syncData['items'];
    List<FeedMediasCompanion> results = [];
    for (int i = 0; i < maps.length; ++i) {
      try {
        FeedMediasCompanion fm = await FeedMedias.fromMap(maps[i]);
        if (fm is SkipFeedMediasCompanion) {
          // TODO move this to syncer block, so they can be marked as synced
          continue;
        }
        results.add(fm);
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"data": maps[i]}, fwdThrow: true);
      }
    }
    return results;
  }

  Future archivePlant(String id) async {
    Response resp =
        await BackendAPI().apiClient.post(Uri.parse('${BackendAPI().serverHost}/plant/$id/archive'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('archivePlant failed with error: ${resp.body}', data: {"id": id});
    }
  }

  Future<List<dynamic>> publicPlants(int n, int offset) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/plants?limit=$n&offset=$offset');
      return results['plants'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"n": n, "offset": offset});
      throw e;
    }
  }

  Future<List<dynamic>> searchPlants(String q, int n, int offset) async {
    try {
      Map<String, dynamic> results =
          await BackendAPI().get('/public/plants/search?q=${Uri.encodeComponent(q)}&limit=$n&offset=$offset');
      return results['plants'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"n": n, "offset": offset});
      throw e;
    }
  }

  Future<Map<String, dynamic>> publicPlant(String id) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/plant/$id');
      return results;
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"id": id});
      throw e;
    }
  }

  Future<List<dynamic>> publicFeedEntries(int n, int offset) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/feedEntries?limit=$n&offset=$offset');
      return results['entries'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"n": n, "offset": offset});
      throw e;
    }
  }

  Future<List<dynamic>> publicFollowedFeedEntries(int n, int offset) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/feedEntries/followed?limit=$n&offset=$offset');
      return results['entries'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"n": n, "offset": offset});
      throw e;
    }
  }

  Future<List<dynamic>> followedPlants(int n, int offset) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/plants/followed?limit=$n&offset=$offset');
      return results['plants'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"n": n, "offset": offset});
      throw e;
    }
  }

  Future<List<dynamic>> publicCommentedFeedEntries(int n, int offset) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/feedEntries/commented?limit=$n&offset=$offset');
      return results['entries'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"n": n, "offset": offset});
      throw e;
    }
  }

  Future<List<dynamic>> publicLiked(int n, int offset) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/liked?limit=$n&offset=$offset');
      return results['entries'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"n": n, "offset": offset});
      throw e;
    }
  }

  Future<List<dynamic>> publicPlantFeedEntries(String id, int n, int offset, {List<String>? filters}) async {
    try {
      String filterQuery = (filters ?? []).map((f) => '&f=$f').join('');
      Logger.log(filterQuery);
      Map<String, dynamic> results =
          await BackendAPI().get('/public/plant/$id/feedEntries?limit=$n&offset=$offset$filterQuery');
      return results['entries'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"id": id, "n": n, "offset": offset});
      throw e;
    }
  }

  Future<Map<String, dynamic>> publicFeedEntry(String id) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/feedEntry/$id');
      return results['entry'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"id": id});
      throw e;
    }
  }

  Future<List<dynamic>> publicFeedMediasForFeedEntry(String id) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/feedEntry/$id/feedMedias');
      return results['medias'];
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"id": id});
      throw e;
    }
  }

  Future<Map<String, dynamic>> publicFeedMedia(String id) async {
    try {
      Map<String, dynamic> results = await BackendAPI().get('/public/feedMedia/$id');
      return results;
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"id": id});
      throw e;
    }
  }

  Future<Comment> postComment(Comment comment) async {
    Map<String, dynamic> obj = comment.toMap();
    String? id = await BackendAPI().postPut('/comment', obj);
    return comment.copyWith(id: id!);
  }

  Future bookmarkFeedEntry(String feedEntryID) async {
    Map<String, dynamic> obj = Bookmark(feedEntryID: feedEntryID).toMap();
    await BackendAPI().postPut('/bookmark', obj);
  }

  Future followPlant(String plantID) async {
    Map<String, dynamic> obj = Follow(plantID: plantID).toMap();
    await BackendAPI().postPut('/follow', obj);
  }

  Future likeComment(Comment comment) async {
    Map<String, dynamic> obj = Like(commentID: comment.id).toMap();
    await BackendAPI().postPut('/like', obj);
  }

  Future likeFeedEntry(String feedEntryID) async {
    Map<String, dynamic> obj = Like(feedEntryID: feedEntryID).toMap();
    await BackendAPI().postPut('/like', obj);
  }

  Future reportComment(Comment comment) async {
    Map<String, dynamic> obj = Report(commentID: comment.id).toMap();
    await BackendAPI().postPut('/report', obj);
  }

  Future reportFeedEntry(String feedEntryID) async {
    Map<String, dynamic> obj = Report(feedEntryID: feedEntryID).toMap();
    await BackendAPI().postPut('/report', obj);
  }

  Future reportPlant(String plantID) async {
    Map<String, dynamic> obj = Report(plantID: plantID).toMap();
    await BackendAPI().postPut('/report', obj);
  }

  Future download(String from, String to) async {
    try {
      Response fileResp = await BackendAPI().storageClient.get(Uri.parse('${BackendAPI().storageServerHost}$from'),
          headers: {'Host': BackendAPI().storageServerHostHeader});
      await File(to).writeAsBytes(fileResp.bodyBytes);
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"from": from, "to": to}, fwdThrow: true);
    }
  }

  String absoluteFileURL(String path) {
    return '${BackendAPI().storageServerHost}$path';
  }

  Future setSynced(String type, String id) async {
    Response resp = await BackendAPI().apiClient.post(Uri.parse('${BackendAPI().serverHost}/$type/$id/sync'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('setSynced failed: ${resp.body}', data: {"type": type, "id": id});
    }
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
