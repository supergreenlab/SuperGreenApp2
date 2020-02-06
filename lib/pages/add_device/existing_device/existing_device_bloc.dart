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

class ExistingDeviceBlocState extends Equatable {
    final Box box;

  ExistingDeviceBlocState(this.box);

  @override
  List<Object> get props => [this.box];

}

class ExistingDeviceBlocStateResolving extends ExistingDeviceBlocState {
  ExistingDeviceBlocStateResolving(Box box) : super(box);
}

class ExistingDeviceBlocStateFound extends ExistingDeviceBlocState {
  final String ip;
  ExistingDeviceBlocStateFound(Box box, this.ip) : super(box);

  @override
  List<Object> get props => [this.box, this.ip];
}

class ExistingDeviceBlocStateNotFound extends ExistingDeviceBlocState {
  ExistingDeviceBlocStateNotFound(Box box) : super(box);
}

class ExistingDeviceBloc
    extends Bloc<ExistingDeviceBlocEvent, ExistingDeviceBlocState> {
  final MainNavigateToExistingDeviceEvent _args;

  ExistingDeviceBloc(this._args);

  @override
  ExistingDeviceBlocState get initialState => ExistingDeviceBlocState(_args.box);

  @override
  Stream<ExistingDeviceBlocState> mapEventToState(
      ExistingDeviceBlocEvent event) async* {
    if (event is ExistingDeviceBlocEventStartSearch) {
      final ip = await DeviceAPI.resolveLocalName(event.query);
      if (ip == "") {
        yield ExistingDeviceBlocStateNotFound(_args.box);
        return;
      }
      yield ExistingDeviceBlocStateFound(_args.box, ip);
    }
  }

}
