import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class DeviceDaemonBlocEvent extends Equatable {}

class DeviceDaemonBlocEventInit extends DeviceDaemonBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class DeviceDaemonBlocState extends Equatable {}

class DeviceDaemonBlocStateInit extends DeviceDaemonBlocState {
  @override
  List<Object> get props => [];
}

class DeviceDaemonBloc
    extends Bloc<DeviceDaemonBlocEvent, DeviceDaemonBlocState> {
  Timer _timer;
  List<Device> _devices = [];

  DeviceDaemonBloc() {
    add(DeviceDaemonBlocEventInit());
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      for (int i = 0; i < _devices.length; ++i) {
        try {
          _updateDeviceStatus(_devices[i]);
        } catch (e) {}
      }
    });
  }

  Map<int, bool> _deviceWorker = {};

  void _updateDeviceStatus(Device device) async {
    if (_deviceWorker[device.id] == true) {
      return;
    }
    _deviceWorker[device.id] = true;

    bool found = false;
    var ddb = RelDB.get().devicesDAO;

    try {
      String identifier =
          await DeviceAPI.fetchStringParam(device.ip, 'BROKER_CLIENTID');
      if (identifier == device.identifier) {
        print('Device ${device.name} (${device.identifier}) found.');
        await ddb.updateDevice(DevicesCompanion(
            id: Value(device.id), isReachable: Value(found = true)));
      }
    } catch (e) {
      print('Device ${device.identifier} not found, trying mdns lookup.');
      RelDB.get().devicesDAO.updateDevice(DevicesCompanion(
          id: Value(device.id), isReachable: Value(found = false)));
      String ip;
      int nTries = 0;
      for (int i = 0; i < 4; ++i) {
        await new Future.delayed(const Duration(seconds: 2));
        Param mdns = await ddb.getParam(device.id, 'MDNS_DOMAIN');
        if (mdns == null) {
          return;
        }
        ip = await DeviceAPI.resolveLocalName(mdns.svalue);
        ++nTries;
      }
      if (ip != null && ip != "") {
        try {
          String identifier =
              await DeviceAPI.fetchStringParam(ip, 'BROKER_CLIENTID');
          if (identifier == device.identifier) {
            print(
                'Device ${device.name} (${device.identifier}) found after $nTries mdns lookup.');
            await ddb.updateDevice(DevicesCompanion(
                id: Value(device.id),
                isReachable: Value(found = true),
                ip: Value(ip)));
          }
        } catch (e) {
          print('Device ${device.name} (${device.identifier}) not found, aborting.');
          RelDB.get().devicesDAO.updateDevice(DevicesCompanion(
              id: Value(device.id), isReachable: Value(found = false)));
        }
      }
    }
    if (found) {
      await Future.delayed(Duration(seconds: 15));
    }
    _deviceWorker[device.id] = false;
  }

  @override
  DeviceDaemonBlocState get initialState => DeviceDaemonBlocStateInit();

  @override
  Stream<DeviceDaemonBlocState> mapEventToState(
      DeviceDaemonBlocEvent event) async* {
    if (event is DeviceDaemonBlocEventInit) {
      RelDB.get().devicesDAO.watchDevices().listen(_deviceListChanged);
    }
  }

  void _deviceListChanged(List<Device> devices) {
    _devices = devices;
  }

  @override
  Future<void> close() async {
    if (_timer != null) {
      _timer.cancel();
    }
    return super.close();
  }
}
