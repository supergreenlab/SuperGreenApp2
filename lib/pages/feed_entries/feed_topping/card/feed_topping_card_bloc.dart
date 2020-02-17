import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedToppingCardBlocEvent extends Equatable {}

class FeedToppingCardBlocEventInit extends FeedToppingCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedToppingCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final List<FeedMedia> beforeMedias;
  final List<FeedMedia> afterMedias;

  FeedToppingCardBlocState(this.feed, this.feedEntry, this.params,
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

class FeedToppingCardBloc
    extends Bloc<FeedToppingCardBlocEvent, FeedToppingCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  final List<FeedMedia> _beforeMedias = [];
  final List<FeedMedia> _afterMedias = [];

  @override
  FeedToppingCardBlocState get initialState => FeedToppingCardBlocState(
      _feed, _feedEntry, {}, [], []);

  FeedToppingCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    add(FeedToppingCardBlocEventInit());
  }

  @override
  Stream<FeedToppingCardBlocState> mapEventToState(
      FeedToppingCardBlocEvent event) async* {
    if (event is FeedToppingCardBlocEventInit) {
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
      yield FeedToppingCardBlocState(
          _feed, _feedEntry, _params, _beforeMedias, _afterMedias);
    }
  }
}
