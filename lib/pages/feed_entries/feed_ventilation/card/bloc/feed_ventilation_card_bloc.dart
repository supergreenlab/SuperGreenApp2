import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedVentilationCardBlocEvent extends Equatable {}

class FeedVentilationCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;

  FeedVentilationCardBlocState(this.feed, this.feedEntry);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedVentilationCardBlocStateIdle extends FeedVentilationCardBlocState {
  FeedVentilationCardBlocStateIdle(Feed feed, FeedEntry feedEntry) : super(feed, feedEntry);

  @override
  List<Object> get props => [];
}

class FeedVentilationCardBloc
    extends Bloc<FeedVentilationCardBlocEvent, FeedVentilationCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedVentilationCardBlocState get initialState =>
      FeedVentilationCardBlocStateIdle(_feed, _feedEntry);

  FeedVentilationCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedVentilationCardBlocState> mapEventToState(
      FeedVentilationCardBlocEvent event) async* {}
}
