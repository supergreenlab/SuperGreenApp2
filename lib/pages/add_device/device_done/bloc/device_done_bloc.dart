import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/models/device/device_data.dart';

abstract class DeviceDoneBlocEvent extends Equatable {}

class DeviceDoneBlocEventSetName extends DeviceDoneBlocEvent {
  final String name;
  DeviceDoneBlocEventSetName(this.name);

  @override
  List<Object> get props => [];
}

class DeviceDoneBlocEventReset extends DeviceDoneBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class DeviceDoneBlocState extends Equatable {}

class DeviceDoneBlocStateIdle extends DeviceDoneBlocState {
  @override
  List<Object> get props => [];
}

class DeviceDoneBlocStateDone extends DeviceDoneBlocState {
  final DeviceData deviceData;
  DeviceDoneBlocStateDone(this.deviceData);

  @override
  List<Object> get props => [];
}

class DeviceDoneBloc extends Bloc<DeviceDoneBlocEvent, DeviceDoneBlocState> {
  DeviceData _deviceData;

  @override
  DeviceDoneBlocState get initialState => DeviceDoneBlocStateIdle();

  DeviceDoneBloc(this._deviceData);

  @override
  Stream<DeviceDoneBlocState> mapEventToState(DeviceDoneBlocEvent event) async* {
    if (event is DeviceDoneBlocEventSetName) {
      await KVDevice.setStringParam(_deviceData.ip, 'DEVICE_NAME', event.name);
      yield DeviceDoneBlocStateDone(_deviceData);
    }
  }
}
