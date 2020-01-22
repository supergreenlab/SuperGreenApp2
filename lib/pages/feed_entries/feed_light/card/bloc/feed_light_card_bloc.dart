import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedLightCardBlocEvent extends Equatable {}

class FeedLightCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;

  FeedLightCardBlocState(this.feed, this.feedEntry);

  @override
  List<Object> get props => [feed, feedEntry];
}

class FeedLightCardBlocStateIdle extends FeedLightCardBlocState {
  FeedLightCardBlocStateIdle(Feed feed, FeedEntry feedEntry) : super(feed, feedEntry);
}

class FeedLightCardBloc
    extends Bloc<FeedLightCardBlocEvent, FeedLightCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedLightCardBlocState get initialState => FeedLightCardBlocStateIdle(_feed, _feedEntry);

  FeedLightCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedLightCardBlocState> mapEventToState(
      FeedLightCardBlocEvent event) async* {}
}
