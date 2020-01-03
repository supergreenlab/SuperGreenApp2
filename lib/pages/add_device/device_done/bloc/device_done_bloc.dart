import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

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
  final Device device;
  DeviceDoneBlocStateDone(this.device);

  @override
  List<Object> get props => [];
}

class DeviceDoneBloc extends Bloc<DeviceDoneBlocEvent, DeviceDoneBlocState> {
  final MainNavigateToDeviceDoneEvent _args;

  @override
  DeviceDoneBlocState get initialState => DeviceDoneBlocStateIdle();

  DeviceDoneBloc(this._args);

  @override
  Stream<DeviceDoneBlocState> mapEventToState(DeviceDoneBlocEvent event) async* {
    if (event is DeviceDoneBlocEventSetName) {
      await DeviceAPI.setStringParam(_args.device.ip, 'DEVICE_NAME', event.name);
      await DeviceAPI.setStringParam(_args.device.ip, 'MDNS_DOMAIN', event.name.toLowerCase());
      yield DeviceDoneBlocStateDone(_args.device);
    }
  }
}
