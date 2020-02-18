import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FullscreenMediaBlocEvent extends Equatable {}

class FullscreenMediaBlocState extends Equatable {
  final FeedMedia feedMedia;

  FullscreenMediaBlocState(this.feedMedia);

  @override
  List<Object> get props => [feedMedia];
}

class FullscreenMediaBloc extends Bloc<FullscreenMediaBlocEvent, FullscreenMediaBlocState> {
  final MainNavigateToFullscreenMedia _args;

  FullscreenMediaBloc(this._args);

  @override
  FullscreenMediaBlocState get initialState => FullscreenMediaBlocState(_args.feedMedia);

  @override
  Stream<FullscreenMediaBlocState> mapEventToState(FullscreenMediaBlocEvent event) async* {
  }
}