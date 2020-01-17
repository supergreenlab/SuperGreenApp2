import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedToppingCardBlocEvent extends Equatable {}

abstract class FeedToppingCardBlocState extends Equatable {}

class FeedToppingCardBlocStateIdle extends FeedToppingCardBlocState {
  @override
  List<Object> get props => [];
}

class FeedToppingCardBloc extends Bloc<FeedToppingCardBlocEvent, FeedToppingCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedToppingCardBlocState get initialState => FeedToppingCardBlocStateIdle();

  FeedToppingCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedToppingCardBlocState> mapEventToState(FeedToppingCardBlocEvent event) async* {
  }
}
