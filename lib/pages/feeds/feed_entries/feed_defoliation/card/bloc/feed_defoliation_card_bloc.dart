import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedDefoliationCardBlocEvent extends Equatable {}

abstract class FeedDefoliationCardBlocState extends Equatable {}

class FeedDefoliationCardBlocStateIdle extends FeedDefoliationCardBlocState {
  @override
  List<Object> get props => [];
}

class FeedDefoliationCardBloc extends Bloc<FeedDefoliationCardBlocEvent, FeedDefoliationCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedDefoliationCardBlocState get initialState => FeedDefoliationCardBlocStateIdle();

  FeedDefoliationCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedDefoliationCardBlocState> mapEventToState(FeedDefoliationCardBlocEvent event) async* {
  }
}
