import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class ImageCaptureBlocEvent extends Equatable {}

class ImageCaptureBlocEventLoadCameras extends ImageCaptureBlocEvent {
  ImageCaptureBlocEventLoadCameras();

  @override
  List<Object> get props => [];
}

class ImageCaptureBlocEventTakePicture extends ImageCaptureBlocEvent {
  ImageCaptureBlocEventTakePicture();

  @override
  List<Object> get props => [];
}

class ImageCaptureBlocEventStartVideoRecording extends ImageCaptureBlocEvent {
  ImageCaptureBlocEventStartVideoRecording();

  @override
  List<Object> get props => [];
}

class ImageCaptureBlocEventStopVideoRecording extends ImageCaptureBlocEvent {
  final String filePath;

  ImageCaptureBlocEventStopVideoRecording(this.filePath);

  @override
  List<Object> get props => [];
}

class ImageCaptureBlocEventCreate extends ImageCaptureBlocEvent {
  final String filePath;

  ImageCaptureBlocEventCreate(this.filePath);

  @override
  List<Object> get props => [filePath];
}

abstract class ImageCaptureBlocState extends Equatable {}

class ImageCaptureBlocStateIdle extends ImageCaptureBlocState {
  @override
  List<Object> get props => [];
}

class ImageCaptureBlocStateCameraMode extends ImageCaptureBlocState {
  final List<CameraDescription> cameras;
  final CameraController cameraController;

  ImageCaptureBlocStateCameraMode(this.cameras, this.cameraController);

  @override
  List<Object> get props => [cameras, cameraController];
}

class ImageCaptureBlocStateRecordMode
    extends ImageCaptureBlocStateCameraMode {
  final String filePath;

  ImageCaptureBlocStateRecordMode(
      List<CameraDescription> cameras, CameraController cameraController, this.filePath)
      : super(cameras, cameraController);
}

class ImageCaptureBlocStatePlaybackMode extends ImageCaptureBlocState {
  final String filePath;
  final ImageCaptureNextRouteEvent nextRoute;

  ImageCaptureBlocStatePlaybackMode(this.filePath, this.nextRoute);

  @override
  List<Object> get props => [];
}

class ImageCaptureBlocStateVideoPlaybackMode extends ImageCaptureBlocStatePlaybackMode {
  ImageCaptureBlocStateVideoPlaybackMode(String filePath, ImageCaptureNextRouteEvent nextRoute) : super(filePath, nextRoute);

  @override
  List<Object> get props => [];
}

class ImageCaptureBlocStatePicturePlaybackMode extends ImageCaptureBlocStatePlaybackMode {
  ImageCaptureBlocStatePicturePlaybackMode(String filePath, ImageCaptureNextRouteEvent nextRoute) : super(filePath, nextRoute);

  @override
  List<Object> get props => [];
}

class ImageCaptureBlocStateDone extends ImageCaptureBlocState {
  @override
  List<Object> get props => [];
}

class ImageCaptureBloc
    extends Bloc<ImageCaptureBlocEvent, ImageCaptureBlocState> {
  final MainNavigateToImageCaptureEvent _args;

  List<CameraDescription> _cameras;
  CameraController _cameraController;

  @override
  ImageCaptureBlocState get initialState => ImageCaptureBlocStateIdle();

  ImageCaptureBloc(this._args) {
    add(ImageCaptureBlocEventLoadCameras());
  }

  @override
  Stream<ImageCaptureBlocState> mapEventToState(
      ImageCaptureBlocEvent event) async* {
    if (event is ImageCaptureBlocEventLoadCameras) {
      _cameras = await availableCameras();
      _cameraController =
          CameraController(_cameras[0], ResolutionPreset.medium);
      await _cameraController.initialize();
      yield ImageCaptureBlocStateCameraMode(_cameras, _cameraController);
    } else if (event is ImageCaptureBlocEventStartVideoRecording) {
      String filePath = await _filePath('mp4');
      await _cameraController.startVideoRecording(filePath);
      yield ImageCaptureBlocStateRecordMode(_cameras, _cameraController, filePath);
    } else if (event is ImageCaptureBlocEventStopVideoRecording) {
      await _cameraController.stopVideoRecording();
      yield ImageCaptureBlocStateVideoPlaybackMode(event.filePath, _args.nextRoute);
    } else if (event is ImageCaptureBlocEventTakePicture) {
      String filePath = await _filePath('jpg');
      await _cameraController.takePicture(filePath);
      yield ImageCaptureBlocStatePicturePlaybackMode(filePath, _args.nextRoute);
    }
  }

  Future<String> _filePath(String ext) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/sgl';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.$ext';
    return filePath;
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}
