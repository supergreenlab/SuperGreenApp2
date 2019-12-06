import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeNavigatorAction extends Equatable {}

class HomeNavigateToMonitoringEvent extends HomeNavigatorAction {
  @override
  List<Object> get props => [];
}

class HomeNavigateToControlEvent extends HomeNavigatorAction {
  @override
  List<Object> get props => [];
}

class HomeNavigateToSocialEvent extends HomeNavigatorAction {
  @override
  List<Object> get props => [];
}

class HomeNavigatorActionPop extends HomeNavigatorAction {
  @override
  List<Object> get props => [];
}

class HomeNavigatorBloc extends Bloc<HomeNavigatorAction, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  HomeNavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(HomeNavigatorAction event) async* {
    if (event is HomeNavigatorActionPop) {
      navigatorKey.currentState.pop();
    } else if (event is HomeNavigateToMonitoringEvent) {
      navigatorKey.currentState.pushReplacementNamed('/monitoring', arguments: event);
    } else if (event is HomeNavigateToControlEvent) {
      navigatorKey.currentState.pushReplacementNamed('/control', arguments: event);
    } else if (event is HomeNavigateToSocialEvent) {
      navigatorKey.currentState.pushReplacementNamed('/social', arguments: event);
    }
  }

}
