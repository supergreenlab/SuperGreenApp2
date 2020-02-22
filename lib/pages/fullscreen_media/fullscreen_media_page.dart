import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/fullscreen_media/fullscreen_media_bloc.dart';

class FullscreenMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FullscreenMediaBloc, FullscreenMediaBlocState>(
        bloc: BlocProvider.of<FullscreenMediaBloc>(context),
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraint) {
              return Hero(
                  tag: 'FeedMedia:${state.feedMedia.filePath}',
                  child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<MainNavigatorBloc>(context)
                            .add(MainNavigatorActionPop());
                      },
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                              width: constraint.maxWidth,
                              height: constraint.maxHeight,
                              child: Container(
                                color: Colors.black,
                                child: Image.file(
                                    File(state.feedMedia.filePath)),
                              )))));
            },
          );
        });
  }
}
