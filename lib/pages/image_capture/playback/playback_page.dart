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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/image_capture/playback/playback_bloc.dart';
import 'package:video_player/video_player.dart';

class PlaybackPage extends TraceableStatefulWidget {
  @override
  _PlaybackPageState createState() => _PlaybackPageState();
}

class _PlaybackPageState extends State<PlaybackPage> {
  VideoPlayerController? _videoPlayerController;
  double _opacity = 0.5;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocListener(
        bloc: BlocProvider.of<PlaybackBloc>(context),
        listener: (context, state) async {
          if (state is PlaybackBlocStateInit) {
            if (state.isVideo && _videoPlayerController == null) {
              _videoPlayerController =
                  VideoPlayerController.file(File(FeedMedias.makeAbsoluteFilePath(state.filePath)));
              await _videoPlayerController!.initialize();
              _videoPlayerController!.play();
              _videoPlayerController!.setLooping(true);
              setState(() {});
            }
          }
        },
        child: BlocBuilder<PlaybackBloc, PlaybackBlocState>(
            bloc: BlocProvider.of<PlaybackBloc>(context),
            builder: (context, state) {
              return _renderPlayer(context, state);
            }),
      ),
    );
  }

  Widget _renderPlayer(BuildContext context, PlaybackBlocState state) {
    if (state.isVideo) {
      if (_videoPlayerController == null || !_videoPlayerController!.value.isInitialized) {
        return Container();
      }
    }
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return state.isVideo
              ? _renderVideoPlayer(context, state, constraints)
              : _renderPicturePlayer(context, state, constraints);
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

  Widget _renderVideoPlayer(BuildContext context, PlaybackBlocState state, BoxConstraints constraints) {
    double width = constraints.maxHeight * _videoPlayerController!.value.aspectRatio;
    double height = constraints.maxHeight;
    return Stack(children: [
      Positioned(
          left: (constraints.maxWidth - width) / 2,
          top: (constraints.maxHeight - height) / 2,
          child: SizedBox(width: width, height: height, child: VideoPlayer(_videoPlayerController!))),
    ]);
  }

  Widget _renderPicturePlayer(BuildContext context, PlaybackBlocState state, BoxConstraints constraints) {
    Widget picture = SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child:
            FittedBox(fit: BoxFit.contain, child: Image.file(File(FeedMedias.makeAbsoluteFilePath(state.filePath)))));
    if (state.overlayPath != null) {
      picture = Stack(children: [
        picture,
        Opacity(
            opacity: _opacity,
            child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.file(File(FeedMedias.makeAbsoluteFilePath(state.overlayPath!)))))),
        Positioned(
          left: 30,
          right: 30,
          top: constraints.maxHeight * 0.8,
          child: Slider(
            onChanged: (double value) {
              setState(() {
                _opacity = value;
              });
            },
            value: _opacity,
          ),
        )
      ]);
    }
    return Container(color: Colors.black, child: picture);
  }

  Widget _renderCloseButton(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop());
      },
      shape: new CircleBorder(),
      child: new Icon(
        Icons.close,
        color: Colors.white,
        size: 35.0,
      ),
    );
  }

  List<Widget> _renderPreviewMode(BuildContext context, PlaybackBlocState state) {
    return [
      RawMaterialButton(
        child: Text(state.cancelButton, style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: false));
        },
      ),
      RawMaterialButton(
        child: Text(state.okButton, style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: true));
        },
      ),
    ];
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
