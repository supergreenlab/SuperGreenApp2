import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
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
      await DeviceHelper.updateDeviceName(_args.device, event.name);
      yield DeviceNameBlocStateDone(_args.device);
    }
  }
}
