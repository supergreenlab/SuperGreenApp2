import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedDefoliationFormBlocEvent extends Equatable {}

class FeedDefoliationFormBlocPushMedia extends FeedDefoliationFormBlocEvent {
  final bool before;
  final FeedMediasCompanion feedDefoliation;

  FeedDefoliationFormBlocPushMedia(this.before, this.feedDefoliation);

  @override
  List<Object> get props => [feedDefoliation];
}

class FeedDefoliationFormBlocEventCreate extends FeedDefoliationFormBlocEvent {
  final String message;
  final bool helpRequest;

  FeedDefoliationFormBlocEventCreate(this.message, this.helpRequest);

  @override
  List<Object> get props => [message, helpRequest];
}

class FeedDefoliationFormBlocState extends Equatable {
  final List<FeedMediasCompanion> beforeMedias;
  final List<FeedMediasCompanion> afterMedias;

  FeedDefoliationFormBlocState(this.beforeMedias, this.afterMedias);

  @override
  List<Object> get props => [beforeMedias, afterMedias];
}

class FeedDefoliationFormBlocStateDone extends FeedDefoliationFormBlocState {
  FeedDefoliationFormBlocStateDone(List<FeedMediasCompanion> beforeMedias, List<FeedMediasCompanion> afterMedias) : super(beforeMedias, afterMedias);

  @override
  List<Object> get props => [];
}

class FeedDefoliationFormBloc
    extends Bloc<FeedDefoliationFormBlocEvent, FeedDefoliationFormBlocState> {
  final MainNavigateToFeedDefoliationFormEvent _args;

  List<FeedMediasCompanion> _beforeMedias = [];
  List<FeedMediasCompanion> _afterMedias = [];

  @override
  FeedDefoliationFormBlocState get initialState => FeedDefoliationFormBlocState(_beforeMedias, _afterMedias);

  FeedDefoliationFormBloc(this._args);

  @override
  Stream<FeedDefoliationFormBlocState> mapEventToState(
      FeedDefoliationFormBlocEvent event) async* {
    if (event is FeedDefoliationFormBlocPushMedia) {
      if (event.before) {
        _beforeMedias.add(event.feedDefoliation);
      } else {
        _afterMedias.add(event.feedDefoliation);
      }
      yield FeedDefoliationFormBlocState(_beforeMedias, _afterMedias);
    } else if (event is FeedDefoliationFormBlocEventCreate) {
      final db = RelDB.get();
      int feedEntryID =
          await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_DEFOLIATION',
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
      yield FeedDefoliationFormBlocStateDone(_beforeMedias, _afterMedias);
    }
  }
}
