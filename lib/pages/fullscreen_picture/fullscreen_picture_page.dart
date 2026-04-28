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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/fullscreen_picture/fullscreen_picture_bloc.dart';

class FullscreenPicturePage extends StatefulWidget {
  @override
  _FullscreenPicturePageState createState() => _FullscreenPicturePageState();
}

class _FullscreenPicturePageState extends State<FullscreenPicturePage> {
  final TransformationController _transformationController = TransformationController();

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
    return Container(
      color: Colors.black,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 4.0,
        onInteractionEnd: (details) {
          _transformationController.value = Matrix4.identity();
        },
        child: picture,
      ),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
