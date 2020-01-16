import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedLightFormBlocEvent extends Equatable {}

class FeedLightFormBlocEventCreate extends FeedLightFormBlocEvent {
  final String name;

  FeedLightFormBlocEventCreate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class FeedLightFormBlocState extends Equatable {}

class FeedLightFormBlocStateIdle extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBloc
    extends Bloc<FeedLightFormBlocEvent, FeedLightFormBlocState> {
  final MainNavigateToFeedLightFormEvent _args;

  @override
  FeedLightFormBlocState get initialState => FeedLightFormBlocStateIdle();

  FeedLightFormBloc(this._args);

  @override
  Stream<FeedLightFormBlocState> mapEventToState(
      FeedLightFormBlocEvent event) async* {
    if (event is FeedLightFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
            type: 'FE_LIGHT',
            feed: _args.box.feed,
            date: DateTime.now(),
            params: JsonEncoder().convert({'test': 'pouet', 'toto': 'tutu'}),
          ));
    }
  }
}
