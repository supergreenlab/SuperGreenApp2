import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/device_helper.dart';
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

abstract class DeviceDaemonBlocState extends Equatable {}

class DeviceDaemonBlocStateInit extends DeviceDaemonBlocState {
  @override
  List<Object> get props => [];
}

class DeviceDaemonBlocStateDeviceReachable extends DeviceDaemonBlocState {
  final int rand = Random().nextInt(1 << 32);
  final Device device;
  final bool reachable;

  DeviceDaemonBlocStateDeviceReachable(this.device, this.reachable);

  @override
  List<Object> get props => [rand, device, reachable];
}

class DeviceDaemonBloc
    extends Bloc<DeviceDaemonBlocEvent, DeviceDaemonBlocState> {
  Timer _timer;
  List<Device> _devices = [];
  Map<int, bool> _deviceWorker = {};

  DeviceDaemonBloc() {
    add(DeviceDaemonBlocEventInit());
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      for (int i = 0; i < _devices.length; ++i) {
        try {
          _updateDeviceStatus(_devices[i]);
        } catch (e) {
          console.e(e);
        }
      }
    });
  }

  @override
  DeviceDaemonBlocState get initialState => DeviceDaemonBlocStateInit();

  @override
  Stream<DeviceDaemonBlocState> mapEventToState(
      DeviceDaemonBlocEvent event) async* {
    if (event is DeviceDaemonBlocEventInit) {
      RelDB.get().devicesDAO.watchDevices().listen(_deviceListChanged);
    } else if (event is DeviceDaemonBlocEventLoadDevice) {
      Device device =
          _devices.firstWhere((d) => d.id == event.deviceID, orElse: null);
      if (device == null) {
        return;
      }
      yield DeviceDaemonBlocStateDeviceReachable(device, device.isReachable);
    } else if (event is DeviceDaemonBlocEventDeviceReachable) {
      yield DeviceDaemonBlocStateDeviceReachable(event.device, event.reachable);
    }
  }

  void _updateDeviceStatus(Device device) async {
    if (_deviceWorker[device.id] == true) {
      return;
    }
    _deviceWorker[device.id] = true;
    try {
      var ddb = RelDB.get().devicesDAO;
      try {
        String identifier = await DeviceAPI.fetchStringParam(
            device.ip, 'BROKER_CLIENTID',
            nRetries: 1);
        if (identifier == device.identifier) {
          console.i('Device ${device.name} (${device.identifier}) found.');
          if (device.isSetup == false) {
            await DeviceAPI.fetchAllParams(device.ip, device.id, (_) => null);
          }
          await ddb.updateDevice(
              DevicesCompanion(id: Value(device.id), isReachable: Value(true)));
          add(DeviceDaemonBlocEventDeviceReachable(device, true));
          await _updateDeviceTime(device);
        }
      } catch (e) {
        console.i(
            'Device ${device.name} (${device.identifier}) not found, trying mdns lookup.');
        await RelDB.get().devicesDAO.updateDevice(
            DevicesCompanion(id: Value(device.id), isReachable: Value(false)));
        add(DeviceDaemonBlocEventDeviceReachable(device, false));
        String ip;
        await new Future.delayed(const Duration(seconds: 2));
        ip = await DeviceAPI.resolveLocalName(device.mdns);
        if (ip != null && ip != "") {
          try {
            String identifier =
                await DeviceAPI.fetchStringParam(ip, 'BROKER_CLIENTID');
            if (identifier == device.identifier) {
              console.i(
                  'Device ${device.name} (${device.identifier}) found with mdns lookup.');
              if (device.isSetup == false) {
                await DeviceAPI.fetchAllParams(ip, device.id, (_) => null);
              }
              await ddb.updateDevice(DevicesCompanion(
                  id: Value(device.id),
                  isReachable: Value(true),
                  ip: Value(ip),
                  synced: Value(ip == device.ip)));
              add(DeviceDaemonBlocEventDeviceReachable(device, true));
            }
          } catch (e) {
            console.i(
                'Device ${device.name} (${device.identifier}) not found, aborting.');
            await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(
                id: Value(device.id), isReachable: Value(false)));
            add(DeviceDaemonBlocEventDeviceReachable(device, false));
          }
        } else {
          console.i(
              'Device ${device.name} (${device.identifier}) not found, aborting.');
          await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(
              id: Value(device.id), isReachable: Value(false)));
          add(DeviceDaemonBlocEventDeviceReachable(device, false));
        }
      }
    } finally {
      _deviceWorker[device.id] = false;
    }
  }

  void _deviceListChanged(List<Device> devices) {
    _devices = devices;
  }

  Future<void> _updateDeviceTime(Device device) async {
    final Param time = await RelDB.get().devicesDAO.getParam(device.id, 'TIME');
    await DeviceHelper.updateIntParam(
        device, time, DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
  }

  @override
  Future<void> close() async {
    if (_timer != null) {
      _timer.cancel();
    }
    return super.close();
  }
}
