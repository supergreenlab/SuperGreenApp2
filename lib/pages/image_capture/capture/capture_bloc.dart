/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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
import 'dart:io';

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image/image.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

abstract class CaptureBlocEvent extends Equatable {}

class CaptureBlocEventInit extends CaptureBlocEvent {
  @override
  List<Object> get props => [];
}

class CaptureBlocEventCreate extends CaptureBlocEvent {
  final List<File> files;

  CaptureBlocEventCreate({required this.files});

  @override
  List<Object> get props => [files];
}

class CaptureBlocState extends Equatable {
  final bool videoEnabled;
  final bool pickerEnabled;
  final String? overlayPath;

  CaptureBlocState(this.videoEnabled, this.pickerEnabled, this.overlayPath);

  @override
  List<Object?> get props => [videoEnabled, pickerEnabled, overlayPath];
}

class CaptureBlocStateInit extends CaptureBlocState {
  CaptureBlocStateInit(bool videoEnabled, bool pickerEnabled, String? overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);
}

class CaptureBlocStateLoading extends CaptureBlocState {
  final String title;
  final double progress;

  CaptureBlocStateLoading(this.title, this.progress, bool videoEnabled, bool pickerEnabled, String? overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);

  @override
  List<Object?> get props => [...super.props, title, progress];
}

class CaptureBlocStateDone extends CaptureBlocState {
  final List<FeedMediasCompanion> feedMedias;

  CaptureBlocStateDone(this.feedMedias, bool videoEnabled, bool pickerEnabled, String? overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);

  @override
  List<Object?> get props => [...super.props, feedMedias];
}

class CaptureBloc extends LegacyBloc<CaptureBlocEvent, CaptureBlocState> {
  final MainNavigateToImageCaptureEvent args;

  CaptureBloc(this.args) : super(CaptureBlocState(args.videoEnabled, args.pickerEnabled, args.overlayPath)) {
    add(CaptureBlocEventInit());
  }

  @override
  Stream<CaptureBlocState> mapEventToState(CaptureBlocEvent event) async* {
    if (event is CaptureBlocEventInit) {
      yield CaptureBlocStateInit(args.videoEnabled, args.pickerEnabled, args.overlayPath);
    } else if (event is CaptureBlocEventCreate) {
      yield loadingEvent('Copying files..', 0);
      await Future.delayed(Duration(milliseconds: 500)); // Adding a small delay for
      List<File> files = event.files;
      List<FeedMediasCompanion> feedMedias = [];
      for (File file in files) {
        int i = files.indexOf(file);
        try {
          String ext = file.path.split('.').last.toLowerCase();
          String fileName = '${FeedMedias.makeFilePath()}-${i + 1}';
          String filePath = '$fileName.$ext';
          String thumbnailPath;
          String fileBaseName = basename(fileName);
          yield loadingEvent('Copying files ${i + 1}/${files.length}', (i) / (files.length));
          if (ext == 'mov' || ext == 'mp4') {
            if (ext == 'mov') {
              yield loadingEvent('Converting mov to mp4 ${i + 1}/${files.length}', (i + 0.25) / (files.length));
              filePath = '$fileName.mp4';
              // Should do the trick in most cases, using ffmpeg takes way too long..
            }
            await file.copy(FeedMedias.makeAbsoluteFilePath(filePath));
            yield loadingEvent('Optimizing pic ${i + 1}/${files.length}', (i + 0.75) / (files.length));
            thumbnailPath = filePath.replaceFirst(fileBaseName, 'thumbnail_$fileBaseName');
            thumbnailPath = thumbnailPath.replaceFirst('.mp4', '.jpg');
            await VideoThumbnail.thumbnailFile(
              video: FeedMedias.makeAbsoluteFilePath(filePath),
              thumbnailPath: FeedMedias.makeAbsoluteFilePath(thumbnailPath),
              imageFormat: ImageFormat.JPEG,
              quality: 50,
            );
            await optimizePicture(thumbnailPath, thumbnailPath);
          } else if (ext == 'heic') {
            yield loadingEvent('Converting heic to jpg ${i + 1}/${files.length}', (i + 0.5) / (files.length));
            String? jpegPath = await HeicToJpg.convert(file.path);
            yield loadingEvent('Optimizing pic ${i + 1}/${files.length}', (i + 0.75) / (files.length));
            filePath = '$fileName.jpg';
            await File(jpegPath).copy(FeedMedias.makeAbsoluteFilePath(filePath));
            thumbnailPath = filePath.replaceFirst(fileBaseName, 'thumbnail_$fileBaseName');
            await optimizePicture(filePath, thumbnailPath);
          } else if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
            Image? image = decodeImage(await file.readAsBytes());
            if (ext == 'png') {
              yield loadingEvent('Converting png to jpg ${i + 1}/${files.length}', (i + 0.25) / (files.length));
              filePath = '$fileName.jpg';
            }
            await File(FeedMedias.makeAbsoluteFilePath(filePath)).writeAsBytes(encodeJpg(image!), flush: true);
            yield loadingEvent('Optimizing pic ${i + 1}/${files.length}', (i + 0.75) / (files.length));
            thumbnailPath = filePath.replaceFirst(fileBaseName, 'thumbnail_$fileBaseName');
            await optimizePictureFromImage(image, thumbnailPath);
          } else {
            throw 'Unknown file type $ext';
          }
          feedMedias.add(FeedMediasCompanion(
            filePath: Value(filePath),
            thumbnailPath: Value(thumbnailPath),
          ));
        } catch (e, stack) {
          Logger.logError(e, stack, data: {"file": file});
        }
      }
      yield CaptureBlocStateDone(feedMedias, args.videoEnabled, args.pickerEnabled, args.overlayPath);
    }
  }

  Future optimizePicture(String from, String to) async {
    Image? image = decodeImage(await File(FeedMedias.makeAbsoluteFilePath(from)).readAsBytes());
    await optimizePictureFromImage(image!, to);
  }

  Future optimizePictureFromImage(Image image, String to) async {
    Image thumbnail = copyResize(image,
        height: image.height > image.width ? 800 : null, width: image.width >= image.height ? 800 : null);
    await File(FeedMedias.makeAbsoluteFilePath(to)).writeAsBytes(encodeJpg(thumbnail, quality: 50), flush: true);
  }

  CaptureBlocStateLoading loadingEvent(String title, double progress) =>
      CaptureBlocStateLoading(title, progress, args.videoEnabled, args.pickerEnabled, args.overlayPath);
}
