import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedDefoliationCardBlocEvent extends Equatable {}

class FeedDefoliationCardBlocEventInit extends FeedDefoliationCardBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedDefoliationCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final List<FeedMedia> beforeMedias;
  final List<FeedMedia> afterMedias;

  FeedDefoliationCardBlocState(this.feed, this.feedEntry, this.params,
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

class FeedDefoliationCardBloc
    extends Bloc<FeedDefoliationCardBlocEvent, FeedDefoliationCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};

  final List<FeedMedia> _beforeMedias = [];
  final List<FeedMedia> _afterMedias = [];

  @override
  FeedDefoliationCardBlocState get initialState => FeedDefoliationCardBlocState(
      _feed, _feedEntry, {}, [], []);

  FeedDefoliationCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    add(FeedDefoliationCardBlocEventInit());
  }

  @override
  Stream<FeedDefoliationCardBlocState> mapEventToState(
      FeedDefoliationCardBlocEvent event) async* {
    if (event is FeedDefoliationCardBlocEventInit) {
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
      yield FeedDefoliationCardBlocState(
          _feed, _feedEntry, _params, _beforeMedias, _afterMedias);
    }
  }
}
