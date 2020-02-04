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

class SelectDeviceBlocEventSelectDevice extends SelectDeviceBlocEvent {
  final Device device;

  SelectDeviceBlocEventSelectDevice(this.device) : super();

  @override
  List<Object> get props => [device];
}

class SelectDeviceBlocState extends Equatable {
  final Box box;

  SelectDeviceBlocState(this.box);

  @override
  List<Object> get props => [box];
}

class SelectDeviceBlocStateIdle extends SelectDeviceBlocState {
  SelectDeviceBlocStateIdle(Box box) : super(box);
}

class SelectDeviceBlocStateDeviceListUpdated extends SelectDeviceBlocState {
  final List<Device> devices;

  SelectDeviceBlocStateDeviceListUpdated(Box box, this.devices) : super(box);

  @override
  List<Object> get props => [box, devices];
}

class SelectDeviceBlocStateDone extends SelectDeviceBlocState {
  SelectDeviceBlocStateDone(Box box) : super(box);
}

class SelectDeviceBloc
    extends Bloc<SelectDeviceBlocEvent, SelectDeviceBlocState> {
  final MainNavigateToSelectBoxDeviceEvent _args;

  @override
  SelectDeviceBlocState get initialState =>
      SelectDeviceBlocStateIdle(_args.box);

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
      yield SelectDeviceBlocStateDeviceListUpdated(_args.box, event.devices);
    } else if (event is SelectDeviceBlocEventSelectDevice) {
      final bdb = RelDB.get().boxesDAO;
      await bdb.updateBox(
          _args.box.id, BoxesCompanion(device: Value(event.device.id)));
      Box box = await bdb.getBox(_args.box.id);
      yield SelectDeviceBlocStateDone(box);
    }
  }

  void _onDeviceListChanged(List<Device> devices) {
    add(SelectDeviceBlocEventDeviceListUpdated(devices));
  }
}
