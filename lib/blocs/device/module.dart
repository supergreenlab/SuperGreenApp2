import 'dart:async';

import 'package:super_green_app/blocs/device/param.dart';
import 'package:super_green_app/models/device/module_data.dart';

class Module {
  ModuleData _module;
  List<Map<String, Param>> _params;

  StreamController<ModuleData> _moduleStream = StreamController.broadcast();
  Stream<ModuleData> get module => _moduleStream.stream;

  String get name => _module.name;
  List<String> get _paramKeys => _params[0].keys;

  static Map<String, Module> _instances = Map();

  factory Module(ModuleData module) {
    String key = '${module.deviceId}_${module.name}';
    if (!_instances.containsKey(key)) {
      _instances[key] = Module(module);
    }
    return _instances[key];
  }

  void setParam(int i, Param param) {
    _params[i][param.key] = param;
    _module.params = this._paramKeys;
    _moduleStream.add(_module);
  }

  Param getParam(int i, String key) {
    return _params[i][key];
  }

  void dispose() {
    _params.forEach((p) => p.values.forEach((p) => p.dispose()));
    _moduleStream.close();
  }
}