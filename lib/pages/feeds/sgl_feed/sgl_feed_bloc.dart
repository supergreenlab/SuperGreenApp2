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

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SGLFeedBlocEvent extends Equatable {}

abstract class SGLFeedBlocState extends Equatable {}

class SGLFeedBlocStateInit extends SGLFeedBlocState {
  SGLFeedBlocStateInit() : super();

  @override
  List<Object> get props => [];
}

class SGLFeedBloc
    extends LegacyBloc<SGLFeedBlocEvent, SGLFeedBlocState> {

  SGLFeedBloc() : super(SGLFeedBlocStateInit());

  @override
  Stream<SGLFeedBlocState> mapEventToState(
      SGLFeedBlocEvent event) async* {}
}
