import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/image_capture/playback/bloc/playback_bloc.dart';
import 'package:video_player/video_player.dart';

class PlaybackPage extends StatefulWidget {
  @override
  _PlaybackPageState createState() => _PlaybackPageState();
}

class _PlaybackPageState extends State<PlaybackPage> {
  VideoPlayerController _videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<PlaybackBloc>(context),
      listener: (context, state) async {
        if (state is PlaybackBlocStateInit) {
          if (state.isVideo && _videoPlayerController == null) {
            _videoPlayerController =
                VideoPlayerController.file(File(state.filePath));
            await _videoPlayerController.initialize();
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            setState(() {});
          }
        }
      },
      child: BlocBuilder<PlaybackBloc, PlaybackBlocState>(
          bloc: Provider.of<PlaybackBloc>(context),
          builder: (context, state) {
            return _renderPlayer(context, state);
          }),
    );
  }

  Widget _renderPlayer(BuildContext context, PlaybackBlocState state) {
    if (state.isVideo) {
      if (_videoPlayerController == null ||
          !_videoPlayerController.value.initialized) {
        return Container();
      }
    }
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return FittedBox(
            fit: BoxFit.cover,
            child: state.isVideo
                ? _renderVideoPlayer(context, state, constraints)
                : _renderPicturePlayer(context, state, constraints),
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

  Widget _renderVideoPlayer(BuildContext context, PlaybackBlocState state,
      BoxConstraints constraints) {
    return SizedBox(
        width: constraints.maxHeight * _videoPlayerController.value.aspectRatio,
        height: constraints.maxHeight,
        child: VideoPlayer(_videoPlayerController));
  }

  Widget _renderPicturePlayer(BuildContext context, PlaybackBlocState state,
      BoxConstraints constraints) {
    return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Image.file(File(state.filePath)));
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

  List<Widget> _renderPreviewMode(
      BuildContext context, PlaybackBlocState state) {
    return [
      RawMaterialButton(
        child:
            Text('RETAKE', style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        },
      ),
      RawMaterialButton(
        child:
            Text('NEXT', style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: true));
        },
      ),
    ];
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }
}
