import 'dart:async';

import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/models/device/device_data.dart';

enum NewDeviceState {
  IDLE,
  RESOLVING,
  FOUND,
  NOT_FOUND,
  OUTDATED,
  DONE,
}

class NewDevice {
  String _query;
  NewDeviceState _state = NewDeviceState.IDLE;

  StreamController<NewDeviceState> _stateStream = StreamController.broadcast();
  Stream<NewDeviceState> get state => _stateStream.stream;

  StreamController<DeviceData> _deviceStream = StreamController.broadcast();
  Stream<DeviceData> get device => _deviceStream.stream;

  NewDeviceState get data => _state;

  NewDevice(this._query);

  void startSearch() async {
    final ip = await KVDevice.resolveLocalName(this._query);
    if (ip == "") {
      this._setState(NewDeviceState.NOT_FOUND);
      return;
    }
    this._setState(NewDeviceState.FOUND);
    final deviceName = await KVDevice.fetchStringParam(ip, "DEVICE_NAME");
    final deviceId = await KVDevice.fetchStringParam(ip, "BROKER_CLIENTID");
    final config = await KVDevice.fetchConfig(ip);

    final device = DeviceData(deviceId, deviceName);
    device.config = config;

    _deviceStream.add(device);
    this._setState(NewDeviceState.DONE);
  }

  void _setState(NewDeviceState state) {
    this._state = state;
    _stateStream.add(this._state);
  }

  void dispose() {
    _stateStream.close();
    _deviceStream.close();
  }
}