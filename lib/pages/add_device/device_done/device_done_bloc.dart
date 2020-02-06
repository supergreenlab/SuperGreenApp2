import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceDoneBlocEvent extends Equatable {}

class DeviceDoneBlocEventSetBox extends DeviceDoneBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceDoneBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class DeviceDoneBlocStateDone extends DeviceDoneBlocState {
  DeviceDoneBlocStateDone();
}

class DeviceDoneBloc extends Bloc<DeviceDoneBlocEvent, DeviceDoneBlocState> {
  final MainNavigateToDeviceDoneEvent _args;

  @override
  DeviceDoneBlocState get initialState => DeviceDoneBlocState();

  DeviceDoneBloc(this._args) {
    Timer(Duration(seconds: 1), () => add(DeviceDoneBlocEventSetBox()));
  }

  @override
  Stream<DeviceDoneBlocState> mapEventToState(DeviceDoneBlocEvent event) async* {
    if (event is DeviceDoneBlocEventSetBox) {
      final db = RelDB.get();
      await db.boxesDAO.updateBox(_args.box.id, _args.box.createCompanion(true).copyWith(device: Value(_args.device.id)));
      yield DeviceDoneBlocStateDone();
    }
  }
}
