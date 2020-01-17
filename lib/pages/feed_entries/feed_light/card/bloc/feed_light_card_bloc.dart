import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedLightCardBlocEvent extends Equatable {}

abstract class FeedLightCardBlocState extends Equatable {}

class FeedLightCardBlocStateIdle extends FeedLightCardBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightCardBloc extends Bloc<FeedLightCardBlocEvent, FeedLightCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedLightCardBlocState get initialState => FeedLightCardBlocStateIdle();

  FeedLightCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedLightCardBlocState> mapEventToState(FeedLightCardBlocEvent event) async* {
  }
}
