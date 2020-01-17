import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedMediaCardBlocEvent extends Equatable {}

abstract class FeedMediaCardBlocState extends Equatable {}

class FeedMediaCardBlocStateIdle extends FeedMediaCardBlocState {
  @override
  List<Object> get props => [];
}

class FeedMediaCardBloc extends Bloc<FeedMediaCardBlocEvent, FeedMediaCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedMediaCardBlocState get initialState => FeedMediaCardBlocStateIdle();

  FeedMediaCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedMediaCardBlocState> mapEventToState(FeedMediaCardBlocEvent event) async* {
  }
}
