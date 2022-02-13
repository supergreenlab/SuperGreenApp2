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
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

abstract class LocalBoxFeedBlocEvent extends Equatable {}

class LocalBoxFeedBlocEventInit extends LocalBoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class LocalBoxFeedBlocEventUpdated extends LocalBoxFeedBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  LocalBoxFeedBlocEventUpdated();

  @override
  List<Object> get props => [rand];
}

class LocalBoxFeedBlocEventCreateFeed extends LocalBoxFeedBlocEvent {
  LocalBoxFeedBlocEventCreateFeed();

  @override
  List<Object> get props => [];
}

abstract class LocalBoxFeedBlocState extends Equatable {}

class LocalBoxFeedBlocStateInit extends LocalBoxFeedBlocState {
  @override
  List<Object> get props => [];
}

class LocalBoxFeedBlocStateLoaded extends LocalBoxFeedBlocState {
  final Box? box;

  LocalBoxFeedBlocStateLoaded(this.box);

  @override
  List<Object?> get props => [box];
}

class LocalBoxFeedBlocStateBoxRemoved extends LocalBoxFeedBlocState {
  LocalBoxFeedBlocStateBoxRemoved();

  @override
  List<Object> get props => [];
}

class LocalBoxFeedBloc extends LegacyBloc<LocalBoxFeedBlocEvent, LocalBoxFeedBlocState> {
  final HomeNavigateToBoxFeedEvent args;

  StreamSubscription<Box>? boxStream;
  Box? box;

  LocalBoxFeedBloc(this.args) : super(LocalBoxFeedBlocStateInit()) {
    add(LocalBoxFeedBlocEventInit());
  }

  @override
  Stream<LocalBoxFeedBlocState> mapEventToState(LocalBoxFeedBlocEvent event) async* {
    if (event is LocalBoxFeedBlocEventInit) {
      try {
        box = await RelDB.get().plantsDAO.getBox(args.box.id);
      } catch (e) {}
      boxStream = RelDB.get().plantsDAO.watchBox(args.box.id).listen(_onBoxUpdated);
      yield LocalBoxFeedBlocStateLoaded(box!);
    } else if (event is LocalBoxFeedBlocEventUpdated) {
      if (box == null) {
        yield LocalBoxFeedBlocStateBoxRemoved();
        return;
      }
      yield LocalBoxFeedBlocStateLoaded(box);
    } else if (event is LocalBoxFeedBlocEventCreateFeed) {
      FeedsCompanion feedsCompanion = FeedsCompanion.insert(name: box!.name);
      int feedID = await RelDB.get().feedsDAO.addFeed(feedsCompanion);
      BoxesCompanion boxesCompanion = BoxesCompanion(
        id: Value(box!.id),
        feed: Value(feedID),
      );
      await RelDB.get().plantsDAO.updateBox(boxesCompanion);
    }
  }

  void _onBoxUpdated(Box b) {
    box = b;
    add(LocalBoxFeedBlocEventUpdated());
  }

  @override
  Future<void> close() async {
    await boxStream?.cancel();
    return super.close();
  }
}
