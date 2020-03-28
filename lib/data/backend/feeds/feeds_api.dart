import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:super_green_app/data/kv/app_db.dart';

class FeedsAPI {
  static final FeedsAPI _instance = FeedsAPI._newInstance();

  bool get loggedIn => AppDB().getAppData().jwt != null;

  String _serverHost;

  factory FeedsAPI() => _instance;

  FeedsAPI._newInstance() {
    if (kReleaseMode) {
      _serverHost = 'https://api.supergreenlab.com';
    } else {
      _serverHost = 'http://10.0.2.2:8080';
    }
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

  Future<String> createUser(String nickname, String password) async {
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
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return data['id'];
  }

  Future<String> createUserEnd() async {
    return await _insert('/userend', {});
  }

  Future<String> _insert(String path, Map<String, dynamic> obj) async {
    Response resp = await post('$_serverHost/userend',
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
        },
        body: JsonEncoder().convert(obj));
    if (resp.statusCode ~/ 100 != 2) {
      throw 'createUserEnd failed';
    }
    if (resp.headers['x-sgl-token'] != null) {
      AppDB().setJWT(resp.headers['x-sgl-token']);
    }
    Map<String, dynamic> data = JsonDecoder().convert(resp.body);
    return data['id'];
  }
}
