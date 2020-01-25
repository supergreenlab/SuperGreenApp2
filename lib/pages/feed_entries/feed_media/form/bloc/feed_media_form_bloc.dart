import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedMediaFormBlocEvent extends Equatable {}

class FeedMediaFormBlocEventCreate extends FeedMediaFormBlocEvent {
  final String message;

  FeedMediaFormBlocEventCreate(this.message);

  @override
  List<Object> get props => [message];
}

class FeedMediaFormBlocState extends Equatable {
  final List<FeedMedia> medias;

  FeedMediaFormBlocState(this.medias);

  @override
  List<Object> get props => [medias];
}

class FeedMediaFormBlocStateDone extends FeedMediaFormBlocState {
  FeedMediaFormBlocStateDone(List<FeedMedia> medias) : super(medias);

  @override
  List<Object> get props => [];
}

class FeedMediaFormBloc
    extends Bloc<FeedMediaFormBlocEvent, FeedMediaFormBlocState> {
  final MainNavigateToFeedMediaFormEvent _args;

  List<FeedMedia> _medias = [];

  @override
  FeedMediaFormBlocState get initialState => FeedMediaFormBlocState(_medias);

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
        params: JsonEncoder().convert({'filePath': ''}),
      ));
      yield FeedMediaFormBlocStateDone(_medias);
    }
  }
}
