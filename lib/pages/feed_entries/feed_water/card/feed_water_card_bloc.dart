import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedWaterCardBlocEvent extends Equatable {}

class FeedWaterCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;

  FeedWaterCardBlocState(this.feed, this.feedEntry, this.params);

  @override
  List<Object> get props => [feed, feedEntry, params];
}

class FeedWaterCardBloc extends Bloc<FeedWaterCardBlocEvent, FeedWaterCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  @override
  FeedWaterCardBlocState get initialState => FeedWaterCardBlocState(_feed, _feedEntry, _params);

  FeedWaterCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
  }

  @override
  Stream<FeedWaterCardBlocState> mapEventToState(FeedWaterCardBlocEvent event) async* {
  }
}
