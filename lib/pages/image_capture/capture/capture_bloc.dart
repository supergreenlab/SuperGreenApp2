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
  CaptureBlocState();

  @override
  List<Object> get props => [];
}

class CaptureBlocStateInit extends CaptureBlocState {
  CaptureBlocStateInit();
}

class CaptureBlocStateDone extends CaptureBlocState {
  final FeedMediasCompanion feedMedia;

  CaptureBlocStateDone(this.feedMedia);

  @override
  List<Object> get props => [feedMedia];
}

class CaptureBloc extends Bloc<CaptureBlocEvent, CaptureBlocState> {
  final MainNavigateToImageCaptureEvent _args;

  @override
  CaptureBlocState get initialState => CaptureBlocState();

  CaptureBloc(this._args) {
    add(CaptureBlocEventInit());
  }

  @override
  Stream<CaptureBlocState> mapEventToState(CaptureBlocEvent event) async* {
    if (event is CaptureBlocEventInit) {
      yield CaptureBlocStateInit();
    } else if (event is CaptureBlocEventCreate) {
      String thumbnailPath = event.filePath;
      if (thumbnailPath.endsWith('mp4')) {
        thumbnailPath = thumbnailPath.replaceAll('.mp4', '.jpg');
        await VideoThumbnail.thumbnailFile(
          video: event.filePath,
          thumbnailPath: thumbnailPath,
          imageFormat: ImageFormat.JPEG,
          maxHeight:
              200, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          quality: 75,
        );
      }
      final feedMedia = FeedMediasCompanion(
        filePath: Value(event.filePath),
        thumbnailPath: Value(thumbnailPath),
      );
      yield CaptureBlocStateDone(feedMedia);
    }
  }
}
