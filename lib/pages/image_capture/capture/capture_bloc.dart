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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

abstract class CaptureBlocEvent extends Equatable {}

class CaptureBlocEventInit extends CaptureBlocEvent {
  @override
  List<Object> get props => [];
}

class CaptureBlocEventCreate extends CaptureBlocEvent {
  final String filePath;

  CaptureBlocEventCreate(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class CaptureBlocState extends Equatable {
  final bool videoEnabled;
  final bool pickerEnabled;
  final String overlayPath;

  CaptureBlocState(this.videoEnabled, this.pickerEnabled, this.overlayPath);

  @override
  List<Object> get props => [];
}

class CaptureBlocStateInit extends CaptureBlocState {
  CaptureBlocStateInit(bool videoEnabled, bool pickerEnabled, String overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);
}

class CaptureBlocStateDone extends CaptureBlocState {
  final FeedMediasCompanion feedMedia;

  CaptureBlocStateDone(this.feedMedia, bool videoEnabled, bool pickerEnabled, String overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);

  @override
  List<Object> get props => [feedMedia];
}

class CaptureBloc extends Bloc<CaptureBlocEvent, CaptureBlocState> {
  final MainNavigateToImageCaptureEvent _args;

  @override
  CaptureBlocState get initialState =>
      CaptureBlocState(_args.videoEnabled, _args.pickerEnabled, _args.overlayPath);

  CaptureBloc(this._args) {
    add(CaptureBlocEventInit());
  }

  @override
  Stream<CaptureBlocState> mapEventToState(CaptureBlocEvent event) async* {
    if (event is CaptureBlocEventInit) {
      yield CaptureBlocStateInit(_args.videoEnabled, _args.pickerEnabled, _args.overlayPath);
    } else if (event is CaptureBlocEventCreate) {
      String thumbnailPath = event.filePath;
      if (thumbnailPath.endsWith('mp4')) {
        thumbnailPath = thumbnailPath.replaceAll('.mp4', '.jpg');
        await VideoThumbnail.thumbnailFile(
          video: event.filePath,
          thumbnailPath: thumbnailPath,
          imageFormat: ImageFormat.JPEG,
          quality: 50,
        );
      }
      final feedMedia = FeedMediasCompanion(
        filePath: Value(event.filePath),
        thumbnailPath: Value(thumbnailPath),
      );
      yield CaptureBlocStateDone(
          feedMedia, _args.videoEnabled, _args.pickerEnabled, _args.overlayPath);
    }
  }
}
