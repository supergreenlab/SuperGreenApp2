import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:super_green_app/data/api/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/api/backend/products/products_api.dart';
import 'package:super_green_app/data/api/backend/time_series/time_series_api.dart';
import 'package:super_green_app/data/api/backend/users/users_api.dart';

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
    if (kReleaseMode || Platform.isIOS) {
      serverHost = 'https://api2.supergreenlab.com';
      storageServerHost = 'https://storage.supergreenlab.com';
      storageServerHostHeader = 'storage.supergreenlab.com';
    } else {
      initUrls();
    }
  }

  void initUrls() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if ((await deviceInfo.androidInfo).isPhysicalDevice) {
      bool local = true;
      serverHost = local
          ? 'http://192.168.1.124:8080'
          : 'https://devapi2.supergreenlab.com';
      storageServerHost = local
          ? 'http://192.168.1.124:9000'
          : 'https://devstorage.supergreenlab.com';
      storageServerHostHeader =
          local ? 'minio:9000' : 'devstorage.supergreenlab.com';
    } else {
      serverHost = 'http://10.0.2.2:8080';
      storageServerHost = 'http://10.0.2.2:9000';
      storageServerHostHeader = 'minio:9000';
    }
  }
}
