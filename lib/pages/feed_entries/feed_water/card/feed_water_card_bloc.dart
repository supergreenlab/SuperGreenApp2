import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedWaterCardBlocEvent extends Equatable {}

class FeedWaterCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;

  FeedWaterCardBlocState(this.feed, this.feedEntry);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedWaterCardBloc extends Bloc<FeedWaterCardBlocEvent, FeedWaterCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedWaterCardBlocState get initialState => FeedWaterCardBlocState(_feed, _feedEntry);

  FeedWaterCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedWaterCardBlocState> mapEventToState(FeedWaterCardBlocEvent event) async* {
  }
}
