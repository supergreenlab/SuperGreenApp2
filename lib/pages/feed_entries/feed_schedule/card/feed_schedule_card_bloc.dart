import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedScheduleCardBlocEvent extends Equatable {}

class FeedScheduleCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;

  FeedScheduleCardBlocState(this.feed, this.feedEntry, this.params);

  @override
  List<Object> get props => [feed, feedEntry, params];
}

class FeedScheduleCardBloc
    extends Bloc<FeedScheduleCardBlocEvent, FeedScheduleCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  @override
  FeedScheduleCardBlocState get initialState => FeedScheduleCardBlocState(_feed, _feedEntry, _params);

  FeedScheduleCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
  }

  @override
  Stream<FeedScheduleCardBlocState> mapEventToState(
      FeedScheduleCardBlocEvent event) async* {}
}
