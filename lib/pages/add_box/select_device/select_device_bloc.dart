import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBlocEvent extends Equatable {}

class SelectDeviceBlocEventLoadDevices extends SelectDeviceBlocEvent {
  SelectDeviceBlocEventLoadDevices() : super();

  @override
  List<Object> get props => [];
}

class SelectDeviceBlocEventDeviceListUpdated extends SelectDeviceBlocEvent {
  final List<Device> devices;

  SelectDeviceBlocEventDeviceListUpdated(this.devices) : super();

  @override
  List<Object> get props => [devices];
}

class SelectDeviceBlocState extends Equatable {
  final List<Device> devices;

  SelectDeviceBlocState(this.devices);

  @override
  List<Object> get props => [devices];
}

class SelectDeviceBlocStateDeviceListUpdated extends SelectDeviceBlocState {
  SelectDeviceBlocStateDeviceListUpdated(List<Device> devices) : super(devices);
}

class SelectDeviceBlocStateDone extends SelectDeviceBlocState {
  final Device device;

  SelectDeviceBlocStateDone(List<Device> devices, this.device) : super(devices);

  @override
  List<Object> get props => [devices, device];
}

class SelectDeviceBloc
    extends Bloc<SelectDeviceBlocEvent, SelectDeviceBlocState> {
  List<Device> _devices = [];

  final MainNavigateToSelectBoxDeviceEvent _args;

  @override
  SelectDeviceBlocState get initialState => SelectDeviceBlocState(_devices);

  SelectDeviceBloc(this._args) {
    this.add(SelectDeviceBlocEventLoadDevices());
  }

  @override
  Stream<SelectDeviceBlocState> mapEventToState(
      SelectDeviceBlocEvent event) async* {
    if (event is SelectDeviceBlocEventLoadDevices) {
      final ddb = RelDB.get().devicesDAO;
      final watcher = ddb.watchDevices();
      watcher.listen(_onDeviceListChanged);
    } else if (event is SelectDeviceBlocEventDeviceListUpdated) {
      _devices = event.devices;
      yield SelectDeviceBlocStateDeviceListUpdated(_devices);
    }
  }

  void _onDeviceListChanged(List<Device> devices) {
    add(SelectDeviceBlocEventDeviceListUpdated(devices));
  }
}
