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
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';

class PlantState extends Equatable {
  final String id;
  final String name;
  final String filePath;
  final String thumbnailPath;

  PlantState(this.id, this.name, this.filePath, this.thumbnailPath);

  @override
  List<Object> get props => [id, name, filePath, thumbnailPath];
}

abstract class ExplorerBlocEvent extends Equatable {}

class ExplorerBlocEventInit extends ExplorerBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class ExplorerBlocState extends Equatable {}

class ExplorerBlocStateInit extends ExplorerBlocState {
  @override
  List<Object> get props => [];
}

class ExplorerBlocStateLoaded extends ExplorerBlocState {
  final List<PlantState> plants;

  ExplorerBlocStateLoaded(this.plants);

  @override
  List<Object> get props => [plants];
}

class ExplorerBloc extends Bloc<ExplorerBlocEvent, ExplorerBlocState> {
  ExplorerBloc() {
    add(ExplorerBlocEventInit());
  }

  @override
  ExplorerBlocState get initialState => ExplorerBlocStateInit();

  @override
  Stream<ExplorerBlocState> mapEventToState(ExplorerBlocEvent event) async* {
    if (event is ExplorerBlocEventInit) {
      List<dynamic> plantsMap = await FeedsAPI().publicPlants(15, 0);
      List<PlantState> plants = plantsMap
          .map<PlantState>((p) => PlantState(
                p['id'],
                p['name'],
                p['filePath'],
                p['thumbnailPath'],
              ))
          .toList();
      yield ExplorerBlocStateLoaded(plants);
    }
  }
}
