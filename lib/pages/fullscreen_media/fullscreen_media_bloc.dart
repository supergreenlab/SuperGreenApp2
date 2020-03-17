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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FullscreenMediaBlocEvent extends Equatable {}

class FullscreenMediaBlocEventInit extends FullscreenMediaBlocEvent {
  @override
  List<Object> get props => [];
}

class FullscreenMediaBlocState extends Equatable {
  final bool isVideo;
  final FeedMedia feedMedia;
  final String overlayPath;

  FullscreenMediaBlocState(this.feedMedia, this.isVideo, this.overlayPath);

  @override
  List<Object> get props => [feedMedia, isVideo];
}

class FullscreenMediaBlocStateInit extends FullscreenMediaBlocState {
  FullscreenMediaBlocStateInit(FeedMedia feedMedia, bool isVideo, String overlayPath)
      : super(feedMedia, isVideo, overlayPath);
}

class FullscreenMediaBloc
    extends Bloc<FullscreenMediaBlocEvent, FullscreenMediaBlocState> {
  final MainNavigateToFullscreenMedia _args;

  get _isVideo => _args.feedMedia.filePath.endsWith('mp4');

  FullscreenMediaBloc(this._args) {
    Timer(Duration(seconds: 1), () => add(FullscreenMediaBlocEventInit()));
  }

  @override
  FullscreenMediaBlocState get initialState =>
      FullscreenMediaBlocState(_args.feedMedia, _isVideo, _args.overlayPath);

  @override
  Stream<FullscreenMediaBlocState> mapEventToState(
      FullscreenMediaBlocEvent event) async* {
    if (event is FullscreenMediaBlocEventInit) {
      yield FullscreenMediaBlocStateInit(_args.feedMedia, _isVideo, _args.overlayPath);
    }
  }
}
