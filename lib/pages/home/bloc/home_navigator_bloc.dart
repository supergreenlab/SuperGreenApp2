import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class HomeNavigatorEvent extends Equatable {}

abstract class HomeNavigateToFeedEvent extends HomeNavigatorEvent {
  final Feed feed;

  HomeNavigateToFeedEvent(this.feed);
}

class HomeNavigateToBoxFeedEvent extends HomeNavigateToFeedEvent {
  final Box box;

  HomeNavigateToBoxFeedEvent(Feed feed, this.box) : super(feed);

  @override
  List<Object> get props => [this.feed, box];
}

class HomeNavigatorEventPop extends HomeNavigatorEvent {
  @override
  List<Object> get props => [];
}

class HomeNavigatorBloc extends Bloc<HomeNavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> _navigatorKey;
  HomeNavigatorBloc(this._navigatorKey);

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(HomeNavigatorEvent event) async* {
    if (event is HomeNavigatorEventPop) {
      _navigatorKey.currentState.pop();
    } else if (event is HomeNavigateToBoxFeedEvent) {
      _navigatorKey.currentState.pushReplacementNamed('/feed/box', arguments: event);
    }
  }

}
