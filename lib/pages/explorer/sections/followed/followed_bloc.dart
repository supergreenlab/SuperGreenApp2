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

abstract class FollowedBlocEvent extends Equatable {}

class FollowedBlocEventInit extends FollowedBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class FollowedBlocAction extends Equatable {}

class FollowedBlocActionInit extends FollowedBlocAction {
  @override
  List<Object> get props => [];
}

class FollowedBlocActionLoaded extends FollowedBlocAction {
  final List<>

  @override
  List<Object> get props => [];
}

class FollowedBloc extends Bloc<FollowedBlocEvent, FollowedBlocAction> {
  FollowedBloc() : super(FollowedBlocActionInit()) {
    add(FollowedBlocEventInit());
  }

  @override
  Stream<FollowedBlocAction> mapEventToState(FollowedBlocEvent event) async* {}
}
