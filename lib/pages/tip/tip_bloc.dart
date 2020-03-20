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


import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TipBlocEvent extends Equatable {}

class TipBlocEventInit extends TipBlocEvent {
  @override
  List<Object> get props => [];
}

class TipBlocState extends Equatable {

  final MainNavigateToFeedFormEvent nextRoute;

  TipBlocState(this.nextRoute);

  @override
  List<Object> get props => [nextRoute];
}

class TipBlocStateInit extends TipBlocState {
  TipBlocStateInit(MainNavigateToFeedFormEvent nextRoute) : super(nextRoute);
}

class TipBlocStateLoaded extends TipBlocState {
  final Map<String, dynamic> body;

  TipBlocStateLoaded(MainNavigateToFeedFormEvent nextRoute, this.body) : super(nextRoute);
  
  @override
  List<Object> get props => [nextRoute];
}

class TipBloc extends Bloc<TipBlocEvent,TipBlocState> {
  final MainNavigateToTipEvent _args;

  TipBloc(this._args) {
    add(TipBlocEventInit());
  }

  @override
  TipBlocState get initialState => TipBlocStateInit(_args.nextRoute);

  @override
  Stream<TipBlocState> mapEventToState(TipBlocEvent event) async* {
    if (event is TipBlocEventInit) {
      Response resp = await get('https://tipapi.supergreenlab.com/${_args.paths[0]}');
      Map<String, dynamic> body = JsonDecoder().convert(resp.body);
      yield TipBlocStateLoaded(_args.nextRoute, body);
    }
  }
}