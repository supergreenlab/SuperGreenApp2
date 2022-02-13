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
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FullscreenPictureBlocEvent extends Equatable {}

class FullscreenPictureBlocState extends Equatable {
  final int id;
  final Uint8List image;

  FullscreenPictureBlocState(this.id, this.image);

  @override
  List<Object> get props => [];
}

class FullscreenPictureBloc
    extends LegacyBloc<FullscreenPictureBlocEvent, FullscreenPictureBlocState> {
  final MainNavigateToFullscreenPicture args;

  FullscreenPictureBloc(this.args) : super(FullscreenPictureBlocState(args.id, args.image));

  @override
  Stream<FullscreenPictureBlocState> mapEventToState(
      FullscreenPictureBlocEvent event) async* {}
}
