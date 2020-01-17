import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedVentilationFormBlocEvent extends Equatable {}

class FeedVentilationFormBlocEventCreate extends FeedVentilationFormBlocEvent {
  final String name;

  FeedVentilationFormBlocEventCreate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class FeedVentilationFormBlocState extends Equatable {}

class FeedVentilationFormBlocStateIdle extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocStateDone extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBloc
    extends Bloc<FeedVentilationFormBlocEvent, FeedVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent _args;

  @override
  FeedVentilationFormBlocState get initialState => FeedVentilationFormBlocStateIdle();

  FeedVentilationFormBloc(this._args);

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(
      FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_VENTILATION',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: JsonEncoder().convert({'test': 'pouet', 'toto': 'tutu'}),
      ));
      yield FeedVentilationFormBlocStateDone();
    }
  }
}
