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
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class PublicPlantBlocEvent extends Equatable {}

class PublicPlantBlocState extends Equatable {
  final String id;

  PublicPlantBlocState(this.id) : super();

  @override
  List<Object> get props => [id];
}

class PublicPlantBlocStateInit extends PublicPlantBlocState {
  PublicPlantBlocStateInit(String id) : super(id);
}

class PublicPlantBloc extends Bloc<PublicPlantBlocEvent, PublicPlantBlocState> {
  final MainNavigateToPublicPlant args;

  PublicPlantBloc(this.args);

  @override
  PublicPlantBlocState get initialState => PublicPlantBlocStateInit(args.id);

  @override
  Stream<PublicPlantBlocState> mapEventToState(
      PublicPlantBlocEvent event) async* {}
}
