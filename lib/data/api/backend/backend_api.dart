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
import 'package:super_green_app/data/api/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/api/backend/products/products_api.dart';
import 'package:super_green_app/data/api/backend/time_series/time_series_api.dart';
import 'package:super_green_app/data/api/backend/users/users_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';

class BackendAPI {
  static final BackendAPI _instance = BackendAPI._newInstance();

  UsersAPI usersAPI;
  FeedsAPI feedsAPI;
  ProductsAPI productsAPI;
  TimeSeriesAPI timeSeriesAPI;

  String serverHost;
  String storageServerHost;
  String storageServerHostHeader;

  final Client apiClient = Client();
  final Client storageClient = Client();

  factory BackendAPI() => _instance;

  BackendAPI._newInstance() {
    usersAPI = UsersAPI();
    feedsAPI = FeedsAPI();
    productsAPI = ProductsAPI();
    timeSeriesAPI = TimeSeriesAPI();
    if (kReleaseMode || Platform.isIOS) {
      serverHost = 'https://api2.supergreenlab.com';
      storageServerHost = 'https://storage.supergreenlab.com';
      storageServerHostHeader = 'storage.supergreenlab.com';
    } else {
      initAndroidDevUrls();
    }
  }

  void initAndroidDevUrls() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if ((await deviceInfo.androidInfo).isPhysicalDevice) {
      bool local = true;
      serverHost = local
          ? 'http://192.168.1.87:8080'
          : 'https://devapi2.supergreenlab.com';
      storageServerHost = local
          ? 'http://192.168.1.87:9000'
          : 'https://devstorage.supergreenlab.com';
      storageServerHostHeader =
          local ? 'minio:9002' : 'devstorage.supergreenlab.com';
    } else {
      serverHost = 'http://10.0.2.2:8080';
      storageServerHost = 'http://10.0.2.2:9000';
      storageServerHostHeader = 'minio:9000';
    }
  }

  Future<String> postPut(String path, Map<String, dynamic> obj) async {
    Function postPut = obj['id'] != null ? apiClient.put : apiClient.post;
    Response resp = await postPut('${BackendAPI().serverHost}$path',
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

  Future<dynamic> get(String path) async {
    Response resp =
        await apiClient.get('${BackendAPI().serverHost}$path', headers: {
      'Content-Type': 'application/json',
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    });
    if (resp.statusCode ~/ 100 != 2) {
      throw 'get failed: ${resp.body}';
    }
    return JsonDecoder().convert(resp.body);
  }
}
