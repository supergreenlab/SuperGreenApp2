import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/device/storage/devices.dart';

abstract class HomeNavigatorAction extends Equatable {}

class HomeNavigateToMonitoringEvent extends HomeNavigatorAction {
  final Device device;

  HomeNavigateToMonitoringEvent(this.device);

  @override
  List<Object> get props => [];
}

class HomeNavigateToControlEvent extends HomeNavigatorAction {
  final Device device;

  HomeNavigateToControlEvent(this.device);

  @override
  List<Object> get props => [];
}

class HomeNavigateToSocialEvent extends HomeNavigatorAction {
  final Device device;

  HomeNavigateToSocialEvent(this.device);

  @override
  List<Object> get props => [];
}

class HomeNavigatorActionPop extends HomeNavigatorAction {
  @override
  List<Object> get props => [];
}

class HomeNavigatorBloc extends Bloc<HomeNavigatorAction, dynamic> {
  final GlobalKey<NavigatorState> _navigatorKey;
  HomeNavigatorBloc(this._navigatorKey);

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(HomeNavigatorAction event) async* {
    if (event is HomeNavigatorActionPop) {
      _navigatorKey.currentState.pop();
    } else if (event is HomeNavigateToMonitoringEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/monitoring', arguments: event);
    } else if (event is HomeNavigateToControlEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/control', arguments: event);
    } else if (event is HomeNavigateToSocialEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/social', arguments: event);
    }
  }

}
