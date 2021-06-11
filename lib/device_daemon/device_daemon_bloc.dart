import 'dart:async';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/devices/websocket.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class DeviceDaemonBlocEvent extends Equatable {}

class DeviceDaemonBlocEventInit extends DeviceDaemonBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceDaemonBlocEventLoadDevice extends DeviceDaemonBlocEvent {
  final int rand = Random().nextInt(1 << 32);
  final int deviceID;

  DeviceDaemonBlocEventLoadDevice(this.deviceID);

  @override
  List<Object> get props => [rand, deviceID];
}

class DeviceDaemonBlocEventDeviceReachable extends DeviceDaemonBlocEvent {
  final int rand = Random().nextInt(1 << 32);
  final Device device;
  final bool reachable;

  DeviceDaemonBlocEventDeviceReachable(this.device, this.reachable);

  @override
  List<Object> get props => [rand, device, reachable];
}

class DeviceDaemonBlocEventRequiresLogin extends DeviceDaemonBlocEvent {
  final Device device;

  DeviceDaemonBlocEventRequiresLogin(this.device);

  @override
  List<Object> get props => [device];
}

class DeviceDaemonBlocEventLoggedIn extends DeviceDaemonBlocEvent {
  final Device device;

  DeviceDaemonBlocEventLoggedIn(this.device);

  @override
  List<Object> get props => [device];
}

abstract class DeviceDaemonBlocState extends Equatable {}

class DeviceDaemonBlocStateInit extends DeviceDaemonBlocState {
  @override
  List<Object> get props => [];
}

class DeviceDaemonBlocStateDeviceReachable extends DeviceDaemonBlocState {
  final int rand = Random().nextInt(1 << 32);
  final Device device;
  final bool reachable;
  final bool usingWifi;

  DeviceDaemonBlocStateDeviceReachable(this.device, this.reachable, this.usingWifi);

  @override
  List<Object> get props => [rand, device, reachable, usingWifi];
}

class DeviceDaemonBlocStateRequiresLogin extends DeviceDaemonBlocState {
  final Device device;

  DeviceDaemonBlocStateRequiresLogin(this.device);

  @override
  List<Object> get props => [device];
}

class DeviceDaemonBloc extends Bloc<DeviceDaemonBlocEvent, DeviceDaemonBlocState> {
  Map<String, DeviceWebsocket> websockets = {};

  StreamSubscription<ConnectivityResult> _connectivity;

  Timer _timer;
  List<Device> _devices = [];
  Map<int, bool> _deviceWorker = {};

  bool _usingWifi = false;

  DeviceDaemonBloc() : super(DeviceDaemonBlocStateInit());

  @override
  Stream<DeviceDaemonBlocState> mapEventToState(DeviceDaemonBlocEvent event) async* {
    if (event is DeviceDaemonBlocEventInit) {
      _scheduleUpdate();
      _usingWifi = await Connectivity().checkConnectivity() == ConnectivityResult.wifi;
      _connectivity = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        _usingWifi = (result == ConnectivityResult.wifi);
      });
      RelDB.get().devicesDAO.watchDevices().listen(_deviceListChanged);
    } else if (event is DeviceDaemonBlocEventLoadDevice) {
      Device device = _devices.firstWhere((d) => d.id == event.deviceID, orElse: () => null);
      if (device == null) {
        return;
      }
      yield DeviceDaemonBlocStateDeviceReachable(device, device.isReachable, _usingWifi);
    } else if (event is DeviceDaemonBlocEventDeviceReachable) {
      yield DeviceDaemonBlocStateDeviceReachable(event.device, event.reachable, _usingWifi);
    } else if (event is DeviceDaemonBlocEventRequiresLogin) {
      yield DeviceDaemonBlocStateRequiresLogin(event.device);
    } else if (event is DeviceDaemonBlocEventLoggedIn) {
      _deviceWorker[event.device.id] = false;
    }
  }

  void _scheduleUpdate() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      for (int i = 0; i < _devices.length; ++i) {
        try {
          _updateDeviceStatus(_devices[i]);
        } catch (e, trace) {
          Logger.logError(e, trace, data: {"device": _devices[i]});
        }
      }
    });
  }

  void _updateDeviceStatus(Device device) async {
    if (_deviceWorker[device.id] == true) {
      return;
    }
    _deviceWorker[device.id] = true;
    try {
      String auth = AppDB().getDeviceAuth(device.identifier);
      var ddb = RelDB.get().devicesDAO;
      try {
        String identifier = await DeviceAPI.fetchStringParam(device.ip, 'BROKER_CLIENTID', nRetries: 1, auth: auth);
        if (identifier == device.identifier) {
          if (device.isSetup == false) {
            await DeviceAPI.fetchAllParams(device.ip, device.id, (_) => null, auth: auth);
          }
          await ddb.updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(true)));
          add(DeviceDaemonBlocEventDeviceReachable(device, true));
          await _updateDeviceTime(device);
        } else {
          if (identifier != null) {
            Logger.throwError("Wrong identifier for device ${device.name}",
                data: {"device": device, "identifier": identifier});
          } else {
            throw 'Couldn\'t connect to device';
          }
        }
      } catch (e) {
        if (e.toString().endsWith('401')) {
          add(DeviceDaemonBlocEventRequiresLogin(device));
          return;
        }

        await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
        add(DeviceDaemonBlocEventDeviceReachable(device, false));
        String ip;
        await new Future.delayed(const Duration(seconds: 2));
        ip = await DeviceAPI.resolveLocalName(device.mdns);
        if (ip != null && ip != "") {
          try {
            String identifier = await DeviceAPI.fetchStringParam(ip, 'BROKER_CLIENTID', auth: auth);
            if (identifier == device.identifier) {
              if (device.isSetup == false) {
                await DeviceAPI.fetchAllParams(ip, device.id, (_) => null, auth: auth);
              }
              await ddb.updateDevice(DevicesCompanion(
                  id: Value(device.id),
                  isReachable: Value(true),
                  ip: Value(ip),
                  synced: Value(device.synced ? ip == device.ip : false)));
              add(DeviceDaemonBlocEventDeviceReachable(device, true));
            } else {
              if (identifier != null) {
                Logger.throwError("Wrong identifier for device ${device.name}",
                    data: {"device": device, "identifier": identifier});
              } else {
                throw 'Couldn\'t connect to device';
              }
            }
          } catch (e, trace) {
            Logger.logError(e, trace, data: {"device": device});
            await RelDB.get()
                .devicesDAO
                .updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
            add(DeviceDaemonBlocEventDeviceReachable(device, false));
          }
        } else {
          await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
          add(DeviceDaemonBlocEventDeviceReachable(device, false));
        }
      }
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"device": device});
    } finally {
      _deviceWorker[device.id] = false;
    }
  }

  void _deviceListChanged(List<Device> devices) {
    _devices = devices;
    _devices.forEach((d) {
      if (websockets[d.identifier] == null) {
        DeviceWebsocket socket = DeviceWebsocket(d);
        websockets[d.identifier] = socket;
        socket.connect();
      }
    });
  }

  Future<void> _updateDeviceTime(Device device) async {
    final Param time = await RelDB.get().devicesDAO.getParam(device.id, 'TIME');
    await DeviceHelper.updateIntParam(device, time, DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
  }

  @override
  Future<void> close() async {
    if (_timer != null) {
      _timer.cancel();
    }
    if (_connectivity != null) {
      _connectivity.cancel();
    }
    return super.close();
  }
}
