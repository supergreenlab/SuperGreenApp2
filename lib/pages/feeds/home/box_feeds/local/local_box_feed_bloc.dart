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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

abstract class LocalBoxFeedBlocEvent extends Equatable {}

abstract class LocalBoxFeedBlocState extends Equatable {}

class LocalBoxFeedBlocStateInit extends LocalBoxFeedBlocState {
  @override
  List<Object> get props => [];
}

class LocalBoxFeedBlocStateLoaded extends LocalBoxFeedBlocState {
  final Box box;

  LocalBoxFeedBlocStateLoaded(this.box);

  @override
  List<Object> get props => [box];
}

class LocalBoxFeedBlocStateBoxRemoved extends LocalBoxFeedBlocState {
  LocalBoxFeedBlocStateBoxRemoved();

  @override
  List<Object> get props => [];
}

class LocalBoxFeedBloc
    extends Bloc<LocalBoxFeedBlocEvent, LocalBoxFeedBlocState> {
  HomeNavigateToBoxFeedEvent args;

  LocalBoxFeedBloc(this.args) : super(LocalBoxFeedBlocStateInit());

  @override
  Stream<LocalBoxFeedBlocState> mapEventToState(
      LocalBoxFeedBlocEvent event) async* {}
}
