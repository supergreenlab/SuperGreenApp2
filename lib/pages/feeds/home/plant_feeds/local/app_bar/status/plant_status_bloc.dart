/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

abstract class PlantStatusBlocEvent extends Equatable {}

class PlantStatusBlocEventInit extends PlantStatusBlocEvent {
  @override
  List<Object?> get props => throw [];
}

class PlantStatusBlocEventLoaded extends PlantStatusBlocEvent {
  final PlantStatusBlocStateLoaded state;

  PlantStatusBlocEventLoaded(this.state);

  @override
  List<Object?> get props => throw [state];
}

abstract class PlantStatusBlocState extends Equatable {}

class PlantStatusBlocStateInit extends PlantStatusBlocState {
  @override
  List<Object?> get props => throw [];
}

class PlantStatusBlocStateLoaded extends PlantStatusBlocState {
  final int temp;
  final int humidity;
  final DateTime lastWatering;
  final int ventilation;
  final int light;
  final int onDuration;
  final bool alerts;

  PlantStatusBlocStateLoaded(
      this.temp, this.humidity, this.lastWatering, this.ventilation, this.light, this.onDuration, this.alerts);

  @override
  List<Object?> get props => throw [temp, humidity, lastWatering, ventilation, light, onDuration, alerts];
}

class PlantStatusBloc extends Bloc<PlantStatusBlocEvent, PlantStatusBlocState> {
  PlantStatusBloc() : super(PlantStatusBlocStateInit());

  @override
  Stream<PlantStatusBlocState> mapEventToState(PlantStatusBlocEvent event) async* {
    if (event is PlantStatusBlocEventInit) {
    } else if (event is PlantStatusBlocEventLoaded) {
      yield event.state;
    }
  }
}
