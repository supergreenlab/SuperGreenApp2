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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_ventilation.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

abstract class FeedTimerVentilationFormBlocEvent extends Equatable {}

class FeedTimerVentilationFormBlocEventInit
    extends FeedTimerVentilationFormBlocEvent {
  FeedTimerVentilationFormBlocEventInit();

  @override
  List<Object> get props => [];
}

class FeedTimerVentilationFormBlocEventCreate
    extends FeedTimerVentilationFormBlocEvent {
  final int blowerDay;
  final int blowerNight;

  FeedTimerVentilationFormBlocEventCreate(this.blowerDay, this.blowerNight);

  @override
  List<Object> get props => [];
}

class FeedTimerVentilationFormBlocBlowerDayChangedEvent
    extends FeedTimerVentilationFormBlocEvent {
  final int blowerDay;

  FeedTimerVentilationFormBlocBlowerDayChangedEvent(this.blowerDay);

  @override
  List<Object> get props => [blowerDay];
}

class FeedTimerVentilationFormBlocBlowerNightChangedEvent
    extends FeedTimerVentilationFormBlocEvent {
  final int blowerNight;

  FeedTimerVentilationFormBlocBlowerNightChangedEvent(this.blowerNight);

  @override
  List<Object> get props => [blowerNight];
}

class FeedTimerVentilationFormBlocEventCancelEvent
    extends FeedTimerVentilationFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedTimerVentilationFormBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedTimerVentilationFormBlocStateLoaded
    extends FeedTimerVentilationFormBlocState {
  final int initialBlowerDay;
  final int initialBlowerNight;
  final int blowerDay;
  final int blowerNight;
  final Box box;

  FeedTimerVentilationFormBlocStateLoaded(this.initialBlowerDay,
      this.initialBlowerNight, this.blowerDay, this.blowerNight, this.box);

  @override
  List<Object> get props =>
      [initialBlowerDay, initialBlowerNight, blowerDay, blowerNight, box];
}

class FeedTimerVentilationFormBlocStateLoading
    extends FeedTimerVentilationFormBlocState {
  final String text;

  FeedTimerVentilationFormBlocStateLoading(this.text);

  @override
  List<Object> get props => [text];
}

class FeedTimerVentilationFormBlocStateDone
    extends FeedTimerVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedTimerVentilationFormBlocStateNoDevice
    extends FeedTimerVentilationFormBlocStateLoaded {
  FeedTimerVentilationFormBlocStateNoDevice(int initialBlowerDay,
      int initialBlowerNight, int blowerDay, int blowerNight, Box box)
      : super(
            initialBlowerDay, initialBlowerNight, blowerDay, blowerNight, box);
}

class FeedTimerVentilationFormBloc extends Bloc<
    FeedTimerVentilationFormBlocEvent, FeedTimerVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent args;

  Device device;
  Param blowerMax;
  Param blowerMin;
  int initialBlowerMax;
  int initialBlowerMin;

  FeedTimerVentilationFormBloc(this.args)
      : super(FeedTimerVentilationFormBlocState()) {
    add(FeedTimerVentilationFormBlocEventInit());
  }

  @override
  Stream<FeedTimerVentilationFormBlocState> mapEventToState(
      FeedTimerVentilationFormBlocEvent event) async* {
    if (event is FeedTimerVentilationFormBlocEventInit) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        yield FeedTimerVentilationFormBlocStateNoDevice(15, 5, 15, 5, box);
        return;
      }
      device = await db.devicesDAO.getDevice(box.device);
      try {
        await loadBlowerParams(box, "BLOWER_DAY", "BLOWER_NIGHT");
      } catch (e) {
        await loadBlowerParams(box, "BLOWER_MAX", "BLOWER_MIN");
      }
      yield FeedTimerVentilationFormBlocStateLoaded(initialBlowerMax,
          initialBlowerMin, blowerMax.ivalue, blowerMin.ivalue, box);
    } else if (event is FeedTimerVentilationFormBlocBlowerDayChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      blowerMax = blowerMax.copyWith(ivalue: event.blowerDay);
      await DeviceHelper.updateIntParam(
          device, blowerMax, (event.blowerDay).toInt());
      yield FeedTimerVentilationFormBlocStateLoaded(initialBlowerMax,
          initialBlowerMin, blowerMax.ivalue, blowerMin.ivalue, box);
    } else if (event is FeedTimerVentilationFormBlocBlowerNightChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      blowerMin = blowerMin.copyWith(ivalue: event.blowerNight);
      await DeviceHelper.updateIntParam(
          device, blowerMin, (event.blowerNight).toInt());
      yield FeedTimerVentilationFormBlocStateLoaded(initialBlowerMax,
          initialBlowerMin, blowerMax.ivalue, blowerMin.ivalue, box);
    } else if (event is FeedTimerVentilationFormBlocEventCreate) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      yield FeedTimerVentilationFormBlocStateLoading('Saving..');
      List<Plant> plants = await db.plantsDAO.getPlantsInBox(args.box.id);
      for (int i = 0; i < plants.length; ++i) {
        PlantSettings plantSettings =
            PlantSettings.fromJSON(plants[i].settings);
        if (plantSettings.dryingStart != null ||
            plantSettings.curingStart != null) {
          continue;
        }
        await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
          type: 'FE_VENTILATION',
          feed: plants[i].feed,
          date: DateTime.now(),
          params: Value(FeedVentilationParams(
                  FeedVentilationParamsValues(
                      blowerDay: event.blowerDay,
                      blowerNight: event.blowerNight,
                      blowerMax: event.blowerDay,
                      blowerMin: event.blowerNight),
                  FeedVentilationParamsValues(
                      blowerDay: initialBlowerMax,
                      blowerNight: initialBlowerMin,
                      blowerMax: initialBlowerMax,
                      blowerMin: initialBlowerMin))
              .toJSON()),
        ));
      }
      yield FeedTimerVentilationFormBlocStateDone();
    } else if (event is FeedTimerVentilationFormBlocEventCancelEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      yield FeedTimerVentilationFormBlocStateLoading('Cancelling..');
      try {
        await DeviceHelper.updateIntParam(device, blowerMax, initialBlowerMax);
        await DeviceHelper.updateIntParam(device, blowerMin, initialBlowerMin);
      } catch (e) {}
      yield FeedTimerVentilationFormBlocStateDone();
    }
  }

  Future<void> loadBlowerParams(
      Box box, String dayParam, String nightParam) async {
    blowerMax = await RelDB.get()
        .devicesDAO
        .getParam(device.id, "BOX_${box.deviceBox}_$dayParam");
    initialBlowerMax = blowerMax.ivalue;
    blowerMin = await RelDB.get()
        .devicesDAO
        .getParam(device.id, "BOX_${box.deviceBox}_$nightParam");
    initialBlowerMin = blowerMin.ivalue;
  }
}
