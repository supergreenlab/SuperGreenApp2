/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/devices/websocket.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:collection/collection.dart';

abstract class DeviceDaemonBlocEvent extends Equatable {}

class DeviceDaemonBlocEventInit extends DeviceDaemonBlocEvent {
  @override
  List<Object> get props => [];
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

class DeviceDaemonBlocStateRequiresLogin extends DeviceDaemonBlocState {
  final int rand = Random().nextInt(1 << 32);
  final Device device;

  DeviceDaemonBlocStateRequiresLogin(this.device);

  @override
  List<Object> get props => [device, rand];
}

class DeviceDaemonBloc extends LegacyBloc<DeviceDaemonBlocEvent, DeviceDaemonBlocState> {
  StreamSubscription<ConnectivityResult>? _connectivity;

  Timer? _timer;
  List<Device> _devices = [];
  Map<int, bool> _deviceWorker = {};

  DeviceDaemonBloc() : super(DeviceDaemonBlocStateInit());

  @override
  Stream<DeviceDaemonBlocState> mapEventToState(DeviceDaemonBlocEvent event) async* {
    if (event is DeviceDaemonBlocEventInit) {
      _scheduleUpdate();
      RelDB.get().devicesDAO.watchDevices().listen(_deviceListChanged);
    } else if (event is DeviceDaemonBlocEventRequiresLogin) {
      yield DeviceDaemonBlocStateRequiresLogin(event.device);
    } else if (event is DeviceDaemonBlocEventLoggedIn) {
      _deviceWorker[event.device.id] = false;
    }
  }

  void _scheduleUpdate() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      for (int i = 0; i < _devices.length; ++i) {
        if (_devices[i].isRemote) {
          continue;
        }
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
      String? auth = AppDB().getDeviceAuth(device.identifier);
      var ddb = RelDB.get().devicesDAO;
      try {
        String? identifier;
        try {
          identifier = await DeviceAPI.fetchStringParam(device.ip, 'BROKER_CLIENTID', nRetries: 1, auth: auth);
        } catch (e) {}
        if (identifier == device.identifier) {
          if (device.isSetup == false || device.needsRefresh) {
            await DeviceAPI.fetchAllParams(device.ip, device.id, (_) => null, auth: auth);
          }
          await ddb.updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(true)));
          await _updateDeviceTime(device);
        } else {
          if (identifier != null) {
            await ddb.updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
            Logger.throwError("Wrong identifier for device ${device.name}",
                data: {"identifier": identifier});
          } else {
            throw 'Couldn\'t connect to device';
          }
        }
      } catch (e) {
        if (e.toString().endsWith('401')) {
          add(DeviceDaemonBlocEventRequiresLogin(device));
          _deviceWorker[device.id] = false;
          return;
        }

        await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
        await new Future.delayed(const Duration(seconds: 2));
        String? ip = await DeviceAPI.resolveLocalName(device.mdns);
        if (ip != null && ip != "") {
          try {
            String? identifier;
            try {
              identifier = await DeviceAPI.fetchStringParam(ip, 'BROKER_CLIENTID', auth: auth);
            } catch (e) {}
            if (identifier == device.identifier) {
              if (device.isSetup == false || device.needsRefresh) {
                await DeviceAPI.fetchAllParams(ip, device.id, (_) => null, auth: auth);
              }
              await ddb.updateDevice(DevicesCompanion(
                  id: Value(device.id),
                  isReachable: Value(true),
                  ip: Value(ip),
                  synced: Value(device.synced ? ip == device.ip : false)));
            } else {
              if (identifier != null) {
                Logger.throwError("Wrong identifier for device ${device.name}",
                    data: {"identifier": identifier}, fwdThrow: true);
              } else {
                throw 'Couldn\'t connect to device';
              }
            }
          } catch (e, trace) {
            Logger.logError(e, trace, data: {"device": device});
            await RelDB.get()
                .devicesDAO
                .updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
          }
        } else {
          await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
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
      if (d.serverID != null) {
        DeviceWebsocket.createIfNotAlready(d);
      }
    });
    for (String key in DeviceWebsocket.websockets.keys) {
      if (devices.firstWhereOrNull((de) => de.serverID == key) == null) {
        DeviceWebsocket.deleteIfExists(key);
      }
    }
  }

  Future<void> _updateDeviceTime(Device device) async {
    final Param? time = await RelDB.get().devicesDAO.getParam(device.id, 'TIME');
    await DeviceHelper.updateIntParam(device, time!, DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    _connectivity?.cancel();
    return super.close();
  }
}
