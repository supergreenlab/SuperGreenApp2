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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/fullscreen_media/fullscreen_media_bloc.dart';
import 'package:video_player/video_player.dart';

class FullscreenMediaPage extends StatefulWidget {
  @override
  _FullscreenMediaPageState createState() => _FullscreenMediaPageState();
}

class _FullscreenMediaPageState extends State<FullscreenMediaPage> {
  VideoPlayerController _videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<FullscreenMediaBloc>(context),
      listener: (context, state) async {
        if (state is FullscreenMediaBlocStateInit) {
          if (state.isVideo && _videoPlayerController == null) {
            _videoPlayerController =
                VideoPlayerController.file(File(state.feedMedia.filePath));
            await _videoPlayerController.initialize();
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            setState(() {});
          }
        }
      },
      child: BlocBuilder<FullscreenMediaBloc, FullscreenMediaBlocState>(
          bloc: BlocProvider.of<FullscreenMediaBloc>(context),
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraint) {
                return Hero(
                    tag: 'FeedMedia:${state.feedMedia.filePath}',
                    child: GestureDetector(onTap: () {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigatorActionPop());
                    }, child: LayoutBuilder(
                      builder: (context, constraints) {
                        Widget body;
                        if (state.isVideo) {
                          if (_videoPlayerController != null &&
                              _videoPlayerController.value.isPlaying) {
                            body = Stack(
                              children: <Widget>[
                                _renderPicturePlayer(
                                    context, state, constraints),
                                _renderVideoPlayer(context, state, constraints)
                              ],
                            );
                          } else {
                            body = Stack(
                              children: <Widget>[
                                _renderPicturePlayer(
                                    context, state, constraints),
                                Positioned(
                                  top: constraints.maxHeight / 2 - 20,
                                  height: 40,
                                  left: constraints.maxWidth / 2 - 20,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4.0,
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          body =
                              _renderPicturePlayer(context, state, constraints);
                        }
                        return FittedBox(fit: BoxFit.cover, child: body);
                      },
                    )));
              },
            );
          }),
    );
  }

  Widget _renderVideoPlayer(BuildContext context,
      FullscreenMediaBlocState state, BoxConstraints constraints) {
    return SizedBox(
        width: constraints.maxHeight * _videoPlayerController.value.aspectRatio,
        height: constraints.maxHeight,
        child: VideoPlayer(_videoPlayerController));
  }

  Widget _renderPicturePlayer(BuildContext context,
      FullscreenMediaBlocState state, BoxConstraints constraints) {
    return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Image.file(File(state.isVideo
            ? state.feedMedia.thumbnailPath
            : state.feedMedia.filePath)));
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }
}
