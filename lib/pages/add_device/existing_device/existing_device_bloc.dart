import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

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
  final Box box;
  final String ip;
  ExistingDeviceBlocStateFound(this.box, this.ip);

  @override
  List<Object> get props => [];
}

class ExistingDeviceBlocStateNotFound extends ExistingDeviceBlocState {
  @override
  List<Object> get props => [];
}

class ExistingDeviceBloc
    extends Bloc<ExistingDeviceBlocEvent, ExistingDeviceBlocState> {
  final MainNavigateToExistingDeviceEvent _args;

  ExistingDeviceBloc(this._args);

  @override
  ExistingDeviceBlocState get initialState => ExistingDeviceBlocStateIdle();

  @override
  Stream<ExistingDeviceBlocState> mapEventToState(
      ExistingDeviceBlocEvent event) async* {
    if (event is ExistingDeviceBlocEventStartSearch) {
      final ip = await DeviceAPI.resolveLocalName(event.query);
      if (ip == "") {
        yield ExistingDeviceBlocStateNotFound();
        return;
      }
      yield ExistingDeviceBlocStateFound(_args.box, ip);
    }
  }

}
