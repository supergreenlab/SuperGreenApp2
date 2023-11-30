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

import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/user_settings.dart';
import 'package:super_green_app/data/logger/logger.dart';

class User extends Equatable {
  final String? id;
  final String? nickname;
  final String? pic;
  final String? settings;

  User({this.id, this.nickname, this.pic, this.settings});

  factory User.fromMap(Map<String, dynamic> userMap) {
    return User(id: userMap['id'], nickname: userMap['nickname'], pic: userMap['pic'], settings: userMap['settings']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (pic != null) {
      data['pic'] = pic;
    }
    if (settings != null) {
      data['settings'] = settings;
    }
    return data;
  }

  @override
  List<Object?> get props => [id, nickname, pic, settings,];
}

class UsersAPI {
  bool get loggedIn => AppDB().getAppData().jwt != null;

  Future login(String nickname, String password, String token) async {
    Response resp = await BackendAPI().apiClient.post(Uri.parse('${BackendAPI().serverHost}/login'),
        headers: {'Content-Type': 'application/json'},
        body: JsonEncoder().convert({
          'handle': nickname,
          'password': password,
          'token': token,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('Access denied: ${resp.body}', fwdThrow: true);
    }
    AppDB().setJWT(resp.headers['x-sgl-token']!);
  }

  Future createUser(String nickname, String password, String token) async {
    Response resp = await BackendAPI().apiClient.post(Uri.parse('${BackendAPI().serverHost}/user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: JsonEncoder().convert({
          'nickname': nickname,
          'password': password,
          'token': token,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('CreateUser failed with error: ${resp.body}', fwdThrow: true);
    }
    AppDB().setJWT(resp.headers['x-sgl-token']!);
  }

  Future deleteUser(String nickname, String password, String token) async {
    Response resp = await BackendAPI().apiClient.delete(Uri.parse('${BackendAPI().serverHost}/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert({
          'handle': nickname,
          'password': password,
          'token': token,
        }));
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('DeleteUser failed with error: ${resp.body}', fwdThrow: true);
    }
  }

  Future uploadProfilePic(File file) async {
    Response resp = await BackendAPI().apiClient.post(
      Uri.parse('${BackendAPI().serverHost}/profilePicUploadURL'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
      },
    );
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('feedMediaUploadURL failed with error ${resp.body}', fwdThrow: true);
    }
    Map<String, dynamic> uploadUrl = JsonDecoder().convert(resp.body);

    if (await file.exists()) {
      Response resp = await BackendAPI().storageClient.put(
          Uri.parse('${BackendAPI().storageServerHost}${uploadUrl['filePath']}'),
          body: file.readAsBytesSync(),
          headers: {'Host': BackendAPI().storageServerHostHeader});
      if (resp.statusCode ~/ 100 != 2) {
        Logger.throwError('Upload failed with error: ${resp.body}',
            data: {"filePath": file.path, "fileSize": file.lengthSync()}, fwdThrow: true);
      }
    }
    await updateUser(User(pic: Uri.parse(uploadUrl['filePath']).path.split('/')[2]));
  }

  Future updateUser(User user) async {
    try {
      await BackendAPI().apiClient.put(Uri.parse('${BackendAPI().serverHost}/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
          },
          body: JsonEncoder().convert(user.toMap()));
    } catch (e, trace) {
      Logger.logError(e, trace, fwdThrow: true);
    }
  }

  Future updateUserSettings(UserSettings userSettings) async {
    await updateUser(User(settings: userSettings.toJSON()));
  }

  Future syncUserSettings() async {
    User user = await me();
    UserSettings currentUserSettings = AppDB().getUserSettings();
    UserSettings userSettings = UserSettings.fromJSON(user.settings ?? '{}');
    AppDB().setUserSettings(currentUserSettings.copyWith(
      timeOffset: userSettings.timeOffset,
      preferredNotificationHour: userSettings.preferredNotificationHour,
      freedomUnits: userSettings.freedomUnits,
      userID: userSettings.userID,
    ));
  }

  Future<User> me() async {
    Response resp = await BackendAPI().apiClient.get(Uri.parse('${BackendAPI().serverHost}/user/me'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      Logger.throwError('/me failed with error: ${resp.body}', fwdThrow: true);
    }
    Map<String, dynamic> userMap = JsonDecoder().convert(resp.body);
    return User.fromMap(userMap);
  }
}
