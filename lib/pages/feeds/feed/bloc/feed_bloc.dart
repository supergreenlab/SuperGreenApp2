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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

abstract class FeedBlocEvent extends Equatable {}

class FeedBlocEventInit extends FeedBlocEvent {
  FeedBlocEventInit() : super();

  @override
  List<Object> get props => [];
}

class FeedBlocEventLoadEntries extends FeedBlocEvent {
  final int n;
  final int currentLength;

  FeedBlocEventLoadEntries(this.n, this.currentLength);

  @override
  List<Object> get props => [n, currentLength];
}

class FeedBlocEventAddedEntry extends FeedBlocEvent {
  final FeedEntryState entry;

  FeedBlocEventAddedEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

class FeedBlocEventUpdatedEntry extends FeedBlocEvent {
  final FeedEntryState entry;

  FeedBlocEventUpdatedEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

class FeedBlocEventDeletedFeedEntry extends FeedBlocEvent {
  final dynamic feedEntryID;

  FeedBlocEventDeletedFeedEntry(this.feedEntryID);

  @override
  List<Object> get props => [feedEntryID];
}

class FeedBlocEventEntryVisible extends FeedBlocEvent {
  final int index;

  FeedBlocEventEntryVisible(this.index);

  @override
  List<Object> get props => [index];
}

class FeedBlocEventEntryHidden extends FeedBlocEvent {
  final int index;

  FeedBlocEventEntryHidden(this.index);

  @override
  List<Object> get props => [index];
}

class FeedBlocEventMarkAsRead extends FeedBlocEvent {
  final int index;

  FeedBlocEventMarkAsRead(this.index);

  @override
  List<Object> get props => [index];
}

class FeedBlocEventSetStoreGeo extends FeedBlocEvent {
  final String storeGeo;

  FeedBlocEventSetStoreGeo(this.storeGeo);

  @override
  List<Object> get props => [storeGeo];
}

class FeedBlocEventEditParams extends FeedBlocEvent {
  final FeedEntryState entry;
  final dynamic params;

  FeedBlocEventEditParams(this.entry, this.params);

  @override
  List<Object> get props => [entry, params];
}

class FeedBlocEventDeleteEntry extends FeedBlocEvent {
  final FeedEntryState entry;

  FeedBlocEventDeleteEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

abstract class FeedBlocState extends Equatable {}

class FeedBlocStateInit extends FeedBlocState {
  FeedBlocStateInit() : super();

  @override
  List<Object> get props => [];
}

class FeedBlocStateFeedLoaded extends FeedBlocState {
  final FeedState feed;

  FeedBlocStateFeedLoaded(this.feed);

  @override
  List<Object> get props => [feed];
}

class FeedBlocStateEntriesLoaded extends FeedBlocState {
  final List<FeedEntryState> entries;
  final bool eof;
  final bool initialLoad;

  FeedBlocStateEntriesLoaded(this.entries, this.eof, this.initialLoad);

  @override
  List<Object> get props => [entries, eof, initialLoad];
}

class FeedBlocStateAddEntry extends FeedBlocState {
  final int index;
  final FeedEntryState entry;

  FeedBlocStateAddEntry(this.index, this.entry);

  @override
  List<Object> get props => [index, entry];
}

class FeedBlocStateUpdateEntry extends FeedBlocState {
  final int index;
  final FeedEntryState entry;

  FeedBlocStateUpdateEntry(this.index, this.entry);

  @override
  List<Object> get props => [index, entry];
}

class FeedBlocStateRemoveEntry extends FeedBlocState {
  final int index;
  final FeedEntryState entry;

  FeedBlocStateRemoveEntry(this.index, this.entry);

  @override
  List<Object> get props => [index, entry];
}

class FeedBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  FeedBlocProvider provider;
  bool initialLoad = true;
  List<FeedEntryState> entries = [];

  FeedBloc(this.provider) {
    add(FeedBlocEventInit());
    add(FeedBlocEventLoadEntries(10, entries.length));
  }

  @override
  FeedBlocState get initialState => FeedBlocStateInit();

  @override
  Stream<FeedBlocState> mapEventToState(FeedBlocEvent event) async* {
    if (event is FeedBlocEventInit) {
      await provider.init(this.add);
      FeedState feedState = await provider.loadFeed();
      yield FeedBlocStateFeedLoaded(feedState);
    } else if (event is FeedBlocEventLoadEntries) {
      List<FeedEntryState> fes =
          await provider.loadEntries(event.n, entries.length);
      entries.addAll(fes);
      yield FeedBlocStateEntriesLoaded(fes, fes.length < event.n, initialLoad);
      initialLoad = false;
    } else if (event is FeedBlocEventEntryVisible) {
      FeedEntryState e = entries[event.index];
      FeedEntryLoader loader = provider.loaderForType(e.type);
      if (e is FeedEntryStateNotLoaded) {
        e = await loader.load(e);
        entries[event.index] = e;
        yield FeedBlocStateUpdateEntry(event.index, e);
      }
      loader.startListenEntryChanges(e);
    } else if (event is FeedBlocEventEntryHidden) {
      FeedEntryState e = entries[event.index];
      FeedEntryLoader loader = provider.loaderForType(e.type);
      loader.cancelListenEntryChanges(entries[event.index]);
    } else if (event is FeedBlocEventAddedEntry) {
      int index = entries
          .indexWhere((fe) => !(fe.date.compareTo(event.entry.date) > 0));
      index = index == -1 ? 0 : index;
      entries.insert(index, event.entry);
      yield FeedBlocStateAddEntry(index, event.entry);
    } else if (event is FeedBlocEventDeletedFeedEntry) {
      int index =
          entries.indexWhere((fe) => fe.feedEntryID == event.feedEntryID);
      FeedEntryState entry = entries[index];
      entries.removeAt(index);
      yield FeedBlocStateRemoveEntry(index, entry);
    } else if (event is FeedBlocEventUpdatedEntry) {
      int index =
          entries.indexWhere((e) => e.feedEntryID == event.entry.feedEntryID);
      entries[index] = event.entry;
      yield FeedBlocStateUpdateEntry(index, event.entry);
    } else if (event is FeedBlocEventMarkAsRead) {
      await provider.markAsRead(entries[event.index].feedEntryID);
    } else if (event is FeedBlocEventSetStoreGeo) {
      AppDB().setStoreGeo(event.storeGeo);
      FeedState feedState = await provider.loadFeed();
      yield FeedBlocStateFeedLoaded(feedState);
    } else if (event is FeedBlocEventEditParams) {
      FeedEntryLoader loader = provider.loaderForType(event.entry.type);
      await loader.update(event.entry, event.params);
    } else if (event is FeedBlocEventDeleteEntry) {
      await provider.deleteFeedEntry(event.entry.feedEntryID);
    }
  }

  @override
  Future<void> close() async {
    await provider.close();
    return super.close();
  }
}

abstract class FeedEntryLoader {
  final Function(FeedBlocEvent) add;

  FeedEntryLoader(this.add);

  Future<FeedEntryStateLoaded> load(FeedEntryState state);
  Future update(FeedEntryState entry, FeedEntryParams params);
  void startListenEntryChanges(FeedEntryStateLoaded entry);
  Future<void> cancelListenEntryChanges(FeedEntryStateLoaded entry);
  Future<void> close();
}

abstract class FeedBlocProvider {
  Map<String, FeedEntryLoader> get loaders;
  FeedEntryLoader loaderForType(String type);

  Future init(Function(FeedBlocEvent) add);
  Future<FeedState> loadFeed();
  Future<List<FeedEntryState>> loadEntries(int n, int offset);
  Future deleteFeedEntry(dynamic feedEntryID);
  Future markAsRead(dynamic feedEntryID);
  Future<void> close();
}
