import 'dart:convert';

import 'package:http/http.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';

class UsersAPI {
  bool get loggedIn => AppDB().getAppData().jwt != null;

  Future login(String nickname, String password) async {
    Response resp =
        await BackendAPI().apiClient.post('${BackendAPI().serverHost}/login',
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
    Response resp =
        await BackendAPI().apiClient.post('${BackendAPI().serverHost}/user',
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
}
