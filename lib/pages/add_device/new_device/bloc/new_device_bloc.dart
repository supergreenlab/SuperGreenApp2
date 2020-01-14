import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:wifi_iot/wifi_iot.dart';

const DefaultSSID = '🤖🍁';
const DefaultPass = 'multipass';

abstract class NewDeviceBlocEvent extends Equatable {}

class NewDeviceBlocEventStartSearch extends NewDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class NewDeviceBlocState extends Equatable {}

class NewDeviceBlocStateIdle extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateMissingPermission extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateConnectingToSSID extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateConnectionToSSIDFailed extends NewDeviceBlocState {
  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateConnectionToSSIDSuccess extends NewDeviceBlocState {
  final Box box;

  NewDeviceBlocStateConnectionToSSIDSuccess(this.box);

  @override
  List<Object> get props => [];
}

class NewDeviceBlocStateDone extends NewDeviceBlocState {
  final Box box;
  final Device device;
  NewDeviceBlocStateDone(this.box, this.device);

  @override
  List<Object> get props => [device];
}

class NewDeviceBloc extends Bloc<NewDeviceBlocEvent, NewDeviceBlocState> {
  MainNavigateToNewDeviceEvent _args;
  final PermissionHandler _permissionHandler = PermissionHandler();

  @override
  NewDeviceBlocState get initialState => NewDeviceBlocStateIdle();

  NewDeviceBloc(this._args) {
    Future.delayed(const Duration(seconds: 1), () => this.add(NewDeviceBlocEventStartSearch()));
  }

  @override
  Stream<NewDeviceBlocState> mapEventToState(NewDeviceBlocEvent event) async* {
    if (event is NewDeviceBlocEventStartSearch) {
      yield* this._startSearch(event);
    }
  }

  Stream<NewDeviceBlocState> _startSearch(
      NewDeviceBlocEventStartSearch event) async* {
    if (Platform.isIOS &&
        await _permissionHandler
                .checkPermissionStatus(PermissionGroup.locationWhenInUse) !=
            PermissionStatus.granted) {
      final result = await _permissionHandler
          .requestPermissions([PermissionGroup.locationWhenInUse]);
      if (result[PermissionGroup.locationWhenInUse] !=
          PermissionStatus.granted) {
        yield NewDeviceBlocStateMissingPermission();
        return;
      }
    }
    final currentSSID = await WiFiForIoTPlugin.getSSID();
    if (currentSSID != DefaultSSID) {
      yield NewDeviceBlocStateConnectingToSSID();
      if (await WiFiForIoTPlugin.connect(DefaultSSID,
              password: DefaultPass, security: NetworkSecurity.WPA) ==
          false) {
        yield NewDeviceBlocStateConnectionToSSIDFailed();
        return;
      }
    }
    yield NewDeviceBlocStateConnectionToSSIDSuccess(_args.box);
  }
}
