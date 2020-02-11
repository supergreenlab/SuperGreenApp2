import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedToppingFormBlocEvent extends Equatable {}

class FeedToppingFormBlocEventCreate extends FeedToppingFormBlocEvent {
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;
  final String message;
  final bool helpRequest;

  FeedToppingFormBlocEventCreate(this.beforeMedias, this.afterMedias, this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedToppingFormBlocState extends Equatable {
  FeedToppingFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedToppingFormBlocStateDone extends FeedToppingFormBlocState {
  FeedToppingFormBlocStateDone();
}

class FeedToppingFormBloc
    extends Bloc<FeedToppingFormBlocEvent, FeedToppingFormBlocState> {
  final MainNavigateToFeedToppingFormEvent _args;

  @override
  FeedToppingFormBlocState get initialState => FeedToppingFormBlocState();

  FeedToppingFormBloc(this._args);

  @override
  Stream<FeedToppingFormBlocState> mapEventToState(
      FeedToppingFormBlocEvent event) async* {
    if (event is FeedToppingFormBlocEventCreate) {
      final db = RelDB.get();
      int feedEntryID =
          await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_TOPPING',
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
      yield FeedToppingFormBlocStateDone();
    }
  }
}
