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
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FullscreenMediaBlocEvent extends Equatable {}

class FullscreenMediaBlocEventInit extends FullscreenMediaBlocEvent {
  @override
  List<Object> get props => [];
}

class FullscreenMediaBlocState extends Equatable {
  final bool isVideo;
  final String thumbnailPath;
  final String filePath;
  final String overlayPath;
  final String heroPath;
  final String sliderTitle;

  FullscreenMediaBlocState(this.thumbnailPath, this.filePath, this.isVideo,
      this.overlayPath, this.heroPath, this.sliderTitle);

  @override
  List<Object> get props => [thumbnailPath, filePath, isVideo];
}

class FullscreenMediaBlocStateInit extends FullscreenMediaBlocState {
  FullscreenMediaBlocStateInit(String thumbnailPath, String filePath,
      bool isVideo, String overlayPath, String heroPath, String sliderTitle)
      : super(thumbnailPath, filePath, isVideo, overlayPath, heroPath, sliderTitle);
}

class FullscreenMediaBloc
    extends Bloc<FullscreenMediaBlocEvent, FullscreenMediaBlocState> {
  final MainNavigateToFullscreenMedia args;

  get _isVideo {
    if (args.filePath.startsWith('http')) {
      String path = Uri.parse(args.filePath).path;
      return path.endsWith('mp4');
    } else {
      return args.filePath.endsWith('mp4');
    }
  }

  FullscreenMediaBloc(this.args) {
    add(FullscreenMediaBlocEventInit());
  }

  @override
  FullscreenMediaBlocState get initialState => FullscreenMediaBlocState(
      args.thumbnailPath,
      args.filePath,
      _isVideo,
      args.overlayPath,
      args.heroPath,
      args.sliderTitle);

  @override
  Stream<FullscreenMediaBlocState> mapEventToState(
      FullscreenMediaBlocEvent event) async* {
    if (event is FullscreenMediaBlocEventInit) {
      yield FullscreenMediaBlocStateInit(args.thumbnailPath, args.filePath,
          _isVideo, args.overlayPath, args.heroPath, args.sliderTitle);
    }
  }
}
