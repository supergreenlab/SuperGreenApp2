import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedTrainingCardBlocEvent extends Equatable {}

class FeedTrainingCardBlocEventInit extends FeedTrainingCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedTrainingCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final List<FeedMedia> beforeMedias;
  final List<FeedMedia> afterMedias;

  FeedTrainingCardBlocState(this.feed, this.feedEntry, this.params,
      this.beforeMedias, this.afterMedias);

  @override
  List<Object> get props => [
        feed,
        feedEntry,
        params,
        beforeMedias,
        afterMedias,
      ];
}

class FeedTrainingCardBloc
    extends Bloc<FeedTrainingCardBlocEvent, FeedTrainingCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  final List<FeedMedia> _beforeMedias = [];
  final List<FeedMedia> _afterMedias = [];

  @override
  FeedTrainingCardBlocState get initialState => FeedTrainingCardBlocState(
      _feed, _feedEntry, {}, [], []);

  FeedTrainingCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    add(FeedTrainingCardBlocEventInit());
  }

  @override
  Stream<FeedTrainingCardBlocState> mapEventToState(
      FeedTrainingCardBlocEvent event) async* {
    if (event is FeedTrainingCardBlocEventInit) {
      RelDB db = RelDB.get();
      List<FeedMedia> medias = await db.feedsDAO.getFeedMedias(_feedEntry.id);
      _beforeMedias.addAll(medias.where((m) {
        final Map<String, dynamic> params = JsonDecoder().convert(m.params);
        return params['before'];
      }));
      _afterMedias.addAll(medias.where((m) {
        final Map<String, dynamic> params = JsonDecoder().convert(m.params);
        return !params['before'];
      }));
      yield FeedTrainingCardBlocState(
          _feed, _feedEntry, _params, _beforeMedias, _afterMedias);
    }
  }
}
