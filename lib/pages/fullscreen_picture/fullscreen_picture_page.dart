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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/fullscreen_picture/fullscreen_picture_bloc.dart';

class FullscreenPicturePage extends TraceableStatefulWidget {
  @override
  _FullscreenPicturePageState createState() => _FullscreenPicturePageState();
}

class _FullscreenPicturePageState extends State<FullscreenPicturePage> {
  Matrix4 _matrix = Matrix4.identity();

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
      child: BlocBuilder<FullscreenPictureBloc, FullscreenPictureBlocState>(
          bloc: BlocProvider.of<FullscreenPictureBloc>(context),
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraint) {
                return Hero(
                    tag: 'Timelapse:${state.id}',
                    child: GestureDetector(onTap: () {
                      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop());
                    }, child: LayoutBuilder(
                      builder: (context, constraints) {
                        Widget body;
                        body = _renderPicturePlayer(context, state, constraints);
                        return body;
                      },
                    )));
              },
            );
          }),
    );
  }

  Widget _renderPicturePlayer(BuildContext context, FullscreenPictureBlocState state, BoxConstraints constraints) {
    Widget picture = SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Image.memory(
          state.image,
          fit: BoxFit.contain,
        ));
    return MatrixGestureDetector(
        onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
          setState(() {
            _matrix = MatrixGestureDetector.compose(_matrix, tm, sm, null);
          });
        },
        onGestureEnd: () {
          setState(() {
            _matrix = Matrix4.identity();
          });
        },
        child: Transform(transform: _matrix, child: Container(color: Colors.black, child: picture)));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
