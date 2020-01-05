import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceDoneBlocEvent extends Equatable {}

abstract class DeviceDoneBlocState extends Equatable {}

class DeviceDoneBlocStateIdle extends DeviceDoneBlocState {
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
  }
}
