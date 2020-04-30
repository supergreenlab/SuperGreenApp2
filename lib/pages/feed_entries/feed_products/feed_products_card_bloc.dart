/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedProductsCardBlocEvent extends Equatable {}

class FeedProductsCardBlocEventStoreGeoUpdated
    extends FeedProductsCardBlocEvent {
  final String storeGeo;

  FeedProductsCardBlocEventStoreGeoUpdated(this.storeGeo);

  @override
  // TODO: implement props
  List<Object> get props => [storeGeo];
}

class FeedProductsCardBlocEventSetStoreGeo extends FeedProductsCardBlocEvent {
  final String storeGeo;

  FeedProductsCardBlocEventSetStoreGeo(this.storeGeo);

  @override
  // TODO: implement props
  List<Object> get props => [storeGeo];
}

class FeedProductsCardBlocState extends Equatable {
  final Feed feed;
  final FeedEntry feedEntry;
  final Map<String, dynamic> params;
  final String storeGeo;

  FeedProductsCardBlocState(
      this.feed, this.feedEntry, this.params, this.storeGeo);

  @override
  List<Object> get props =>
      [this.feed, this.feedEntry, this.params, this.storeGeo];
}

class FeedProductsCardBloc
    extends Bloc<FeedProductsCardBlocEvent, FeedProductsCardBlocState> {
  final Feed _feed;
  final FeedEntry _feedEntry;
  final Map<String, dynamic> _params = {};
  StreamSubscription<BoxEvent> _stream;

  @override
  FeedProductsCardBlocState get initialState => FeedProductsCardBlocState(
      _feed, _feedEntry, _params, AppDB().getAppData().storeGeo);

  FeedProductsCardBloc(this._feed, this._feedEntry) {
    _params.addAll(JsonDecoder().convert(_feedEntry.params));
    _stream = AppDB().watchAppData().listen((BoxEvent event) {
      AppData appData = event.value;
      add(FeedProductsCardBlocEventStoreGeoUpdated(appData.storeGeo));
    });
  }

  @override
  Stream<FeedProductsCardBlocState> mapEventToState(
      FeedProductsCardBlocEvent event) async* {
    if (event is FeedProductsCardBlocEventStoreGeoUpdated) {
      yield FeedProductsCardBlocState(
          _feed, _feedEntry, _params, event.storeGeo);
    } else if (event is FeedProductsCardBlocEventSetStoreGeo) {
      AppDB().setStoreGeo(event.storeGeo);
    }
  }

  @override
  Future<void> close() async {
    if (_stream != null) {
      await _stream.cancel();
    }
    return super.close();
  }
}
