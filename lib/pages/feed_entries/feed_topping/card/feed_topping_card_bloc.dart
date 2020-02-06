import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedToppingCardBlocEvent extends Equatable {}

class FeedToppingCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;

  FeedToppingCardBlocState(this.feed, this.feedEntry);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedToppingCardBloc
    extends Bloc<FeedToppingCardBlocEvent, FeedToppingCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedToppingCardBlocState get initialState =>
      FeedToppingCardBlocState(_feed, _feedEntry);

  FeedToppingCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedToppingCardBlocState> mapEventToState(
      FeedToppingCardBlocEvent event) async* {}
}
