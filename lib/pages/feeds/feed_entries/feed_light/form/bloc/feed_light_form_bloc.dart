import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedLightFormBlocEvent extends Equatable {}

abstract class FeedLightFormBlocState extends Equatable {}

class FeedLightFormBlocStateIdle extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBloc extends Bloc<FeedLightFormBlocEvent, FeedLightFormBlocState> {
  final MainNavigateToFeedLightFormEvent _args;

  @override
  FeedLightFormBlocState get initialState => FeedLightFormBlocStateIdle();

  FeedLightFormBloc(this._args);

  @override
  Stream<FeedLightFormBlocState> mapEventToState(FeedLightFormBlocEvent event) async* {
  }
}
