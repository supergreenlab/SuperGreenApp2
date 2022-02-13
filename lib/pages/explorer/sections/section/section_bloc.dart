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

import 'package:hive/hive.dart' as hive;
import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';

abstract class SectionBlocEvent extends Equatable {}

class SectionBlocEventInit extends SectionBlocEvent {
  @override
  List<Object> get props => [];
}

class SectionBlocEventLoad extends SectionBlocEvent {
  final int offset;

  SectionBlocEventLoad(this.offset);

  @override
  List<Object> get props => [offset];
}

class SectionBlocEventReload extends SectionBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SectionBlocState extends Equatable {}

class SectionBlocStateInit extends SectionBlocState {
  @override
  List<Object> get props => [];
}

class SectionBlocStateClear extends SectionBlocState {
  @override
  List<Object> get props => [];
}

class SectionBlocStateLoaded<ItemType> extends SectionBlocState {
  final List<ItemType> items;
  final bool eof;

  SectionBlocStateLoaded(this.items, this.eof);

  @override
  List<Object> get props => [items, eof];
}

class SectionBlocStateNotLogged extends SectionBlocState {
  @override
  List<Object> get props => [];
}

abstract class SectionBloc<ItemType> extends LegacyBloc<SectionBlocEvent, SectionBlocState> {
  StreamSubscription<hive.BoxEvent>? appDataStream;

  SectionBloc() : super(SectionBlocStateInit()) {
    add(SectionBlocEventInit());
  }

  int get nItemsLoad => 10;

  @override
  Stream<SectionBlocState> mapEventToState(SectionBlocEvent event) async* {
    if (event is SectionBlocEventInit) {
      if (requiresAuth()) {
        if (!BackendAPI().usersAPI.loggedIn) {
          appDataStream = AppDB().watchAppData().listen(appDataUpdated);
          yield SectionBlocStateNotLogged();
          return;
        }
      }
      yield* loadItemsState(this.nItemsLoad, 0);
    } else if (event is SectionBlocEventReload) {
      yield SectionBlocStateClear();
      yield* loadItemsState(this.nItemsLoad, 0);
    } else if (event is SectionBlocEventLoad) {
      yield* loadItemsState(this.nItemsLoad, event.offset);
    }
  }

  Stream<SectionBlocState> loadItemsState(int n, int offset) async* {
    final List<ItemType> items = [];
    final List<dynamic> itemsMaps = await loadItems(n, offset);
    for (Map<String, dynamic> itemMap in itemsMaps) {
      ItemType item = itemFromMap(itemMap);
      items.add(item);
    }
    yield SectionBlocStateLoaded(items, items.length < n);
  }

  Future<List<dynamic>> loadItems(int n, int offset);
  ItemType itemFromMap(Map<String, dynamic> map);
  bool requiresAuth() {
    return false;
  }

  void appDataUpdated(hive.BoxEvent boxEvent) {
    if (BackendAPI().usersAPI.loggedIn) {
      add(SectionBlocEventInit());
    }
  }

  @override
  Future<void> close() async {
    await appDataStream?.cancel();
    await super.close();
  }
}
