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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class BoxControlsBlocEvent extends Equatable {}

class BoxControlsBlocEventInit extends BoxControlsBlocEvent {
  @override
  List<Object?> get props => throw [];
}

class BoxControlsBlocEventLoaded extends BoxControlsBlocEvent {
  final BoxControlsBlocStateLoaded state;

  BoxControlsBlocEventLoaded(this.state);

  @override
  List<Object?> get props => throw [state];
}

abstract class BoxControlsBlocState extends Equatable {}

class BoxControlsBlocStateInit extends BoxControlsBlocState {
  @override
  List<Object?> get props => throw [];
}

class BoxControlsBlocStateLoaded extends BoxControlsBlocState {
  final int temp;
  final int humidity;
  final DateTime lastWatering;
  final int ventilation;
  final int light;
  final int onDuration;
  final bool alerts;

  BoxControlsBlocStateLoaded(
      this.temp, this.humidity, this.lastWatering, this.ventilation, this.light, this.onDuration, this.alerts);

  @override
  List<Object?> get props => throw [temp, humidity, lastWatering, ventilation, light, onDuration, alerts];
}

class BoxControlsBloc extends LegacyBloc<BoxControlsBlocEvent, BoxControlsBlocState> {
  final Box box;

  BoxControlsBloc(this.box) : super(BoxControlsBlocStateInit());

  @override
  Stream<BoxControlsBlocState> mapEventToState(BoxControlsBlocEvent event) async* {
    if (event is BoxControlsBlocEventInit) {
    } else if (event is BoxControlsBlocEventLoaded) {
      yield event.state;
    }
  }
}
