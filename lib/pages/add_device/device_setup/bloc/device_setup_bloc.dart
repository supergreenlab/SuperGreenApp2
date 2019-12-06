import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/models/device/device_data.dart';

abstract class DeviceSetupBlocEvent extends Equatable {}

class DeviceSetupBlocEventStartSetup extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class DeviceSetupBlocState extends Equatable {}

class DeviceSetupBlocStateIdle extends DeviceSetupBlocState {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocStateOutdated extends DeviceSetupBlocState {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocStateDone extends DeviceSetupBlocState {
  final DeviceData deviceData;
  DeviceSetupBlocStateDone(this.deviceData);

  @override
  List<Object> get props => [deviceData];
}

class DeviceSetupBloc extends Bloc<DeviceSetupBlocEvent, DeviceSetupBlocState> {
  String ip;

  @override
  DeviceSetupBlocState get initialState => DeviceSetupBlocStateIdle();

  DeviceSetupBloc(this.ip) {
    Future.delayed(const Duration(seconds: 1), () => this.add(DeviceSetupBlocEventStartSetup()));
  }

  @override
  Stream<DeviceSetupBlocState> mapEventToState(
      DeviceSetupBlocEvent event) async* {
    if (event is DeviceSetupBlocEventStartSetup) {
      yield* this._startSearch(event);
    }
  }

  Stream<DeviceSetupBlocState> _startSearch(
      DeviceSetupBlocEventStartSetup event) async* {
    final deviceName = await KVDevice.fetchStringParam(ip, "DEVICE_NAME");
    final deviceId = await KVDevice.fetchStringParam(ip, "BROKER_CLIENTID");
    final config = await KVDevice.fetchConfig(ip);

    print(deviceName);
    print(deviceId);
    print(config);

    final deviceData = DeviceData(deviceId, deviceName);
    deviceData.config = config;
    // TODO store deviceData
    yield DeviceSetupBlocStateDone(deviceData);
  }
}
