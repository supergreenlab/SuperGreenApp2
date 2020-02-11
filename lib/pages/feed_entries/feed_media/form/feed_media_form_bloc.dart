import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedMediaFormBlocEvent extends Equatable {}

class FeedMediaFormBlocEventCreate extends FeedMediaFormBlocEvent {
  final List<FeedMediasCompanion> medias;
  final String message;
  final bool helpRequest;

  FeedMediaFormBlocEventCreate(this.medias, this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedMediaFormBlocState extends Equatable {
  FeedMediaFormBlocState();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBlocStateDone extends FeedMediaFormBlocState {
  FeedMediaFormBlocStateDone();

  @override
  List<Object> get props => [];
}

class FeedMediaFormBloc
    extends Bloc<FeedMediaFormBlocEvent, FeedMediaFormBlocState> {
  final MainNavigateToFeedMediaFormEvent _args;

  @override
  FeedMediaFormBlocState get initialState => FeedMediaFormBlocState();

  FeedMediaFormBloc(this._args);

  @override
  Stream<FeedMediaFormBlocState> mapEventToState(
      FeedMediaFormBlocEvent event) async* {
    if (event is FeedMediaFormBlocEventCreate) {
      final db = RelDB.get();
      int feedEntryID =
          await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_MEDIA',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({'message': event.message})),
      ));
      for (FeedMediasCompanion m in event.medias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feedEntry: Value(feedEntryID)));
      }
      yield FeedMediaFormBlocStateDone();
    }
  }
}
