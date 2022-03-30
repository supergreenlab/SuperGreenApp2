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

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

class BoxControlMetrics extends Equatable {
  final Param? blower;
  final Param? light;
  final Param? onHour;
  final Param? onMin;
  final Param? offHour;
  final Param? offMin;

  BoxControlMetrics({this.blower, this.light, this.onHour, this.onMin, this.offHour, this.offMin});

  @override
  List<Object?> get props => [this.blower, this.light, this.onHour, this.onMin, this.offHour, this.offMin];

  BoxControlMetrics copyWith(
      {Param? blower, Param? light, Param? onHour, Param? onMin, Param? offHour, Param? offMin}) {
    return BoxControlMetrics(
      blower: blower ?? this.blower,
      light: light ?? this.light,
      onHour: onHour ?? this.onHour,
      onMin: onMin ?? this.onMin,
      offHour: offHour ?? this.offHour,
      offMin: offMin ?? this.offMin,
    );
  }
}

abstract class BoxControlsBlocEvent extends Equatable {}

class BoxControlsBlocEventInit extends BoxControlsBlocEvent {
  @override
  List<Object?> get props => [];
}

class BoxControlsBlocEventLoaded extends BoxControlsBlocEvent {
  final BoxControlsBlocStateLoaded state;

  BoxControlsBlocEventLoaded(this.state);

  @override
  List<Object?> get props => [state];
}

abstract class BoxControlsBlocState extends Equatable {}

class BoxControlsBlocStateInit extends BoxControlsBlocState {
  final Box box;

  BoxControlsBlocStateInit(this.box);

  @override
  List<Object?> get props => [box];
}

class BoxControlsBlocStateLoaded extends BoxControlsBlocState {
  final Plant? plant;
  final Box box;
  final int blower;
  final int light;
  final int scheduleOn;
  final int scheduleOff;
  final bool alerts;

  BoxControlsBlocStateLoaded(
      this.plant, this.box, this.blower, this.light, this.scheduleOn, this.scheduleOff, this.alerts);

  @override
  List<Object?> get props =>
      [this.plant, this.box, this.blower, this.light, this.scheduleOn, this.scheduleOff, this.alerts];
}

class BoxControlsBloc extends LegacyBloc<BoxControlsBlocEvent, BoxControlsBlocState> {
  final Plant? plant;
  final Box box;
  Device? device;

  BoxControlsBloc(this.plant, this.box) : super(BoxControlsBlocStateInit(box)) {
    add(BoxControlsBlocEventInit());
  }

  @override
  Stream<BoxControlsBlocState> mapEventToState(BoxControlsBlocEvent event) async* {
    if (event is BoxControlsBlocEventInit) {
      final db = RelDB.get();
      yield BoxControlsBlocStateLoaded(plant, box, 12, 60, 12, 12, true);
    } else if (event is BoxControlsBlocEventLoaded) {
      yield event.state;
    }
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
