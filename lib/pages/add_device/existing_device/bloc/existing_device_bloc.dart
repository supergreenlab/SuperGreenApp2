import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/apis/device/kv_device.dart';

abstract class ExistingDeviceBlocEvent extends Equatable {}

class ExistingDeviceBlocEventStartSearch extends ExistingDeviceBlocEvent {
  final String query;
  ExistingDeviceBlocEventStartSearch(this.query);

  @override
  List<Object> get props => [query];

}

abstract class ExistingDeviceBlocState extends Equatable {}

class ExistingDeviceBlocStateIdle extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateResolving extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateFound extends ExistingDeviceBlocState {
  final String ip;
  ExistingDeviceBlocStateFound(this.ip);

  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateNotFound extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBloc extends Bloc<ExistingDeviceBlocEvent, ExistingDeviceBlocState> {

    @override
  ExistingDeviceBlocState get initialState => ExistingDeviceBlocStateIdle();

  @override
  Stream<ExistingDeviceBlocState> mapEventToState(ExistingDeviceBlocEvent event) async* {
    if (event is ExistingDeviceBlocEventStartSearch) {
      yield* this._startSearch(event);
    }
  }

  Stream<ExistingDeviceBlocState> _startSearch(ExistingDeviceBlocEventStartSearch event) async* {
    final ip = await KVDevice.resolveLocalName(event.query);
    if (ip == "") {
      yield ExistingDeviceBlocStateNotFound();
      return;
    }
    yield ExistingDeviceBlocStateFound(ip);
  }
}