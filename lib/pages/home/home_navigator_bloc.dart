/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class HomeNavigatorEvent extends Equatable {}

class HomeNavigateEventInit extends HomeNavigatorEvent {
  HomeNavigateEventInit();

  @override
  List<Object> get props => [];
}

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

class HomeNavigateToExplorerEvent extends HomeNavigatorEvent {
  HomeNavigateToExplorerEvent();

  @override
  List<Object> get props => [];
}

class HomeNavigateToSettingsEvent extends HomeNavigatorEvent {
  HomeNavigateToSettingsEvent();

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
  final MainNavigatorEvent _args;
  final GlobalKey<NavigatorState> _navigatorKey;

  HomeNavigatorBloc(this._args, this._navigatorKey) {
    /*if (_args is MainNavigateToHomeBoxEvent) {
      this.add(HomeNavigateToBoxFeedEvent(
          (_args as MainNavigateToHomeBoxEvent).box));
    } else */
  }

  @override
  HomeNavigatorState get initialState => HomeNavigatorState(0);

  @override
  Stream<HomeNavigatorState> mapEventToState(HomeNavigatorEvent event) async* {
    if (event is HomeNavigateEventInit) {
      if (AppDB().getAppData().lastBoxID != null) {
        add(HomeNavigateToBoxFeedEvent(null));
      }
    } else if (event is HomeNavigateToSGLFeedEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/feed/sgl', arguments: event);
      yield HomeNavigatorState(0);
    } else if (event is HomeNavigateToBoxFeedEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/feed/box', arguments: event);
      yield HomeNavigatorState(1);
    } else if (event is HomeNavigateToExplorerEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/explorer', arguments: event);
      yield HomeNavigatorState(2);
    } else if (event is HomeNavigateToSettingsEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/settings', arguments: event);
      yield HomeNavigatorState(3);
    } else {
      yield HomeNavigatorState(0);
    }
  }
}
