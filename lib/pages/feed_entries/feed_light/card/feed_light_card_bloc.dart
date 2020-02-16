import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedLightCardBlocEvent extends Equatable {}

class FeedLightCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;

  FeedLightCardBlocState(this.feed, this.feedEntry, this.params);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedLightCardBloc
    extends Bloc<FeedLightCardBlocEvent, FeedLightCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  @override
  FeedLightCardBlocState get initialState =>
      FeedLightCardBlocState(_feed, _feedEntry, _params);

  FeedLightCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
  }

  @override
  Stream<FeedLightCardBlocState> mapEventToState(
      FeedLightCardBlocEvent event) async* {}
}
