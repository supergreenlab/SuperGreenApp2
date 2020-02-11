import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class HomeNavigatorEvent extends Equatable {}

class HomeNavigateToBoxFeedEvent extends HomeNavigatorEvent {
  final Box box;

  HomeNavigateToBoxFeedEvent(this.box);

  @override
  List<Object> get props => [box];
}

class HomeNavigateToSGLFeedEvent extends HomeNavigatorEvent {
  HomeNavigateToSGLFeedEvent() : super();

  @override
  List<Object> get props => [];
}

class HomeNavigatorEventPop extends HomeNavigatorEvent {
  @override
  List<Object> get props => [];
}

class HomeNavigatorBloc extends Bloc<HomeNavigatorEvent, dynamic> {
  static final eventBus = EventBus();

  final MainNavigatorEvent _args;
  final GlobalKey<NavigatorState> _navigatorKey;

  HomeNavigatorBloc(this._args, this._navigatorKey) {
    if (_args is MainNavigateToHomeBoxEvent) {
      this.add(HomeNavigateToBoxFeedEvent((_args as MainNavigateToHomeBoxEvent).box));
    }
    eventBus.on<HomeNavigatorEvent>().listen((e) {
      this.add(e);
    });
  }

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(HomeNavigatorEvent event) async* {
    if (event is HomeNavigatorEventPop) {
      _navigatorKey.currentState.pop();
    } else if (event is HomeNavigateToBoxFeedEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/feed/box', arguments: event);
    } else if (event is HomeNavigateToSGLFeedEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/feed/sgl', arguments: event);
    }
  }
}
