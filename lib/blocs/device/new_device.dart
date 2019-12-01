import 'dart:async';

import 'package:super_green_app/apis/device/kv_device.dart';

enum NewDeviceState {
  IDLE,
  RESOLVING,
  FOUND,
  NOT_FOUND,
  FETCHING,
  OUTDATED,
}

class NewDevice {
  String _query;
  NewDeviceState _state = NewDeviceState.IDLE;

  StreamController<NewDeviceState> _stateStream = StreamController.broadcast();
  Stream<NewDeviceState> get state => _stateStream.stream;

  NewDeviceState get data => _state;

  NewDevice(this._query);

  void startSearch() async {
    final ip = await KVDevice.resolveLocalName(this._query);
    if (ip == "") {
      this._setState(NewDeviceState.NOT_FOUND);
      return;
    }
    this._setState(NewDeviceState.FOUND);
    print('Resolved controller at ${ip}');
    final deviceName = await KVDevice.fetchStringParam(ip, "DEVICE_NAME");
    print(deviceName);
  }

  void _setState(NewDeviceState state) {
    this._state = state;
    _stateStream.add(this._state);
  }

  void dispose() {
    _stateStream.close();
  }
}