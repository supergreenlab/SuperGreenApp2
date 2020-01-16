import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedWaterFormBlocEvent extends Equatable {}

class FeedWaterFormBlocEventCreate extends FeedWaterFormBlocEvent {
  final String name;

  FeedWaterFormBlocEventCreate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class FeedWaterFormBlocState extends Equatable {}

class FeedWaterFormBlocStateIdle extends FeedWaterFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedWaterFormBlocStateDone extends FeedWaterFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedWaterFormBloc
    extends Bloc<FeedWaterFormBlocEvent, FeedWaterFormBlocState> {
  final MainNavigateToFeedWaterFormEvent _args;

  @override
  FeedWaterFormBlocState get initialState => FeedWaterFormBlocStateIdle();

  FeedWaterFormBloc(this._args);

  @override
  Stream<FeedWaterFormBlocState> mapEventToState(
      FeedWaterFormBlocEvent event) async* {
    if (event is FeedWaterFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_WATER',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: JsonEncoder().convert({'test': 'pouet', 'toto': 'tutu'}),
      ));
      yield FeedWaterFormBlocStateDone();
    }
  }
}
