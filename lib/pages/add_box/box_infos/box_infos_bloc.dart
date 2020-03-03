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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';

abstract class BoxInfosBlocEvent extends Equatable {}

class BoxInfosBlocEventCreateBox extends BoxInfosBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;
  BoxInfosBlocEventCreateBox(this.name, {this.device, this.deviceBox});

  @override
  List<Object> get props => [name, device, deviceBox];
}

class BoxInfosBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class BoxInfosBlocStateDone extends BoxInfosBlocState {
  final Box box;
  final Device device;
  final int deviceBox;
  BoxInfosBlocStateDone(this.box, {this.device, this.deviceBox});

  @override
  List<Object> get props => [box, device, deviceBox];
}

class BoxInfosBloc extends Bloc<BoxInfosBlocEvent, BoxInfosBlocState> {
  @override
  BoxInfosBlocState get initialState => BoxInfosBlocState();

  @override
  Stream<BoxInfosBlocState> mapEventToState(BoxInfosBlocEvent event) async* {
    if (event is BoxInfosBlocEventCreateBox) {
      final bdb = RelDB.get().boxesDAO;
      final fdb = RelDB.get().feedsDAO;
      final feed = FeedsCompanion.insert(name: event.name);
      final feedID = await fdb.addFeed(feed);
      BoxesCompanion box;
      if (event.device == null || event.deviceBox == null) {
        box = BoxesCompanion.insert(feed: feedID, name: event.name);
      } else {
        box = BoxesCompanion.insert(
            feed: feedID,
            name: event.name,
            device: Value(event.device.id),
            deviceBox: Value(event.deviceBox));
      }
      final boxID = await bdb.addBox(box);
      final b = await bdb.getBox(boxID);
      yield BoxInfosBlocStateDone(b,
          device: event.device, deviceBox: event.deviceBox);
    }
  }
}
