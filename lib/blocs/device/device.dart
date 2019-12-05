import 'dart:async';

import 'package:super_green_app/blocs/device/module.dart';
import 'package:super_green_app/models/device/device_data.dart';

class Device {
  DeviceData _device;
  Map<String, Module> _modules = Map();

  StreamController<DeviceData> _deviceStream = StreamController();
  Stream<DeviceData> get device => _deviceStream.stream;

  List<String> get _moduleNames => _modules.values.map((m) => m.name).toList();

  DeviceData get data => _device;

  static Map<String, Device> _instances = Map();

  factory Device(DeviceData device) {
    if (!_instances.containsKey(device.id)) {
      _instances[device.id] = Device(device);
    }
    return _instances[device.id];
  }

  void setModule(Module module) {
    _modules[module.name] = module;
    _device.modules = this._moduleNames;
    _deviceStream.add(_device);
  }

  Module getModule(String name) => _modules[name];

  void dispose() {
    _modules.values.forEach((m) => m.dispose());
    _deviceStream.close();
  }
}