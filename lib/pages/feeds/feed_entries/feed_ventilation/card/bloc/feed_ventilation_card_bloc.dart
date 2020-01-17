import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedVentilationCardBlocEvent extends Equatable {}

abstract class FeedVentilationCardBlocState extends Equatable {}

class FeedVentilationCardBlocStateIdle extends FeedVentilationCardBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationCardBloc extends Bloc<FeedVentilationCardBlocEvent, FeedVentilationCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;

  @override
  FeedVentilationCardBlocState get initialState => FeedVentilationCardBlocStateIdle();

  FeedVentilationCardBloc(this._feed, this._feedEntry);

  @override
  Stream<FeedVentilationCardBlocState> mapEventToState(FeedVentilationCardBlocEvent event) async* {
  }
}
