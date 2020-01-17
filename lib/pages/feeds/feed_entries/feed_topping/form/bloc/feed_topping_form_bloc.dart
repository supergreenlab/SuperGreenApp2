import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedToppingFormBlocEvent extends Equatable {}

class FeedToppingFormBlocEventCreate extends FeedToppingFormBlocEvent {
  final String name;

  FeedToppingFormBlocEventCreate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class FeedToppingFormBlocState extends Equatable {}

class FeedToppingFormBlocStateIdle extends FeedToppingFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedToppingFormBlocStateDone extends FeedToppingFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedToppingFormBloc
    extends Bloc<FeedToppingFormBlocEvent, FeedToppingFormBlocState> {
  final MainNavigateToFeedToppingFormEvent _args;

  @override
  FeedToppingFormBlocState get initialState => FeedToppingFormBlocStateIdle();

  FeedToppingFormBloc(this._args);

  @override
  Stream<FeedToppingFormBlocState> mapEventToState(
      FeedToppingFormBlocEvent event) async* {
    if (event is FeedToppingFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_TOPPING',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: JsonEncoder().convert({'test': 'pouet', 'toto': 'tutu'}),
      ));
      yield FeedToppingFormBlocStateDone();
    }
  }
}
