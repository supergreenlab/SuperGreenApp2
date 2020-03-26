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


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class PlantInfosBlocEvent extends Equatable {}

class PlantInfosBlocEventCreateBox extends PlantInfosBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;
  PlantInfosBlocEventCreateBox(this.name, {this.device, this.deviceBox});

  @override
  List<Object> get props => [name, device, deviceBox];
}

class PlantInfosBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlantInfosBlocStateDone extends PlantInfosBlocState {
  final Plant plant;
  final Device device;
  final int deviceBox;
  PlantInfosBlocStateDone(this.plant, {this.device, this.deviceBox});

  @override
  List<Object> get props => [plant, device, deviceBox];
}

class PlantInfosBloc extends Bloc<PlantInfosBlocEvent, PlantInfosBlocState> {
  @override
  PlantInfosBlocState get initialState => PlantInfosBlocState();

  @override
  Stream<PlantInfosBlocState> mapEventToState(PlantInfosBlocEvent event) async* {
    if (event is PlantInfosBlocEventCreateBox) {
      final bdb = RelDB.get().plantsDAO;
      final fdb = RelDB.get().feedsDAO;
      final feed = FeedsCompanion.insert(name: event.name);
      final feedID = await fdb.addFeed(feed);
      PlantsCompanion box;
      if (event.device == null || event.deviceBox == null) {
        box = PlantsCompanion.insert(feed: feedID, name: event.name);
      } else {
        box = PlantsCompanion.insert(
            feed: feedID,
            name: event.name,
            device: Value(event.device.id),
            deviceBox: Value(event.deviceBox));
      }
      final boxID = await bdb.addPlant(box);
      final b = await bdb.getPlant(boxID);
      yield PlantInfosBlocStateDone(b,
          device: event.device, deviceBox: event.deviceBox);
    }
  }
}
