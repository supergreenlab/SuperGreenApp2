import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedMediaFormBlocEvent extends Equatable {}

class FeedMediaFormBlocEventCreate extends FeedMediaFormBlocEvent {
  final String name;

  FeedMediaFormBlocEventCreate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class FeedMediaFormBlocState extends Equatable {}

class FeedMediaFormBlocStateIdle extends FeedMediaFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocStateDone extends FeedMediaFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedMediaFormBloc
    extends Bloc<FeedMediaFormBlocEvent, FeedMediaFormBlocState> {
  final MainNavigateToFeedMediaFormEvent _args;

  @override
  FeedMediaFormBlocState get initialState => FeedMediaFormBlocStateIdle();

  FeedMediaFormBloc(this._args);

  @override
  Stream<FeedMediaFormBlocState> mapEventToState(
      FeedMediaFormBlocEvent event) async* {
    if (event is FeedMediaFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_MEDIA',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: JsonEncoder().convert({'test': 'pouet', 'toto': 'tutu'}),
      ));
      yield FeedMediaFormBlocStateDone();
    }
  }
}
