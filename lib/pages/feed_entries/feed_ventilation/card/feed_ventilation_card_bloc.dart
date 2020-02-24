import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedVentilationCardBlocEvent extends Equatable {}

class FeedVentilationCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;

  FeedVentilationCardBlocState(this.feed, this.feedEntry, this.params);

  @override
  List<Object> get props => [feed, feedEntry, params];
}

class FeedVentilationCardBloc
    extends Bloc<FeedVentilationCardBlocEvent, FeedVentilationCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  @override
  FeedVentilationCardBlocState get initialState =>
      FeedVentilationCardBlocState(_feed, _feedEntry, _params);

  FeedVentilationCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
  }

  @override
  Stream<FeedVentilationCardBlocState> mapEventToState(
      FeedVentilationCardBlocEvent event) async* {}
}
