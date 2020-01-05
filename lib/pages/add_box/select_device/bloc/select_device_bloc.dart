import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBlocEvent extends Equatable {
  final Box box;

  SelectDeviceBlocEvent(this.box);

  @override
  List<Object> get props => [box];
}

class SelectDeviceBlocEventLoadDevices extends SelectDeviceBlocEvent {
  SelectDeviceBlocEventLoadDevices(Box box) : super(box);

  @override
  List<Object> get props => [box];
}

class SelectDeviceBlocEventSelectDevice extends SelectDeviceBlocEvent {
  final Device device;

  SelectDeviceBlocEventSelectDevice(box, this.device) : super(box);

  @override
  List<Object> get props => [box, device];
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

class SelectDeviceBlocStateLoadedDevices extends SelectDeviceBlocState {
  final List<Device> devices;

  SelectDeviceBlocStateLoadedDevices(Box box, this.devices) : super(box);

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
  SelectDeviceBlocState get initialState => SelectDeviceBlocStateIdle(_args.box);

  SelectDeviceBloc(this._args) {
    this.add(SelectDeviceBlocEventLoadDevices(_args.box));
  }

  @override
  Stream<SelectDeviceBlocState> mapEventToState(
      SelectDeviceBlocEvent event) async* {
    if (event is SelectDeviceBlocEventLoadDevices) {
      final ddb = RelDB.get().devicesDAO;
      final devices = await ddb.getDevices();
      yield SelectDeviceBlocStateLoadedDevices(event.box, devices);
    } else if (event is SelectDeviceBlocEventSelectDevice) {
      final bdb = RelDB.get().boxesDAO;
      await bdb.updateBox(event.box.id, BoxesCompanion(device: Value(event.device.id)));
      yield SelectDeviceBlocStateDone(_args.box);
    }
  }
}
