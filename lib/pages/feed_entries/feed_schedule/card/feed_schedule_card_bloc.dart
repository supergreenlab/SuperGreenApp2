import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedScheduleCardBlocEvent extends Equatable {}

class FeedScheduleCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;

  FeedScheduleCardBlocState(this.feed, this.feedEntry);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedScheduleCardBloc
    extends Bloc<FeedScheduleCardBlocEvent, FeedScheduleCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedScheduleCardBlocState get initialState => FeedScheduleCardBlocState(_feed, _feedEntry);

  FeedScheduleCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedScheduleCardBlocState> mapEventToState(
      FeedScheduleCardBlocEvent event) async* {}
}
