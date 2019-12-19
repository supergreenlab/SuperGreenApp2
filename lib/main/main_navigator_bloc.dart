import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/device/storage/devices.dart';

abstract class MainNavigatorEvent extends Equatable {}

class MainNavigateToHomeEvent extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigateToNewDeviceEvent extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigateToExistingDeviceEvent extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceSetupEvent extends MainNavigatorEvent {
  final ip;
  MainNavigateToDeviceSetupEvent(this.ip);

  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceNameEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceNameEvent(this.device);

  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceDoneEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceDoneEvent(this.device);

  @override
  List<Object> get props => [];
}

class MainNavigatorActionPop extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigatorBloc extends Bloc<MainNavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> _navigatorKey;
  MainNavigatorBloc(this._navigatorKey);

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(MainNavigatorEvent event) async* {
    if (event is MainNavigatorActionPop) {
      _navigatorKey.currentState.pop();
    } else if (event is MainNavigateToHomeEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/home', arguments: event);
    } else if (event is MainNavigateToNewDeviceEvent) {
      _navigatorKey.currentState.pushNamed('/setup/new', arguments: event);
    } else if (event is MainNavigateToExistingDeviceEvent) {
      _navigatorKey.currentState.pushNamed('/setup/add', arguments: event);
    } else if (event is MainNavigateToDeviceSetupEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/setup/load', arguments: event);
    } else if (event is MainNavigateToDeviceNameEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/setup/name', arguments: event);
    } else if (event is MainNavigateToDeviceDoneEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/setup/done', arguments: event);
    }
  }
}
