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

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_schedule.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

abstract class FeedScheduleFormBlocEvent extends Equatable {}

class FeedScheduleFormBlocEventInit extends FeedScheduleFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocEventSetSchedule extends FeedScheduleFormBlocEvent {
  final String schedule;

  FeedScheduleFormBlocEventSetSchedule(this.schedule);

  @override
  List<Object> get props => [schedule];
}

class FeedScheduleFormBlocEventCreate extends FeedScheduleFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocEventUpdatePreset extends FeedScheduleFormBlocEvent {
  final String schedule;
  final Map<String, int> values;

  FeedScheduleFormBlocEventUpdatePreset(this.schedule, this.values);

  @override
  List<Object> get props => [schedule, values];
}

abstract class FeedScheduleFormBlocState extends Equatable {}

class FeedScheduleFormBlocStateLoaded extends FeedScheduleFormBlocState {
  final String schedule;
  final Map<String, dynamic> schedules;

  final String initialSchedule;
  final Map<String, dynamic> initialSchedules;

  final Box box;

  FeedScheduleFormBlocStateLoaded(this.schedule, this.schedules, this.initialSchedule, this.initialSchedules, this.box);

  @override
  List<Object> get props => [schedule, schedules, this.initialSchedule, this.initialSchedules, box];
}

class FeedScheduleFormBlocStateUnInitialized extends FeedScheduleFormBlocState {
  FeedScheduleFormBlocStateUnInitialized();

  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocStateLoading extends FeedScheduleFormBlocState {
  FeedScheduleFormBlocStateLoading();

  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocStateDone extends FeedScheduleFormBlocState {
  FeedScheduleFormBlocStateDone();

  @override
  List<Object> get props => [];
}

class FeedScheduleFormBloc extends LegacyBloc<FeedScheduleFormBlocEvent, FeedScheduleFormBlocState> {
  Device? device;

  String schedule = '';
  Map<String, dynamic> schedules = {};

  late String initialSchedule;
  Map<String, dynamic> initialSchedules = {};

  late Box box;

  final MainNavigateToFeedScheduleFormEvent args;

  FeedScheduleFormBloc(this.args) : super(FeedScheduleFormBlocStateUnInitialized()) {
    add(FeedScheduleFormBlocEventInit());
  }

  @override
  Stream<FeedScheduleFormBlocState> mapEventToState(FeedScheduleFormBlocEvent event) async* {
    if (event is FeedScheduleFormBlocEventInit) {
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(args.box.id);
      if (box.device != null) {
        device = await db.devicesDAO.getDevice(box.device!);
      }
      BoxSettings boxSettings = BoxSettings.fromJSON(box.settings);
      initialSchedule = schedule = boxSettings.schedule;
      initialSchedules = schedules = boxSettings.schedules;
      yield FeedScheduleFormBlocStateLoaded(schedule, schedules, initialSchedule, initialSchedules, box);
    } else if (event is FeedScheduleFormBlocEventSetSchedule) {
      schedule = event.schedule;
      yield FeedScheduleFormBlocStateLoaded(schedule, schedules, initialSchedule, initialSchedules, box);
    } else if (event is FeedScheduleFormBlocEventUpdatePreset) {
      schedules[event.schedule] = event.values;
      yield FeedScheduleFormBlocStateLoaded(schedule, schedules, initialSchedule, initialSchedules, box);
    } else if (event is FeedScheduleFormBlocEventCreate) {
      yield FeedScheduleFormBlocStateLoading();
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);

      if (device != null) {
        device = await db.devicesDAO.getDevice(box.device!);
        Param onHour = await db.devicesDAO.getParam(device!.id, 'BOX_${box.deviceBox}_ON_HOUR');
        Param onMin = await db.devicesDAO.getParam(device!.id, 'BOX_${box.deviceBox}_ON_MIN');
        await DeviceHelper.updateHourMinParams(
            device!, onHour, onMin, schedules[schedule]['ON_HOUR'], schedules[schedule]['ON_MIN']);

        Param offHour = await db.devicesDAO.getParam(device!.id, 'BOX_${box.deviceBox}_OFF_HOUR');
        Param offMin = await db.devicesDAO.getParam(device!.id, 'BOX_${box.deviceBox}_OFF_MIN');
        await DeviceHelper.updateHourMinParams(
            device!, offHour, offMin, schedules[schedule]['OFF_HOUR'], schedules[schedule]['OFF_MIN']);
      }

      BoxSettings boxSettings = BoxSettings.fromJSON(box.settings).copyWith(schedule: schedule, schedules: schedules);
      await db.plantsDAO
          .updateBox(BoxesCompanion(id: Value(box.id), synced: Value(false), settings: Value(boxSettings.toJSON())));
      if (schedule == 'BLOOM') {
        List<Plant> plants = await db.plantsDAO.getPlantsInBox(args.box.id);
        for (int i = 0; i < plants.length; ++i) {
          PlantSettings plantSettings = PlantSettings.fromJSON(plants[i].settings);
          if (plantSettings.dryingStart != null || plantSettings.curingStart != null) {
            continue;
          }
          await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
            type: 'FE_SCHEDULE',
            feed: plants[i].feed,
            date: DateTime.now(),
            params: Value(FeedScheduleParams(schedule, schedules, initialSchedule, initialSchedules).toJSON()),
          ));
        }
      }
      yield FeedScheduleFormBlocStateDone();
    }
  }
}
