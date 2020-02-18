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
          return Scaffold(
            body: Hero(
                tag: 'FeedMedia:${state.feedMedia.filePath}',
                child: GestureDetector(
                  onDoubleTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop());
                  },
                  child: Image.file(File(state.feedMedia.filePath)))),
          );
        });
  }
}
