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
import 'package:super_green_app/pages/explorer/models/plants.dart';

abstract class SearchBlocEvent extends Equatable {}

class SearchBlocEventInit extends SearchBlocEvent {
  @override
  List<Object> get props => [];
}

class SearchBlocEventSearch extends SearchBlocEvent {
  final String search;
  final int offset;

  SearchBlocEventSearch(this.search, this.offset);

  @override
  List<Object> get props => [search, offset];
}

abstract class SearchBlocState extends Equatable {}

class SearchBlocStateInit extends SearchBlocState {
  @override
  List<Object> get props => [];
}

class SearchBlocStateLoaded extends SearchBlocState {
  final List<PublicPlant> plants;
  final bool eof;
  final String search;

  SearchBlocStateLoaded(this.plants, this.eof, this.search);

  @override
  List<Object> get props => [plants, eof, search];
}

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  SearchBloc() : super(SearchBlocStateInit()) {
    add(SearchBlocEventInit());
  }

  @override
  Stream<SearchBlocState> mapEventToState(SearchBlocEvent event) async* {
    if (event is SearchBlocEventInit) {
      yield SearchBlocStateLoaded([], true, null);
    } else if (event is SearchBlocEventSearch) {
      List<dynamic> plantMaps = await BackendAPI().feedsAPI.searchPlants(event.search, 10, event.offset);
      List<PublicPlant> plants = plantMaps.map<PublicPlant>((m) => PublicPlant.fromMap(m)).toList();
      yield SearchBlocStateLoaded(plants, plants.length < 10, event.search);
    }
  }
}
