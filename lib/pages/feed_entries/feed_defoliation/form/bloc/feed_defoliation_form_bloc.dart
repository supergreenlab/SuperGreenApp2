import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedDefoliationFormBlocEvent extends Equatable {}

class FeedDefoliationFormBlocEventCreate extends FeedDefoliationFormBlocEvent {
  final String name;

  FeedDefoliationFormBlocEventCreate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class FeedDefoliationFormBlocState extends Equatable {}

class FeedDefoliationFormBlocStateIdle extends FeedDefoliationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedDefoliationFormBlocStateDone extends FeedDefoliationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedDefoliationFormBloc
    extends Bloc<FeedDefoliationFormBlocEvent, FeedDefoliationFormBlocState> {
  final MainNavigateToFeedDefoliationFormEvent _args;

  @override
  FeedDefoliationFormBlocState get initialState => FeedDefoliationFormBlocStateIdle();

  FeedDefoliationFormBloc(this._args);

  @override
  Stream<FeedDefoliationFormBlocState> mapEventToState(
      FeedDefoliationFormBlocEvent event) async* {
    if (event is FeedDefoliationFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_DEFOLIATION',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: JsonEncoder().convert({'test': 'pouet', 'toto': 'tutu'}),
      ));
      yield FeedDefoliationFormBlocStateDone();
    }
  }
}
