import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedProductsBlocEvent extends Equatable {}

class FeedProductsBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;

  FeedProductsBlocState(this.feed, this.feedEntry, this.params);

  @override
  List<Object> get props => [this.feed, this.feedEntry, this.params];
}

class FeedProductsBloc
    extends Bloc<FeedProductsBlocEvent, FeedProductsBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  FeedProductsBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
  }

  @override
  FeedProductsBlocState get initialState =>
      FeedProductsBlocState(_feed, _feedEntry, {});

  @override
  Stream<FeedProductsBlocState> mapEventToState(
      FeedProductsBlocEvent event) async* {}
}
