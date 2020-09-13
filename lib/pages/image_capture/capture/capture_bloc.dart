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
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image/image.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
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

  CaptureBlocEventCreate({this.files});

  @override
  List<Object> get props => [files];
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
  CaptureBlocStateInit(
      bool videoEnabled, bool pickerEnabled, String overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);
}

class CaptureBlocStateLoading extends CaptureBlocState {
  final String title;
  final double progress;

  CaptureBlocStateLoading(this.title, this.progress, bool videoEnabled,
      bool pickerEnabled, String overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);

  @override
  List<Object> get props => [...super.props, title, progress];
}

class CaptureBlocStateDone extends CaptureBlocState {
  final List<FeedMediasCompanion> feedMedias;

  CaptureBlocStateDone(this.feedMedias, bool videoEnabled, bool pickerEnabled,
      String overlayPath)
      : super(videoEnabled, pickerEnabled, overlayPath);

  @override
  List<Object> get props => [...super.props, feedMedias];
}

class CaptureBloc extends Bloc<CaptureBlocEvent, CaptureBlocState> {
  final MainNavigateToImageCaptureEvent args;

  CaptureBloc(this.args)
      : super(CaptureBlocState(
            args.videoEnabled, args.pickerEnabled, args.overlayPath)) {
    add(CaptureBlocEventInit());
  }

  @override
  Stream<CaptureBlocState> mapEventToState(CaptureBlocEvent event) async* {
    if (event is CaptureBlocEventInit) {
      yield CaptureBlocStateInit(
          args.videoEnabled, args.pickerEnabled, args.overlayPath);
    } else if (event is CaptureBlocEventCreate) {
      List<File> files = event.files;
      List<FeedMediasCompanion> feedMedias = [];
      int i = 1;
      for (File file in files) {
        String ext = file.path.split('.').last.toLowerCase();
        String fileName = '${FeedMedias.makeFilePath()}-${i++}';
        String filePath = '$fileName.$ext';
        yield CaptureBlocStateLoading('Copying files..', (i - 2) / files.length,
            args.videoEnabled, args.pickerEnabled, args.overlayPath);
        if (ext == 'mov') {
          yield CaptureBlocStateLoading(
              'Converting mov to mp4..',
              (i - 2) / files.length,
              args.videoEnabled,
              args.pickerEnabled,
              args.overlayPath);
          filePath = '$fileName.mp4';
          // Should do the trick in most cases, using ffmpeg takes way too long..
          await file.copy(FeedMedias.makeAbsoluteFilePath(filePath));
          //await flutterFFmpeg.execute(
          //    "-i ${file.path} -c:v mpeg4 ${FeedMedias.makeAbsoluteFilePath(filePath)}");
          yield CaptureBlocStateLoading(
              'Copying files..',
              (i - 2) / files.length,
              args.videoEnabled,
              args.pickerEnabled,
              args.overlayPath);
        } else if (ext == 'heic') {
          yield CaptureBlocStateLoading(
              'Converting heic to jpg..',
              (i - 2) / files.length,
              args.videoEnabled,
              args.pickerEnabled,
              args.overlayPath);
          String jpegPath = await HeicToJpg.convert(file.path);
          yield CaptureBlocStateLoading(
              'Copying files..',
              (i - 2) / files.length,
              args.videoEnabled,
              args.pickerEnabled,
              args.overlayPath);
          filePath = '$fileName.jpg';
          await File(jpegPath).copy(FeedMedias.makeAbsoluteFilePath(filePath));
        } else if (ext == 'png') {
          yield CaptureBlocStateLoading(
              'Converting png to jpg..',
              (i - 2) / files.length,
              args.videoEnabled,
              args.pickerEnabled,
              args.overlayPath);
          Image image = decodeImage(await File(filePath).readAsBytes());
          filePath = '$fileName.jpg';
          await File(FeedMedias.makeAbsoluteFilePath(filePath))
              .writeAsBytes(encodeJpg(image));
          yield CaptureBlocStateLoading(
              'Copying files..',
              (i - 2) / files.length,
              args.videoEnabled,
              args.pickerEnabled,
              args.overlayPath);
        } else {
          await file.copy(FeedMedias.makeAbsoluteFilePath(filePath));
        }
        String fileBaseName = basename(fileName);
        String thumbnailPath =
            filePath.replaceFirst(fileBaseName, 'thumbnail_$fileBaseName');
        if (thumbnailPath.endsWith('mp4')) {
          thumbnailPath = thumbnailPath.replaceFirst('.mp4', '.jpg');
          await VideoThumbnail.thumbnailFile(
            video: FeedMedias.makeAbsoluteFilePath(filePath),
            thumbnailPath: FeedMedias.makeAbsoluteFilePath(thumbnailPath),
            imageFormat: ImageFormat.JPEG,
            quality: 50,
          );
          await optimizePicture(thumbnailPath, thumbnailPath);
        } else {
          //Image image = bakeOrientation(decodeImage(await File(FeedMedias.makeAbsoluteFilePath(filePath)).readAsBytes()));
          //print('bakedImage.exif.orientation:\n${image.exif.orientation} ${image.width} ${image.height}');
          //await File(FeedMedias.makeAbsoluteFilePath(filePath)).writeAsBytes(encodeJpg(image));
          await optimizePicture(filePath, thumbnailPath);
        }
        feedMedias.add(FeedMediasCompanion(
          filePath: Value(filePath),
          thumbnailPath: Value(thumbnailPath),
        ));
      }
      yield CaptureBlocStateDone(
          feedMedias, args.videoEnabled, args.pickerEnabled, args.overlayPath);
    }
  }

  Future optimizePicture(String from, String to) async {
    Image image = decodeImage(
        await File(FeedMedias.makeAbsoluteFilePath(from)).readAsBytes());
    Image thumbnail = copyResize(image,
        height: image.height > image.width ? 800 : null,
        width: image.width >= image.height ? 800 : null);
    print(
        'image.exif.orientation:\n${image.exif.orientation} ${image.width} ${image.height}');
    print(
        'thumbnail.exif.orientation:\n${thumbnail.exif.orientation} ${thumbnail.width} ${thumbnail.height}');
    await File(FeedMedias.makeAbsoluteFilePath(to))
        .writeAsBytes(encodeJpg(thumbnail, quality: 50));
  }
}
