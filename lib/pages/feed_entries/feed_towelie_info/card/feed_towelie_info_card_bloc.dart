import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedTowelieInfoCardBlocEvent extends Equatable {}

class FeedTowelieInfoCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;

  FeedTowelieInfoCardBlocState(this.feed, this.feedEntry, this.params);

  @override
  List<Object> get props => [feed, feedEntry, params];
}

class FeedTowelieInfoCardBloc
    extends Bloc<FeedTowelieInfoCardBlocEvent, FeedTowelieInfoCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  @override
  FeedTowelieInfoCardBlocState get initialState =>
      FeedTowelieInfoCardBlocState(_feed, _feedEntry, _params);

  FeedTowelieInfoCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
  }

  @override
  Stream<FeedTowelieInfoCardBlocState> mapEventToState(
      FeedTowelieInfoCardBlocEvent event) async* {}
}
