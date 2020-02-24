import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FullscreenMediaBlocEvent extends Equatable {}

class FullscreenMediaBlocEventInit extends FullscreenMediaBlocEvent {
  @override
  List<Object> get props => [];
}

class FullscreenMediaBlocState extends Equatable {
  final bool isVideo;
  final FeedMedia feedMedia;

  FullscreenMediaBlocState(this.feedMedia, this.isVideo);

  @override
  List<Object> get props => [feedMedia, isVideo];
}

class FullscreenMediaBlocStateInit extends FullscreenMediaBlocState {
  FullscreenMediaBlocStateInit(FeedMedia feedMedia, bool isVideo)
      : super(feedMedia, isVideo);
}

class FullscreenMediaBloc
    extends Bloc<FullscreenMediaBlocEvent, FullscreenMediaBlocState> {
  final MainNavigateToFullscreenMedia _args;

  get _isVideo => _args.feedMedia.filePath.endsWith('mp4');

  FullscreenMediaBloc(this._args) {
    Timer(Duration(seconds: 1), () => add(FullscreenMediaBlocEventInit()));
  }

  @override
  FullscreenMediaBlocState get initialState =>
      FullscreenMediaBlocState(_args.feedMedia, _isVideo);

  @override
  Stream<FullscreenMediaBlocState> mapEventToState(
      FullscreenMediaBlocEvent event) async* {
    if (event is FullscreenMediaBlocEventInit) {
      yield FullscreenMediaBlocStateInit(_args.feedMedia, _isVideo);
    }
  }
}
