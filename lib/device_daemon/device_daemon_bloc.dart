import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/device_helper.dart';
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
  
  List<Device> _devices = [];

  DeviceDaemonBloc() {
    add(DeviceDaemonBlocEventInit());
    Timer.periodic(Duration(seconds: 5), (timer) async {
      for (int i = 0; i < _devices.length; ++i) {
        await DeviceHelper.refreshIntParam(device, wifiStatusParam);
      }
    });
  }

  @override
  DeviceDaemonBlocState get initialState => DeviceDaemonBlocStateInit();

  @override
  Stream<DeviceDaemonBlocState> mapEventToState(DeviceDaemonBlocEvent event) async* {
    if (event is DeviceDaemonBlocEventInit) {
      RelDB.get().devicesDAO.watchDevices().listen(_deviceListChanged);
    }
  }

  void _deviceListChanged(List<Device> devices) {
    _devices = devices;
  }
}
