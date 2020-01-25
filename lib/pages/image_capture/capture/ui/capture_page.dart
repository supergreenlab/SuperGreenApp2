import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/image_capture/capture/bloc/capture_bloc.dart';

class CapturePage extends StatefulWidget {
  @override
  _CapturePageState createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  String _filePath;
  CameraController _cameraController;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<CaptureBloc>(context),
      listener: (BuildContext context, CaptureBlocState state) async {
        if (state is CaptureBlocStateInit) {
          if (_cameraController == null) {
            _filePath = await _makeFilePath();
            List<CameraDescription> cameras = await availableCameras();
            _cameraController =
                CameraController(cameras[0], ResolutionPreset.medium);
            await _cameraController.initialize();
            setState(() {});
          }
        }
      },
      child: BlocBuilder<CaptureBloc, CaptureBlocState>(
          bloc: Provider.of<CaptureBloc>(context),
          builder: (context, state) {
            if (_cameraController != null &&
                _cameraController.value.isInitialized) {
              if (_cameraController.value.isRecordingVideo) {
                return _renderCameraRecording(context, state);
              } else {
                return _renderCamera(context, state);
              }
            }
            return _renderLoading(context, state);
          }),
    );
  }

  Widget _renderCamera(BuildContext context, CaptureBlocState state) {
    return WillPopScope(
      onWillPop: () async {
        await _deleteFileIfExists('$_filePath.mp4');
        await _deleteFileIfExists('$_filePath.jpg');
        return true;
      },
      child: Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: CameraPreview(_cameraController)),
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
                  children: _renderIdleCameraMode(context, state),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderCameraRecording(BuildContext context, CaptureBlocState state) {
    return WillPopScope(
      onWillPop: () async {
        _cameraController.stopVideoRecording();
        setState(() {});
        return false;
      },
      child: Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: CameraPreview(_cameraController)),
            );
          }),
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
                  children: _renderRecordingMode(context, state),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderLoading(BuildContext context, CaptureBlocState state) {
    return Container();
  }

  Widget _renderCloseButton(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        _deleteFileIfExists('$_filePath.mp4');
        _deleteFileIfExists('$_filePath.jpg');
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

  Widget _renderMuteButton(BuildContext context, CaptureBlocState state) {
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

  List<Widget> _renderIdleCameraMode(
      BuildContext context, CaptureBlocState state) {
    return <Widget>[
      Container(),
      _renderPictureButton(context, state),
      _renderCameraButton(context, state),
      Container(),
    ];
  }

  List<Widget> _renderRecordingMode(
      BuildContext context, CaptureBlocState state) {
    return <Widget>[
      _renderStopButton(context, state),
    ];
  }

  Widget _renderPictureButton(BuildContext context, CaptureBlocState state) {
    return _renderBottomButton(context, Icons.photo_camera, Colors.blue,
        () async {
      final String filePath = '$_filePath.jpg';
      await _deleteFileIfExists(filePath);
      _cameraController.takePicture(filePath);
      endCapture(state, filePath);
    });
  }

  Widget _renderCameraButton(BuildContext context, CaptureBlocState state) {
    return _renderBottomButton(context, Icons.videocam, Colors.blue, () async {
      final String filePath = '$_filePath.mp4';
      await _deleteFileIfExists(filePath);
      await _cameraController.startVideoRecording(filePath);
      setState(() {});
    });
  }

  Widget _renderStopButton(BuildContext context, CaptureBlocState state) {
    return _renderBottomButton(context, Icons.stop, Colors.red, () async {
      await _cameraController.stopVideoRecording();
      endCapture(state, '$_filePath.mp4');
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

  void endCapture(CaptureBlocState state, String filePath) {
    BlocProvider.of<MainNavigatorBloc>(context).add(
        MainNavigateToImageCapturePlaybackEvent(filePath, futureFn: (f) async {
      final dynamic ret = await f;
      if (ret == null || ret == false) {
        return;
      }
      if (state.nextRoute != null) {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(state.nextRoute.copyWith(filePath) as MainNavigatorEvent);
      } else {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(MainNavigatorActionPop(param: filePath));
      }
    }));
  }

  Future _deleteFileIfExists(String filePath) async {
    final File file = File(filePath);
    try {
      await file.delete();
    } catch (e) {}
  }

  Future<String> _makeFilePath() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/sgl';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}';
    return filePath;
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController.dispose();
    }
    super.dispose();
  }
}
