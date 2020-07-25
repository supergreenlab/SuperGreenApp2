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
import 'package:super_green_app/data/helpers/device_helper.dart';
import 'package:super_green_app/data/helpers/feed_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_schedule.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/box_settings.dart';

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

  FeedScheduleFormBlocStateLoaded(this.schedule, this.schedules,
      this.initialSchedule, this.initialSchedules, this.box);

  @override
  List<Object> get props =>
      [schedule, schedules, this.initialSchedule, this.initialSchedules, box];
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

class FeedScheduleFormBloc
    extends Bloc<FeedScheduleFormBlocEvent, FeedScheduleFormBlocState> {
  Device device;

  String schedule = '';
  Map<String, dynamic> schedules = {};

  String initialSchedule;
  Map<String, dynamic> initialSchedules = {};

  Box box;

  final MainNavigateToFeedScheduleFormEvent args;

  @override
  FeedScheduleFormBlocState get initialState =>
      FeedScheduleFormBlocStateUnInitialized();

  FeedScheduleFormBloc(this.args) {
    add(FeedScheduleFormBlocEventInit());
  }

  @override
  Stream<FeedScheduleFormBlocState> mapEventToState(
      FeedScheduleFormBlocEvent event) async* {
    if (event is FeedScheduleFormBlocEventInit) {
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(args.plant.box);
      device = await db.devicesDAO.getDevice(box.device);
      BoxSettings boxSettings = BoxSettings.fromJSON(box.settings);
      initialSchedule = schedule = boxSettings.schedule;
      initialSchedules = schedules = boxSettings.schedules;
      yield FeedScheduleFormBlocStateLoaded(
          schedule, schedules, initialSchedule, initialSchedules, box);
    } else if (event is FeedScheduleFormBlocEventSetSchedule) {
      schedule = event.schedule;
      yield FeedScheduleFormBlocStateLoaded(
          schedule, schedules, initialSchedule, initialSchedules, box);
    } else if (event is FeedScheduleFormBlocEventUpdatePreset) {
      schedules[event.schedule] = event.values;
      yield FeedScheduleFormBlocStateLoaded(
          schedule, schedules, initialSchedule, initialSchedules, box);
    } else if (event is FeedScheduleFormBlocEventCreate) {
      yield FeedScheduleFormBlocStateLoading();
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);

      if (device != null) {
        device = await db.devicesDAO.getDevice(box.device);
        Param onHour = await db.devicesDAO
            .getParam(device.id, 'BOX_${box.deviceBox}_ON_HOUR');
        await DeviceHelper.updateHourParam(
            device, onHour, schedules[schedule]['ON_HOUR']);
        Param offHour = await db.devicesDAO
            .getParam(device.id, 'BOX_${box.deviceBox}_OFF_HOUR');
        await DeviceHelper.updateHourParam(
            device, offHour, schedules[schedule]['OFF_HOUR']);
      }

      BoxSettings boxSettings = BoxSettings.fromJSON(box.settings)
          .copyWith(schedule: schedule, schedules: schedules);
      await db.plantsDAO.updateBox(BoxesCompanion(
          id: Value(box.id),
          synced: Value(false),
          settings: Value(boxSettings.toJSON())));
      if (schedule == 'BLOOM') {
        List<Plant> plants = await db.plantsDAO.getPlantsInBox(args.plant.box);
        for (int i = 0; i < plants.length; ++i) {
          await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
            type: 'FE_SCHEDULE',
            feed: plants[i].feed,
            date: DateTime.now(),
            params: Value(FeedScheduleParams(
                    schedule, schedules, initialSchedule, initialSchedules)
                .toJSON()),
          ));
        }
      }
      yield FeedScheduleFormBlocStateDone();
    }
  }
}
