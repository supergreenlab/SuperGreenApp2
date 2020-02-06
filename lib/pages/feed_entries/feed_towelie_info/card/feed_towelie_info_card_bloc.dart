import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedTowelieInfoCardBlocEvent extends Equatable {}

class FeedTowelieInfoCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;

  FeedTowelieInfoCardBlocState(this.feed, this.feedEntry);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedTowelieInfoCardBloc
    extends Bloc<FeedTowelieInfoCardBlocEvent, FeedTowelieInfoCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedTowelieInfoCardBlocState get initialState =>
      FeedTowelieInfoCardBlocState(_feed, _feedEntry);

  FeedTowelieInfoCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedTowelieInfoCardBlocState> mapEventToState(
      FeedTowelieInfoCardBlocEvent event) async* {}
}
