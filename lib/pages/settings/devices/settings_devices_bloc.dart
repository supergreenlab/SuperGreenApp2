import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/helpers/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsDevicesBlocEvent extends Equatable {}

class SettingsDevicesBlocEventInit extends SettingsDevicesBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDevicesblocEventBoxListChanged extends SettingsDevicesBlocEvent {
  final List<Device> devices;

  SettingsDevicesblocEventBoxListChanged(this.devices);

  @override
  List<Object> get props => [devices];
}

class SettingsDevicesBlocEventDeleteDevice extends SettingsDevicesBlocEvent {
  final Device device;

  SettingsDevicesBlocEventDeleteDevice(this.device);

  @override
  List<Object> get props => [device];
}

abstract class SettingsDevicesBlocState extends Equatable {}

class SettingsDevicesBlocStateInit extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateLoading extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateNotEmptyBox extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateLoaded extends SettingsDevicesBlocState {
  final List<Device> devices;

  SettingsDevicesBlocStateLoaded(this.devices);

  @override
  List<Object> get props => [devices];
}

class SettingsDevicesBloc
    extends Bloc<SettingsDevicesBlocEvent, SettingsDevicesBlocState> {
  List<Device> devices;
  StreamSubscription<List<Device>> _devicesStream;

  //ignore: unused_field
  final MainNavigateToSettingsDevices args;

  SettingsDevicesBloc(this.args) : super(SettingsDevicesBlocStateInit()) {
    add(SettingsDevicesBlocEventInit());
  }

  @override
  Stream<SettingsDevicesBlocState> mapEventToState(event) async* {
    if (event is SettingsDevicesBlocEventInit) {
      yield SettingsDevicesBlocStateLoading();
      _devicesStream =
          RelDB.get().devicesDAO.watchDevices().listen(_onDeviceListChange);
    } else if (event is SettingsDevicesblocEventBoxListChanged) {
      yield SettingsDevicesBlocStateLoaded(event.devices);
    } else if (event is SettingsDevicesBlocEventDeleteDevice) {
      await RelDB.get().plantsDAO.cleanDeviceIDs(event.device.id);
      await DeviceHelper.deleteDevice(event.device);
    }
  }

  void _onDeviceListChange(List<Device> d) {
    devices = d;
    add(SettingsDevicesblocEventBoxListChanged(devices));
  }

  @override
  Future<void> close() async {
    if (_devicesStream != null) {
      await _devicesStream.cancel();
    }
    return super.close();
  }
}
