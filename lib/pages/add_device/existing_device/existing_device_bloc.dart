import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class ExistingDeviceBlocEvent extends Equatable {}

class ExistingDeviceBlocEventStartSearch extends ExistingDeviceBlocEvent {
  final String query;
  ExistingDeviceBlocEventStartSearch(this.query);

  @override
  List<Object> get props => [query];
}

class ExistingDeviceBlocState extends Equatable {
  @override
  List<Object> get props => [];

}

class ExistingDeviceBlocStateResolving extends ExistingDeviceBlocState {
  ExistingDeviceBlocStateResolving() : super();
}

class ExistingDeviceBlocStateFound extends ExistingDeviceBlocState {
  final String ip;
  ExistingDeviceBlocStateFound(this.ip) : super();

  @override
  List<Object> get props => [this.ip];
}

class ExistingDeviceBlocStateNotFound extends ExistingDeviceBlocState {
  ExistingDeviceBlocStateNotFound();
}

class ExistingDeviceBloc
    extends Bloc<ExistingDeviceBlocEvent, ExistingDeviceBlocState> {
  final MainNavigateToExistingDeviceEvent _args;

  ExistingDeviceBloc(this._args);

  @override
  ExistingDeviceBlocState get initialState => ExistingDeviceBlocState();

  @override
  Stream<ExistingDeviceBlocState> mapEventToState(
      ExistingDeviceBlocEvent event) async* {
    if (event is ExistingDeviceBlocEventStartSearch) {
      yield ExistingDeviceBlocStateResolving();
      final ip = await DeviceAPI.resolveLocalName(event.query);
      if (ip == "" || ip == null) {
        yield ExistingDeviceBlocStateNotFound();
        return;
      }
      yield ExistingDeviceBlocStateFound(ip);
    }
  }

}
