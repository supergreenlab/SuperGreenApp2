import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/models/device/device_data.dart';

abstract class ExistingDeviceBlocEvent extends Equatable {}

class ExistingDeviceBlocEventStartSearch extends ExistingDeviceBlocEvent {
  final String query;
  ExistingDeviceBlocEventStartSearch(this.query);

  @override
  List<Object> get props => [query];

}

abstract class ExistingDeviceBlocState extends Equatable {}

class ExistingDeviceBlocStateIdle extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateResolving extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateFound extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateNotFound extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateOutdated extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateDone extends ExistingDeviceBlocState {
  final DeviceData deviceData;
  ExistingDeviceBlocStateDone(this.deviceData);

  @override
  List<Object> get props => [deviceData];
}

class ExistingDeviceBloc extends Bloc<ExistingDeviceBlocEvent, ExistingDeviceBlocState> {

    @override
  ExistingDeviceBlocState get initialState => ExistingDeviceBlocStateIdle();

  @override
  Stream<ExistingDeviceBlocState> mapEventToState(ExistingDeviceBlocEvent event) async* {
    if (event is ExistingDeviceBlocEventStartSearch) {
      yield* this._startSearch(event);
    }
  }

  Stream<ExistingDeviceBlocState> _startSearch(ExistingDeviceBlocEventStartSearch event) async* {
    final ip = await KVDevice.resolveLocalName(event.query);
    if (ip == "") {
      yield ExistingDeviceBlocStateNotFound();
      return;
    }
    yield ExistingDeviceBlocStateFound();
    final deviceName = await KVDevice.fetchStringParam(ip, "DEVICE_NAME");
    final deviceId = await KVDevice.fetchStringParam(ip, "BROKER_CLIENTID");
    final config = await KVDevice.fetchConfig(ip);

    final deviceData = DeviceData(deviceId, deviceName);
    deviceData.config = config;
    // TODO store deviceData
    yield ExistingDeviceBlocStateDone(deviceData);
  }
}