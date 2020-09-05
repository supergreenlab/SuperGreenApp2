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

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/image_capture/capture/capture_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class CapturePage extends StatefulWidget {
  @override
  _CapturePageState createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  bool _enableAudio = false;
  String _filePath;
  List<CameraDescription> _cameras;
  CameraController _cameraController;

  bool _videoMode = false;
  bool _popDone = true;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<CaptureBloc>(context),
      listener: (BuildContext context, CaptureBlocState state) async {
        if (state is CaptureBlocStateInit) {
          if (_cameraController == null) {
            _cameras = await availableCameras();
            _setupCamera();
          }
        } else if (state is CaptureBlocStateDone) {
          _popDone = true;
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: state.feedMedias));
        }
      },
      child: BlocBuilder<CaptureBloc, CaptureBlocState>(
          cubit: BlocProvider.of<CaptureBloc>(context),
          builder: (context, state) {
            if (_cameraController != null &&
                _cameraController.value.isInitialized == true) {
              if (_loading) {
                return Scaffold(
                    body: FullscreenLoading(title: 'Copying medias..'));
              }
              if (_cameraController.value.isRecordingVideo == true) {
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
    return GestureDetector(
      onPanEnd: (DragEndDetails details) {
        setState(() {
          _videoMode = !_videoMode;
        });
      },
      child: WillPopScope(
        onWillPop: () async {
          if (_filePath != null) {
            await _deleteFileIfExists(
                FeedMedias.makeAbsoluteFilePath(_filePath));
          }
          return true;
        },
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              double width = constraints.maxWidth;
              double height =
                  constraints.maxWidth / _cameraController.value.aspectRatio;
              Widget cameraPreview = Positioned(
                  left: (constraints.maxWidth - width) / 2,
                  top: (constraints.maxHeight - height) / 2,
                  child: SizedBox(
                      width: width,
                      height: height,
                      child: CameraPreview(_cameraController)));
              if (state.overlayPath != null) {
                Widget overlay = SizedBox(
                    width: width,
                    height: height,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Opacity(
                            opacity: 0.6,
                            child: Image.file(File(
                                FeedMedias.makeAbsoluteFilePath(
                                    state.overlayPath))))));
                cameraPreview = Stack(children: [
                  cameraPreview,
                  overlay,
                ]);
              } else {
                cameraPreview = Stack(children: [
                  cameraPreview,
                ]);
              }
              return cameraPreview;
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
              height: 100,
              child: Container(
                color: Colors.black26,
                child: _renderIdleCameraMode(context, state),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderCameraRecording(BuildContext context, CaptureBlocState state) {
    return WillPopScope(
      onWillPop: () async {
        if (_cameraController.value.isRecordingVideo) {
          await _cameraController.stopVideoRecording();
          setState(() {});
        }
        return _popDone;
      },
      child: Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            double width =
                constraints.maxHeight * _cameraController.value.aspectRatio;
            double height = constraints.maxHeight;
            return Stack(children: [
              Positioned(
                  left: (constraints.maxWidth - width) / 2,
                  top: (constraints.maxHeight - height) / 2,
                  child: SizedBox(
                      width: width,
                      height: height,
                      child: CameraPreview(_cameraController))),
            ]);
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
    return Scaffold(body: FullscreenLoading());
  }

  Widget _renderCloseButton(BuildContext context) {
    return RawMaterialButton(
      onPressed: () async {
        if (_filePath != null) {
          await _deleteFileIfExists(FeedMedias.makeAbsoluteFilePath(_filePath));
        }
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
    if (_videoMode) {
      return RawMaterialButton(
        onPressed: () {
          _enableAudio = !_enableAudio;
          _setupCamera();
        },
        shape: new CircleBorder(),
        child: new Icon(
          _enableAudio ? Icons.volume_up : Icons.volume_off,
          color: Colors.white,
          size: 35.0,
        ),
      );
    }
    return Container();
  }

  Widget _renderIdleCameraMode(BuildContext context, CaptureBlocState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> items = [];
        items.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.arrow_left,
              size: 20,
              color: Colors.white54,
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: (state.videoEnabled && _videoMode
                    ? _renderCameraButton(context, state)
                    : _renderPictureButton(context, state))),
            Icon(
              Icons.arrow_right,
              size: 20,
              color: Colors.white54,
            ),
          ],
        ));
        if (state.pickerEnabled) {
          items.add(Positioned(
            right: 20,
            top: 0,
            height: constraints.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Icon(Icons.library_books, color: Colors.white54),
                  onPressed: () async {
                    List<File> files = await FilePicker.getMultiFile(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'mp4'],
                    );
                    if (files == null) {
                      return;
                    }
                    setState(() {
                      _loading = true;
                    });
                    BlocProvider.of<CaptureBloc>(context)
                        .add(CaptureBlocEventCreate(files));

                    // if (_videoMode) {
                    //   File video = await ImagePicker.pickVideo(
                    //       source: ImageSource.gallery);
                    //   if (video != null) {
                    //     _filePath = '${FeedMedias.makeFilePath()}.mp4';
                    //     await video
                    //         .copy(FeedMedias.makeAbsoluteFilePath(_filePath));
                    //     _endCapture(state);
                    //   }
                    // } else {
                    //   File image = await ImagePicker.pickImage(
                    //       source: ImageSource.gallery);
                    //   if (image != null) {
                    //     _filePath = '${FeedMedias.makeFilePath()}.jpg';
                    //     await image
                    //         .copy(FeedMedias.makeAbsoluteFilePath(_filePath));
                    //     _endCapture(state);
                    //   }
                    // }
                  },
                ),
              ],
            ),
          ));
        }
        return Stack(
          children: items,
        );
      },
    );
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
      if (_filePath != null) {
        await _deleteFileIfExists(FeedMedias.makeAbsoluteFilePath(_filePath));
      }
      _filePath = '${FeedMedias.makeFilePath()}.jpg';
      String absolutePath = FeedMedias.makeAbsoluteFilePath(_filePath);
      await _cameraController.takePicture(absolutePath);
      _endCapture(state);
    });
  }

  Widget _renderCameraButton(BuildContext context, CaptureBlocState state) {
    return _renderBottomButton(context, Icons.videocam, Colors.blue, () async {
      if (_filePath != null) {
        await _deleteFileIfExists(FeedMedias.makeAbsoluteFilePath(_filePath));
      }
      _filePath = '${FeedMedias.makeFilePath()}.mp4';
      String absolutePath = FeedMedias.makeAbsoluteFilePath(_filePath);
      await _deleteFileIfExists(absolutePath);
      await _cameraController.startVideoRecording(absolutePath);
      setState(() {});
    });
  }

  Widget _renderStopButton(BuildContext context, CaptureBlocState state) {
    return _renderBottomButton(context, Icons.stop, Colors.red, () async {
      await _cameraController.stopVideoRecording();
      _endCapture(state);
      setState(() {});
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

  void _endCapture(CaptureBlocState state) async {
    BlocProvider.of<MainNavigatorBloc>(context).add(
        MainNavigateToImageCapturePlaybackEvent(_filePath,
            overlayPath: state.overlayPath, futureFn: (f) async {
      final ret = await f;
      if (ret == null || ret == false) {
        await _deleteFileIfExists(FeedMedias.makeAbsoluteFilePath(_filePath));
        return;
      }
      setState(() {
        _loading = true;
      });
      BlocProvider.of<CaptureBloc>(context).add(CaptureBlocEventCreate(
          [File(FeedMedias.makeAbsoluteFilePath(_filePath))]));
    }));
  }

  void _setupCamera() async {
    CameraController old = _cameraController;
    if (old != null) {
      await old.dispose();
    }
    _cameraController = CameraController(_cameras[0], ResolutionPreset.veryHigh,
        enableAudio: _enableAudio);
    await _cameraController.initialize();
    setState(() {});
  }

  Future _deleteFileIfExists(String filePath) async {
    final File file = File(filePath);
    try {
      await file.delete();
    } catch (e) {}
  }

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController.dispose();
    }
    super.dispose();
  }
}
