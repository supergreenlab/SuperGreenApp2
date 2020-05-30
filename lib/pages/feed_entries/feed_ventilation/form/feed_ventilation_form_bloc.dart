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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/local/feed_entry_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_ventilation.dart';

abstract class FeedVentilationFormBlocEvent extends Equatable {}

class FeedVentilationFormBlocEventLoadVentilations
    extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventLoadVentilations();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocEventCreate extends FeedVentilationFormBlocEvent {
  final int blowerDay;
  final int blowerNight;

  FeedVentilationFormBlocEventCreate(this.blowerDay, this.blowerNight);

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocBlowerDayChangedEvent
    extends FeedVentilationFormBlocEvent {
  final int blowerDay;

  FeedVentilationFormBlocBlowerDayChangedEvent(this.blowerDay);

  @override
  List<Object> get props => [blowerDay];
}

class FeedVentilationFormBlocBlowerNightChangedEvent
    extends FeedVentilationFormBlocEvent {
  final int blowerNight;

  FeedVentilationFormBlocBlowerNightChangedEvent(this.blowerNight);

  @override
  List<Object> get props => [blowerNight];
}

class FeedVentilationFormBlocEventCancelEvent
    extends FeedVentilationFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocStateLoaded extends FeedVentilationFormBlocState {
  final int initialBlowerDay;
  final int initialBlowerNight;
  final int blowerDay;
  final int blowerNight;
  final Box box;

  FeedVentilationFormBlocStateLoaded(this.initialBlowerDay,
      this.initialBlowerNight, this.blowerDay, this.blowerNight, this.box);

  @override
  List<Object> get props =>
      [initialBlowerDay, initialBlowerNight, blowerDay, blowerNight];
}

class FeedVentilationFormBlocStateLoading extends FeedVentilationFormBlocState {
  final String text;

  FeedVentilationFormBlocStateLoading(this.text);

  @override
  List<Object> get props => [text];
}

class FeedVentilationFormBlocStateDone extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocStateNoDevice
    extends FeedVentilationFormBlocStateLoaded {
  FeedVentilationFormBlocStateNoDevice(int initialBlowerDay,
      int initialBlowerNight, int blowerDay, int blowerNight, Box box)
      : super(
            initialBlowerDay, initialBlowerNight, blowerDay, blowerNight, box);
}

class FeedVentilationFormBloc
    extends Bloc<FeedVentilationFormBlocEvent, FeedVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent args;

  Device device;
  Param blowerDay;
  Param blowerNight;
  int initialBlowerDay;
  int initialBlowerNight;

  @override
  FeedVentilationFormBlocState get initialState =>
      FeedVentilationFormBlocState();

  FeedVentilationFormBloc(this.args) {
    add(FeedVentilationFormBlocEventLoadVentilations());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(
      FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventLoadVentilations) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        yield FeedVentilationFormBlocStateNoDevice(15, 5, 15, 5, box);
        return;
      }
      device = await db.devicesDAO.getDevice(box.device);
      blowerDay = await db.devicesDAO
          .getParam(device.id, "BOX_${box.deviceBox}_BLOWER_DAY");
      initialBlowerDay = blowerDay.ivalue;
      blowerNight = await db.devicesDAO
          .getParam(device.id, "BOX_${box.deviceBox}_BLOWER_NIGHT");
      initialBlowerNight = blowerNight.ivalue;
      yield FeedVentilationFormBlocStateLoaded(initialBlowerDay,
          initialBlowerNight, blowerDay.ivalue, blowerNight.ivalue, box);
    } else if (event is FeedVentilationFormBlocBlowerDayChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        return;
      }
      blowerDay = blowerDay.copyWith(ivalue: event.blowerDay);
      await DeviceHelper.updateIntParam(
          device, blowerDay, (event.blowerDay).toInt());
      yield FeedVentilationFormBlocStateLoaded(initialBlowerDay,
          initialBlowerNight, blowerDay.ivalue, blowerNight.ivalue, box);
    } else if (event is FeedVentilationFormBlocBlowerNightChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        return;
      }
      blowerNight = blowerNight.copyWith(ivalue: event.blowerNight);
      await DeviceHelper.updateIntParam(
          device, blowerNight, (event.blowerNight).toInt());
      yield FeedVentilationFormBlocStateLoaded(initialBlowerDay,
          initialBlowerNight, blowerDay.ivalue, blowerNight.ivalue, box);
    } else if (event is FeedVentilationFormBlocEventCreate) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        return;
      }
      yield FeedVentilationFormBlocStateLoading('Saving..');
      List<Plant> plants = await db.plantsDAO.getPlantsInBox(args.plant.box);
      for (int i = 0; i < plants.length; ++i) {
        await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
          type: 'FE_VENTILATION',
          feed: plants[i].feed,
          date: DateTime.now(),
          params: Value(JsonEncoder().convert(FeedVentilationParams(
              FeedVentilationParamsValues(event.blowerDay, event.blowerNight),
              FeedVentilationParamsValues(
                  initialBlowerDay, initialBlowerNight)))),
        ));
      }
      yield FeedVentilationFormBlocStateDone();
    } else if (event is FeedVentilationFormBlocEventCancelEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        return;
      }
      yield FeedVentilationFormBlocStateLoading('Cancelling..');
      try {
        await DeviceHelper.updateIntParam(device, blowerDay, initialBlowerDay);
        await DeviceHelper.updateIntParam(
            device, blowerNight, initialBlowerNight);
      } catch (e) {}
      yield FeedVentilationFormBlocStateDone();
    }
  }
}
