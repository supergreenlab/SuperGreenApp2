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
  final Device device;
  DeviceNameBlocState(this.device);

  @override
  List<Object> get props => [device];
}

class DeviceNameBlocStateDone extends DeviceNameBlocState {
  DeviceNameBlocStateDone(Device device) : super(device);
}

class DeviceNameBloc extends Bloc<DeviceNameBlocEvent, DeviceNameBlocState> {
  final MainNavigateToDeviceNameEvent _args;

  @override
  DeviceNameBlocState get initialState => DeviceNameBlocState(_args.device);

  DeviceNameBloc(this._args);

  @override
  Stream<DeviceNameBlocState> mapEventToState(
      DeviceNameBlocEvent event) async* {
    if (event is DeviceNameBlocEventSetName) {
      var ddb = RelDB.get().devicesDAO;
      await DeviceHelper.updateDeviceName(_args.device, event.name);
      Param mdns = await ddb.getParam(_args.device.id, 'MDNS_DOMAIN');
      await DeviceHelper.updateStringParam(_args.device, mdns, event.name.toLowerCase());
      yield DeviceNameBlocStateDone(_args.device);
    }
  }
}
