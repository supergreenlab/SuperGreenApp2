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

class HomeNavigatorState extends Equatable {
  final int index;
  HomeNavigatorState(this.index);

  @override
  List<Object> get props => [index];
}

class HomeNavigatorBloc extends Bloc<HomeNavigatorEvent, HomeNavigatorState> {
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
  HomeNavigatorState get initialState => HomeNavigatorState(0);

  @override
  Stream<HomeNavigatorState> mapEventToState(HomeNavigatorEvent event) async* {
    if (event is HomeNavigateToBoxFeedEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/feed/box', arguments: event);
      yield HomeNavigatorState(1);
    } else if (event is HomeNavigateToSGLFeedEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/feed/sgl', arguments: event);
      yield HomeNavigatorState(0);
    } else {
      yield HomeNavigatorState(0);      
    }
  }
}
