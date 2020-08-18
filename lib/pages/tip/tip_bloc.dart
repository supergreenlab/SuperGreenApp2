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
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TipBlocEvent extends Equatable {}

class TipBlocEventInit extends TipBlocEvent {
  @override
  List<Object> get props => [];
}

class TipBlocEventDone extends TipBlocEvent {
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
  final List<Map<String, dynamic>> tips;

  TipBlocStateLoaded(MainNavigateToFeedFormEvent nextRoute, this.tips)
      : super(nextRoute);

  @override
  List<Object> get props => [nextRoute];
}

class TipBloc extends Bloc<TipBlocEvent, TipBlocState> {
  final MainNavigateToTipEvent args;

  TipBloc(this.args) : super(TipBlocStateInit(args.nextRoute)) {
    add(TipBlocEventInit());
  }

  @override
  Stream<TipBlocState> mapEventToState(TipBlocEvent event) async* {
    if (event is TipBlocEventInit) {
      List<Map<String, dynamic>> tips = [];
      for (int i = 0; i < args.paths.length; i += 1) {
        Response resp =
            await get('https://tipapi.supergreenlab.com/${args.paths[i]}');
        Map<String, dynamic> body = JsonDecoder().convert(resp.body);
        if (body != null && body.length > 0) {
          tips.add(body);
        }
      }
      yield TipBlocStateLoaded(args.nextRoute, tips);
    } else if (event is TipBlocEventDone) {
      AppDB().setTipDone(args.tipID);
    }
  }
}
