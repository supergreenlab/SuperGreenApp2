import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceDoneBlocEvent extends Equatable {}

class DeviceDoneBlocEventSetBox extends DeviceDoneBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceDoneBlocState extends Equatable {
  final Device device;

  DeviceDoneBlocState(this.device);

  @override
  List<Object> get props => [];
}

class DeviceDoneBlocStateDone extends DeviceDoneBlocState {
  DeviceDoneBlocStateDone(Device device) : super(device);
}

class DeviceDoneBloc extends Bloc<DeviceDoneBlocEvent, DeviceDoneBlocState> {
  final MainNavigateToDeviceDoneEvent _args;

  @override
  DeviceDoneBlocState get initialState => DeviceDoneBlocState(_args.device);

  DeviceDoneBloc(this._args) {
    Timer(Duration(seconds: 1), () => add(DeviceDoneBlocEventSetBox()));
  }

  @override
  Stream<DeviceDoneBlocState> mapEventToState(DeviceDoneBlocEvent event) async* {
    if (event is DeviceDoneBlocEventSetBox) {
      yield DeviceDoneBlocStateDone(_args.device);
    }
  }
}
