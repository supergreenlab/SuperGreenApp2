import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedWaterCardBlocEvent extends Equatable {}

abstract class FeedWaterCardBlocState extends Equatable {}

class FeedWaterCardBlocStateIdle extends FeedWaterCardBlocState {
  @override
  List<Object> get props => [];
}

class FeedWaterCardBloc extends Bloc<FeedWaterCardBlocEvent, FeedWaterCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedWaterCardBlocState get initialState => FeedWaterCardBlocStateIdle();

  FeedWaterCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedWaterCardBlocState> mapEventToState(FeedWaterCardBlocEvent event) async* {
  }
}
