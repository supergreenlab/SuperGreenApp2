import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedWaterFormBlocEvent extends Equatable {}

abstract class FeedWaterFormBlocState extends Equatable {}

class FeedWaterFormBlocStateIdle extends FeedWaterFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedWaterFormBloc extends Bloc<FeedWaterFormBlocEvent, FeedWaterFormBlocState> {
  final MainNavigateToFeedWaterFormEvent _args;

  @override
  FeedWaterFormBlocState get initialState => FeedWaterFormBlocStateIdle();

  FeedWaterFormBloc(this._args);

  @override
  Stream<FeedWaterFormBlocState> mapEventToState(FeedWaterFormBlocEvent event) async* {
  }
}
