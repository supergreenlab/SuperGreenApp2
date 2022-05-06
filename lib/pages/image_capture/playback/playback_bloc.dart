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

import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:image/image.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class PlaybackBlocEvent extends Equatable {}

class PlaybackBlocEventInit extends PlaybackBlocEvent {
  @override
  List<Object> get props => [];
}

class PlaybackBlocEventRotate extends PlaybackBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  @override
  List<Object> get props => [rand];
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

class PlaybackBlocStateReload extends PlaybackBlocState {
  final int rand = Random().nextInt(1 << 32);

  PlaybackBlocStateReload(String filePath, bool isVideo, String cancelButton, String okButton, String? overlayPath)
      : super(filePath, isVideo, cancelButton, okButton, overlayPath);
  @override
  List<Object?> get props => [...super.props, rand];
}

class PlaybackBloc extends LegacyBloc<PlaybackBlocEvent, PlaybackBlocState> {
  final MainNavigateToImageCapturePlaybackEvent _args;

  static bool _isVideo(String filePath) => filePath.endsWith('mp4');

  PlaybackBloc(this._args)
      : super(PlaybackBlocState(_args.filePath, PlaybackBloc._isVideo(_args.filePath), _args.cancelButton,
            _args.okButton, _args.overlayPath)) {
    add(PlaybackBlocEventInit());
  }

  @override
  Stream<PlaybackBlocState> mapEventToState(PlaybackBlocEvent event) async* {
    if (event is PlaybackBlocEventInit) {
      yield PlaybackBlocStateInit(
          _args.filePath, PlaybackBloc._isVideo(_args.filePath), _args.cancelButton, _args.okButton, _args.overlayPath);
    } else if (event is PlaybackBlocEventRotate) {
      try {
        Image? image = decodeImage(await new File(FeedMedias.makeAbsoluteFilePath(_args.filePath)).readAsBytes());
        image = copyRotate(image!, 90);
        List<int>? out = encodeNamedImage(image, _args.filePath);
        await File(FeedMedias.makeAbsoluteFilePath(_args.filePath)).writeAsBytes(out!, flush: true);
      } catch (e, trace) {
        Logger.logError(e, trace);
      }
      yield PlaybackBlocStateReload(
          _args.filePath, PlaybackBloc._isVideo(_args.filePath), _args.cancelButton, _args.okButton, _args.overlayPath);
    }
  }
}
