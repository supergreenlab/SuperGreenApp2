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
import 'package:super_green_app/pages/explorer/models/plants.dart';

abstract class SearchBlocEvent extends Equatable {}

class SearchBlocEventInit extends SearchBlocEvent {
  @override
  List<Object> get props => [];
}

class SearchBlocEventSearch extends SearchBlocEvent {
  final String search;

  SearchBlocEventSearch(this.search);

  @override
  List<Object> get props => [search];
}

abstract class SearchBlocState extends Equatable {}

class SearchBlocStateInit extends SearchBlocState {
  @override
  List<Object> get props => [];
}

class SearchBlocStateLoaded extends SearchBlocState {
  final List<PublicPlant> plants;

  SearchBlocStateLoaded(this.plants);

  @override
  List<Object> get props => [plants];
}

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  SearchBloc() : super(SearchBlocStateInit()) {
    add(SearchBlocEventInit());
  }

  @override
  Stream<SearchBlocState> mapEventToState(SearchBlocEvent event) async* {
    if (event is SearchBlocEventInit) {
      yield SearchBlocStateLoaded([]);
    } else if (event is SearchBlocEventSearch) {}
  }
}
