import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedProductsBlocEvent extends Equatable {}

abstract class FeedProductsBlocState extends Equatable {}

class FeedProductsBlocStateInit extends FeedProductsBlocState {
  @override
  List<Object> get props => [];
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
  FeedProductsBlocState get initialState => FeedProductsBlocStateInit();

  @override
  Stream<FeedProductsBlocState> mapEventToState(
      FeedProductsBlocEvent event) async* {}
}
