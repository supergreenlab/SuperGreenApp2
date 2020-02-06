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

class DeviceNameBlocState extends Equatable {
  final Box box;
  final Device device;
  DeviceNameBlocState(this.box, this.device);

  @override
  List<Object> get props => [box, device];
}

class DeviceNameBlocStateDone extends DeviceNameBlocState {
  DeviceNameBlocStateDone(Box box, Device device) : super(box, device);
}

class DeviceNameBloc extends Bloc<DeviceNameBlocEvent, DeviceNameBlocState> {
  final MainNavigateToDeviceNameEvent _args;

  @override
  DeviceNameBlocState get initialState => DeviceNameBlocState(_args.box, _args.device);

  DeviceNameBloc(this._args);

  @override
  Stream<DeviceNameBlocState> mapEventToState(
      DeviceNameBlocEvent event) async* {
    if (event is DeviceNameBlocEventSetName) {
      await DeviceHelper.updateDeviceName(_args.device, event.name);
      yield DeviceNameBlocStateDone(_args.box, _args.device);
    }
  }
}
