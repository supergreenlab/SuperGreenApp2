import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/device/api/device_api.dart';
import 'package:super_green_app/data/device/storage/devices.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceNameBlocEvent extends Equatable {}

class DeviceNameBlocEventSetName extends DeviceNameBlocEvent {
  final String name;
  DeviceNameBlocEventSetName(this.name);

  @override
  List<Object> get props => [];
}

class DeviceNameBlocEventReset extends DeviceNameBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class DeviceNameBlocState extends Equatable {}

class DeviceNameBlocStateIdle extends DeviceNameBlocState {
  @override
  List<Object> get props => [];
}

class DeviceNameBlocStateDone extends DeviceNameBlocState {
  final Device device;
  DeviceNameBlocStateDone(this.device);

  @override
  List<Object> get props => [];
}

class DeviceNameBloc extends Bloc<DeviceNameBlocEvent, DeviceNameBlocState> {
  final MainNavigateToDeviceNameEvent _args;

  @override
  DeviceNameBlocState get initialState => DeviceNameBlocStateIdle();

  DeviceNameBloc(this._args);

  @override
  Stream<DeviceNameBlocState> mapEventToState(DeviceNameBlocEvent event) async* {
    if (event is DeviceNameBlocEventSetName) {
      await DeviceAPI.setStringParam(_args.device.ip, 'DEVICE_NAME', event.name);
      yield DeviceNameBlocStateDone(_args.device);
    }
  }
}
