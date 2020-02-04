import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedToppingFormBlocEvent extends Equatable {}

class FeedToppingFormBlocPushMedia extends FeedToppingFormBlocEvent {
  final bool before;
  final FeedMediasCompanion feedMedia;

  FeedToppingFormBlocPushMedia(this.before, this.feedMedia);

  @override
  List<Object> get props => [before, feedMedia];
}

class FeedToppingFormBlocEventCreate extends FeedToppingFormBlocEvent {
  final String message;
  final bool helpRequest;

  FeedToppingFormBlocEventCreate(this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedToppingFormBlocState extends Equatable {
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;

  FeedToppingFormBlocState(this.beforeMedias, this.afterMedias);

  @override
  List<Object> get props => [beforeMedias, afterMedias];
}

class FeedToppingFormBlocStateDone extends FeedToppingFormBlocState {
  FeedToppingFormBlocStateDone(List<FeedMediasCompanion> beforeMedias, List<FeedMediasCompanion> afterMedias) : super(beforeMedias, afterMedias);
}

class FeedToppingFormBloc
    extends Bloc<FeedToppingFormBlocEvent, FeedToppingFormBlocState> {
  final MainNavigateToFeedToppingFormEvent _args;

  List<FeedMediasCompanion> _beforeMedias = [];
  List<FeedMediasCompanion> _afterMedias = [];

  @override
  FeedToppingFormBlocState get initialState => FeedToppingFormBlocState(_beforeMedias, _afterMedias);

  FeedToppingFormBloc(this._args);

  @override
  Stream<FeedToppingFormBlocState> mapEventToState(
      FeedToppingFormBlocEvent event) async* {
    if (event is FeedToppingFormBlocPushMedia) {
      if (event.before) {
        _beforeMedias.add(event.feedMedia);
      } else {
        _afterMedias.add(event.feedMedia);
      }
      yield FeedToppingFormBlocState(_beforeMedias, _afterMedias);
    } else if (event is FeedToppingFormBlocEventCreate) {
      final db = RelDB.get();
      int feedEntryID =
          await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_TOPPING',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({'message': event.message})),
      ));
      for (FeedMediasCompanion m in _beforeMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feedEntry: Value(feedEntryID), params: Value(JsonEncoder().convert({'before': true}))));
      }
      for (FeedMediasCompanion m in _afterMedias) {
        await db.feedsDAO.addFeedMedia(m.copyWith(feedEntry: Value(feedEntryID), params: Value(JsonEncoder().convert({'before': false}))));
      }
      yield FeedToppingFormBlocStateDone(_beforeMedias, _afterMedias);
    }
  }
}
