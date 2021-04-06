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
import 'package:super_green_app/data/api/backend/backend_api.dart';

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

abstract class SectionBlocState extends Equatable {}

class SectionBlocStateInit extends SectionBlocState {
  @override
  List<Object> get props => [];
}

class SectionBlocStateLoaded<ItemType> extends SectionBlocState {
  final List<ItemType> items;

  SectionBlocStateLoaded(this.items);

  @override
  List<Object> get props => [items];
}

abstract class SectionBloc<ItemType> extends Bloc<SectionBlocEvent, SectionBlocState> {
  SectionBloc() : super(SectionBlocStateInit()) {
    add(SectionBlocEventInit());
  }

  @override
  Stream<SectionBlocState> mapEventToState(SectionBlocEvent event) async* {
    if (event is SectionBlocEventInit) {
      final List<ItemType> items = [];
      final List<dynamic> itemsMaps = await loadItems(10, 0);
      for (Map<String, dynamic> itemsMap in itemsMaps) {
        ItemType item = itemFromMap(itemsMap);
        items.add(item);
      }
      yield SectionBlocStateLoaded(items);
    }
  }

  Future<List<dynamic>> loadItems(int n, int offset);
  ItemType itemFromMap(Map<String, dynamic> map);
}
