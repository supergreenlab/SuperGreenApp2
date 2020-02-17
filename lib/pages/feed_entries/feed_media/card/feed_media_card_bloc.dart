import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedMediaCardBlocEvent extends Equatable {}

class FeedMediaCardBlocEventInit extends FeedMediaCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedMediaCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final List<FeedMedia> medias;

  FeedMediaCardBlocState(this.feed, this.feedEntry, this.params, this.medias);

  @override
  List<Object> get props => [this.feed, this.feedEntry, this.params, this.medias];
}

class FeedMediaCardBloc
    extends Bloc<FeedMediaCardBlocEvent, FeedMediaCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  final List<FeedMedia> _medias = [];

  @override
  FeedMediaCardBlocState get initialState => FeedMediaCardBlocState(_feed, _feedEntry, {}, []);

  FeedMediaCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    add(FeedMediaCardBlocEventInit());
  }

  @override
  Stream<FeedMediaCardBlocState> mapEventToState(
      FeedMediaCardBlocEvent event) async* {
    if (event is FeedMediaCardBlocEventInit) {
      RelDB db = RelDB.get();
      _medias.addAll(await db.feedsDAO.getFeedMedias(_feedEntry.id));
      yield FeedMediaCardBlocState(_feed, _feedEntry, _params, _medias);
    }
  }
}
