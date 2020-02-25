import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedCareCommonFormBlocEvent extends Equatable {}

class FeedCareCommonFormBlocEventCreate extends FeedCareCommonFormBlocEvent {
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;
  final String message;
  final bool helpRequest;

  FeedCareCommonFormBlocEventCreate(this.beforeMedias, this.afterMedias, this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedCareCommonFormBlocState extends Equatable {
  FeedCareCommonFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedCareCommonFormBlocStateDone extends FeedCareCommonFormBlocState {
  FeedCareCommonFormBlocStateDone();
}

abstract class FeedCareCommonFormBloc
    extends Bloc<FeedCareCommonFormBlocEvent, FeedCareCommonFormBlocState> {
  final MainNavigateToFeedCareCommonFormEvent _args;

  @override
  FeedCareCommonFormBlocState get initialState => FeedCareCommonFormBlocState();

  FeedCareCommonFormBloc(this._args);

  @override
  Stream<FeedCareCommonFormBlocState> mapEventToState(
      FeedCareCommonFormBlocEvent event) async* {
    if (event is FeedCareCommonFormBlocEventCreate) {
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
      yield FeedCareCommonFormBlocStateDone();
    }
  }

  String cardType();
}
