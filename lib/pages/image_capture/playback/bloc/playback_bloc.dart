import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class PlaybackBlocEvent extends Equatable {}

class CaptureBlocEventInit extends PlaybackBlocEvent {
  @override
  List<Object> get props => [];
}

class PlaybackBlocState extends Equatable {
  final bool isVideo;
  final String filePath;

  PlaybackBlocState(this.filePath, this.isVideo);
  @override
  List<Object> get props => [filePath, isVideo];
}

class PlaybackBlocStateInit extends PlaybackBlocState {
  PlaybackBlocStateInit(String filePath, bool isVideo)
      : super(filePath, isVideo);
}

class PlaybackBloc extends Bloc<PlaybackBlocEvent, PlaybackBlocState> {
  final MainNavigateToImageCapturePlaybackEvent _args;

  get _isVideo => _args.filePath.endsWith('mp4');

  PlaybackBloc(this._args) {
    add(CaptureBlocEventInit());
  }

  @override
  PlaybackBlocState get initialState =>
      PlaybackBlocState(_args.filePath, _isVideo);

  @override
  Stream<PlaybackBlocState> mapEventToState(PlaybackBlocEvent event) async* {
    if (event is CaptureBlocEventInit) {
      yield PlaybackBlocStateInit(_args.filePath, _isVideo);
    }
  }
}
