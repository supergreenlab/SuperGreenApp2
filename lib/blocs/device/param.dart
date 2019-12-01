import 'dart:async';

import 'package:super_green_app/models/device/param_data.dart';

class Param<T> {
  ParamData<T> _param;

  StreamController<ParamData<T>> _paramStream = StreamController();
  Stream<ParamData<T>> get param => _paramStream.stream;

  String get key => _param.key;
  ParamData get data => _param;

  void dispose() {
    _paramStream.close();
  }
}