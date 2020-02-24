import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedTrainingFormBlocEvent extends Equatable {}

class FeedTrainingFormBlocEventCreate extends FeedTrainingFormBlocEvent {
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;
  final String message;
  final bool helpRequest;

  FeedTrainingFormBlocEventCreate(this.beforeMedias, this.afterMedias, this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedTrainingFormBlocState extends Equatable {
  FeedTrainingFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedTrainingFormBlocStateDone extends FeedTrainingFormBlocState {
  FeedTrainingFormBlocStateDone();
}

abstract class FeedTrainingFormBloc
    extends Bloc<FeedTrainingFormBlocEvent, FeedTrainingFormBlocState> {
  final MainNavigateToFeedTrainingFormEvent _args;

  @override
  FeedTrainingFormBlocState get initialState => FeedTrainingFormBlocState();

  FeedTrainingFormBloc(this._args);

  @override
  Stream<FeedTrainingFormBlocState> mapEventToState(
      FeedTrainingFormBlocEvent event) async* {
    if (event is FeedTrainingFormBlocEventCreate) {
      final db = RelDB.get();
      int feedEntryID =
          await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: cardType(),
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
      yield FeedTrainingFormBlocStateDone();
    }
  }

  String cardType();
}
