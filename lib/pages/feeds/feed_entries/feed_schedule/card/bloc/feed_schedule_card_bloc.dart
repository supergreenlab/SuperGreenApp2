import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedScheduleCardBlocEvent extends Equatable {}

abstract class FeedScheduleCardBlocState extends Equatable {}

class FeedScheduleCardBlocStateIdle extends FeedScheduleCardBlocState {
  @override
  List<Object> get props => [];
}

class FeedScheduleCardBloc extends Bloc<FeedScheduleCardBlocEvent, FeedScheduleCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedScheduleCardBlocState get initialState => FeedScheduleCardBlocStateIdle();

  FeedScheduleCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedScheduleCardBlocState> mapEventToState(FeedScheduleCardBlocEvent event) async* {
  }
}
