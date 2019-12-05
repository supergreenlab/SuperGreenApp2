import 'dart:async';

import 'package:super_green_app/models/device/param_data.dart';

class Param<T> {
  ParamData<T> _param;

  StreamController<ParamData<T>> _paramStream = StreamController();
  Stream<ParamData<T>> get param => _paramStream.stream;

  String get key => _param.key;
  ParamData get data => _param;

  static Map<String, Param> _instances = Map();

  factory Param(ParamData<T> param) {
    String key = '${param.deviceId}_${param.moduleName}_${param.key}';
    if (!_instances.containsKey(key)) {
      _instances[key] = Param<T>(param);
    }
    return _instances[key];
  }

  void dispose() {
    _paramStream.close();
  }
}