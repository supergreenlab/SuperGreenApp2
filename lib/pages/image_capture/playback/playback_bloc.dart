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
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class PlaybackBlocEvent extends Equatable {}

class CaptureBlocEventInit extends PlaybackBlocEvent {
  @override
  List<Object> get props => [];
}

class PlaybackBlocState extends Equatable {
  final bool isVideo;
  final String filePath;
  final String? overlayPath;

  final String cancelButton;
  final String okButton;

  PlaybackBlocState(this.filePath, this.isVideo, this.cancelButton, this.okButton, this.overlayPath);
  @override
  List<Object?> get props => [filePath, overlayPath, isVideo];
}

class PlaybackBlocStateInit extends PlaybackBlocState {
  PlaybackBlocStateInit(String filePath, bool isVideo, String cancelButton, String okButton, String? overlayPath)
      : super(filePath, isVideo, cancelButton, okButton, overlayPath);
}

class PlaybackBloc extends Bloc<PlaybackBlocEvent, PlaybackBlocState> {
  final MainNavigateToImageCapturePlaybackEvent _args;

  static bool _isVideo(String filePath) => filePath.endsWith('mp4');

  PlaybackBloc(this._args)
      : super(PlaybackBlocState(_args.filePath, PlaybackBloc._isVideo(_args.filePath), _args.cancelButton,
            _args.okButton, _args.overlayPath)) {
    add(CaptureBlocEventInit());
  }

  @override
  Stream<PlaybackBlocState> mapEventToState(PlaybackBlocEvent event) async* {
    if (event is CaptureBlocEventInit) {
      yield PlaybackBlocStateInit(
          _args.filePath, PlaybackBloc._isVideo(_args.filePath), _args.cancelButton, _args.okButton, _args.overlayPath);
    }
  }
}
