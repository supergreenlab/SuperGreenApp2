import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/image_capture/bloc/image_capture_bloc.dart';
import 'package:video_player/video_player.dart';

class ImageCapturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<ImageCaptureBloc>(context)
            .add(ImageCaptureBlocEventCancelPreview());
        BlocProvider.of<ImageCaptureBloc>(context)
            .add(ImageCaptureBlocEventDispose());
        return true;
      },
      child: BlocListener(
        bloc: Provider.of<ImageCaptureBloc>(context),
        listener: (BuildContext context, ImageCaptureBlocState state) {
          if (state is ImageCaptureBlocStateCameraMode) {
          } else if (state is ImageCaptureBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          }
        },
        child: BlocBuilder<ImageCaptureBloc, ImageCaptureBlocState>(
            bloc: Provider.of<ImageCaptureBloc>(context),
            builder: (context, state) {
              if (state is ImageCaptureBlocStateCameraMode) {
                return _renderCamera(context, state);
              } else if (state is ImageCaptureBlocStateVideoPlaybackMode) {
                return _renderVideoPlayer(context, state);
              } else if (state is ImageCaptureBlocStatePicturePlaybackMode) {
                return _renderPicturePlayer(context, state);
              }
              return _renderLoading(context, state);
            }),
      ),
    );
  }

  Widget _renderCamera(
      BuildContext context, ImageCaptureBlocStateCameraMode state) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: CameraPreview(state.cameraController)),
          );
        }),
        Positioned(
          top: 25,
          left: 0,
          child: SizedBox(
            width: 35,
            height: 35,
            child: _renderCloseButton(context),
          ),
        ),
        Positioned(
          top: 25,
          right: 0,
          child: SizedBox(
            width: 35,
            height: 35,
            child: _renderMuteButton(context, state),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: state is ImageCaptureBlocStateRecordMode
                    ? _renderRecordingMode(context, state)
                    : _renderIdleCameraMode(context),
              )),
            ),
          ),
        )
      ],
    );
  }

  Widget _renderLoading(BuildContext context, ImageCaptureBlocState state) {
    return Container();
  }

  Widget _renderVideoPlayer(
      BuildContext context, ImageCaptureBlocStateVideoPlaybackMode state) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: VideoPlayer(state.videoPlayerController)),
          );
        }),
        Positioned(
          top: 25,
          left: 0,
          child: SizedBox(
            width: 35,
            height: 35,
            child: _renderCloseButton(context),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _renderPreviewMode(context, state),
              )),
            ),
          ),
        )
      ],
    );
  }

  Widget _renderPicturePlayer(
      BuildContext context, ImageCaptureBlocStatePicturePlaybackMode state) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image.file(File(state.filePath))),
          );
        }),
        Positioned(
          top: 25,
          left: 0,
          child: SizedBox(
            width: 35,
            height: 35,
            child: _renderCloseButton(context),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _renderPreviewMode(context, state),
              )),
            ),
          ),
        )
      ],
    );
  }

  Widget _renderCloseButton(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(MainNavigatorActionPop());
      },
      shape: new CircleBorder(),
      child: new Icon(
        Icons.close,
        color: Colors.white,
        size: 35.0,
      ),
    );
  }

  Widget _renderMuteButton(
      BuildContext context, ImageCaptureBlocStateCameraMode state) {
    return RawMaterialButton(
      onPressed: () {},
      shape: new CircleBorder(),
      child: new Icon(
        Icons.volume_mute,
        color: Colors.white,
        size: 35.0,
      ),
    );
  }

  List<Widget> _renderIdleCameraMode(BuildContext context) {
    return <Widget>[
      Container(),
      _renderPictureButton(context),
      _renderCameraButton(context),
      Container(),
    ];
  }

  List<Widget> _renderRecordingMode(
      BuildContext context, ImageCaptureBlocStateRecordMode state) {
    return <Widget>[
      _renderStopButton(context, state),
    ];
  }

  List<Widget> _renderPreviewMode(
      BuildContext context, ImageCaptureBlocStatePlaybackMode state) {
    return [
      RawMaterialButton(
        child:
            Text('RETAKE', style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          BlocProvider.of<ImageCaptureBloc>(context)
              .add(ImageCaptureBlocEventCancelPreview());
        },
      ),
      RawMaterialButton(
        child:
            Text('NEXT', style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          _onCaptureDone(context, state);
        },
      ),
    ];
  }

  Widget _renderPictureButton(BuildContext context) {
    return _renderBottomButton(context, Icons.photo_camera, Colors.blue,
        () async {
      BlocProvider.of<ImageCaptureBloc>(context)
          .add(ImageCaptureBlocEventTakePicture());
    });
  }

  Widget _renderCameraButton(BuildContext context) {
    return _renderBottomButton(context, Icons.videocam, Colors.blue, () async {
      BlocProvider.of<ImageCaptureBloc>(context)
          .add(ImageCaptureBlocEventStartVideoRecording());
    });
  }

  Widget _renderStopButton(
      BuildContext context, ImageCaptureBlocStateRecordMode state) {
    return _renderBottomButton(context, Icons.stop, Colors.red, () async {
      BlocProvider.of<ImageCaptureBloc>(context)
          .add(ImageCaptureBlocEventStopVideoRecording(state.filePath));
    });
  }

  Widget _renderBottomButton(
      BuildContext context, IconData icon, Color color, Function onPressed) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: new Icon(
        icon,
        color: color,
        size: 35.0,
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
    );
  }

  void _onCaptureDone(
      BuildContext context, ImageCaptureBlocStatePlaybackMode state) {
    if (state.nextRoute != null) {
      BlocProvider.of<MainNavigatorBloc>(context)
          .add(state.nextRoute.copyWith(state.filePath) as MainNavigatorEvent);
    } else {
      BlocProvider.of<MainNavigatorBloc>(context)
          .add(MainNavigatorActionPop(param: state.filePath));
    }
  }
}
