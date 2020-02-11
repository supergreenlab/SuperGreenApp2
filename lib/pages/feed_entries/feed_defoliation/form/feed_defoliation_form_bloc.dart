import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedDefoliationFormBlocEvent extends Equatable {}

class FeedDefoliationFormBlocEventCreate extends FeedDefoliationFormBlocEvent {
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;
  final String message;
  final bool helpRequest;

  FeedDefoliationFormBlocEventCreate(this.beforeMedias, this.afterMedias, this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedDefoliationFormBlocState extends Equatable {
  FeedDefoliationFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedDefoliationFormBlocStateDone extends FeedDefoliationFormBlocState {
  FeedDefoliationFormBlocStateDone();
}

class FeedDefoliationFormBloc
    extends Bloc<FeedDefoliationFormBlocEvent, FeedDefoliationFormBlocState> {
  final MainNavigateToFeedDefoliationFormEvent _args;

  @override
  FeedDefoliationFormBlocState get initialState => FeedDefoliationFormBlocState();

  FeedDefoliationFormBloc(this._args);

  @override
  Stream<FeedDefoliationFormBlocState> mapEventToState(
      FeedDefoliationFormBlocEvent event) async* {
    if (event is FeedDefoliationFormBlocEventCreate) {
      final db = RelDB.get();
      int feedEntryID =
          await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_DEFOLIATION',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({'message': event.message})),
      ));
      for (FeedMediasCompanion m in event.beforeMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feedEntry: Value(feedEntryID), params: Value(JsonEncoder().convert({'before': true}))));
      }
      for (FeedMediasCompanion m in event.afterMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feedEntry: Value(feedEntryID), params: Value(JsonEncoder().convert({'before': false}))));
      }
      yield FeedDefoliationFormBlocStateDone();
    }
  }
}
