import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedDefoliationCardBlocEvent extends Equatable {}

class FeedDefoliationCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;

  FeedDefoliationCardBlocState(this.feed, this.feedEntry);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedDefoliationCardBloc
    extends Bloc<FeedDefoliationCardBlocEvent, FeedDefoliationCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedDefoliationCardBlocState get initialState =>
      FeedDefoliationCardBlocState(_feed, _feedEntry);

  FeedDefoliationCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedDefoliationCardBlocState> mapEventToState(
      FeedDefoliationCardBlocEvent event) async* {}
}
