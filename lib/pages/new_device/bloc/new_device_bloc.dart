import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/models/device/device_data.dart';

abstract class NewDeviceBlocEvent extends Equatable {}

class NewDeviceBlocEventStartSearch extends NewDeviceBlocEvent {
  final String query;
  NewDeviceBlocEventStartSearch(this.query);

  @override
  List<Object> get props => [query];

}

abstract class NewDeviceBlocState extends Equatable {}

class NewDeviceBlocStateIdle extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateResolving extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateFound extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateNotFound extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateOutdated extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateDone extends NewDeviceBlocState {
  final DeviceData deviceData;
  NewDeviceBlocStateDone(this.deviceData);

  @override
  List<Object> get props => [deviceData];
}

class NewDeviceBloc extends Bloc<NewDeviceBlocEvent, NewDeviceBlocState> {

    @override
  NewDeviceBlocState get initialState => NewDeviceBlocStateIdle();

  @override
  Stream<NewDeviceBlocState> mapEventToState(NewDeviceBlocEvent event) async* {
    if (event is NewDeviceBlocEventStartSearch) {
      yield* this._startSearch(event);
    }
  }

  Stream<NewDeviceBlocState> _startSearch(NewDeviceBlocEventStartSearch event) async* {
    final ip = await KVDevice.resolveLocalName(event.query);
    if (ip == "") {
      yield NewDeviceBlocStateNotFound();
      return;
    }
    yield NewDeviceBlocStateFound();
    final deviceName = await KVDevice.fetchStringParam(ip, "DEVICE_NAME");
    final deviceId = await KVDevice.fetchStringParam(ip, "BROKER_CLIENTID");
    final config = await KVDevice.fetchConfig(ip);

    final deviceData = DeviceData(deviceId, deviceName);
    deviceData.config = config;
    // TODO store deviceData
    yield NewDeviceBlocStateDone(deviceData);
  }
}