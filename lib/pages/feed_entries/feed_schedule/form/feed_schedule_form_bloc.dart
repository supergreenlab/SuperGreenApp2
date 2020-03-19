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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

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

abstract class FeedScheduleFormBlocState extends Equatable {}

class FeedScheduleFormBlocStateLoaded extends FeedScheduleFormBlocState {
  final String schedule;
  final Map<String, dynamic> schedules;

  final String initialSchedule;
  final Map<String, dynamic> initialSchedules;

  FeedScheduleFormBlocStateLoaded(this.schedule, this.schedules,
      this.initialSchedule, this.initialSchedules);

  @override
  List<Object> get props =>
      [schedule, schedules, this.initialSchedule, this.initialSchedules];
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

class FeedScheduleFormBlocStateNotReachable
    extends FeedScheduleFormBlocState {
  FeedScheduleFormBlocStateNotReachable();

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
  Device _device;

  String _schedule = '';
  Map<String, dynamic> _schedules = {};

  String _initialSchedule;
  Map<String, dynamic> _initialSchedules = {};

  final MainNavigateToFeedScheduleFormEvent _args;

  @override
  FeedScheduleFormBlocState get initialState =>
      FeedScheduleFormBlocStateUnInitialized();

  FeedScheduleFormBloc(this._args) {
    add(FeedScheduleFormBlocEventInit());
  }

  @override
  Stream<FeedScheduleFormBlocState> mapEventToState(
      FeedScheduleFormBlocEvent event) async* {
    if (event is FeedScheduleFormBlocEventInit) {
      final db = RelDB.get();
      _device = await db.devicesDAO.getDevice(_args.box.device);
      Map<String, dynamic> settings = db.boxesDAO.boxSettings(_args.box);
      _initialSchedule = _schedule = settings['schedule'];
      _initialSchedules = _schedules = settings['schedules'];
      yield FeedScheduleFormBlocStateLoaded(
          _schedule, _schedules, _initialSchedule, _initialSchedules);
    } else if (event is FeedScheduleFormBlocEventSetSchedule) {
      _schedule = event.schedule;
      yield FeedScheduleFormBlocStateLoaded(
          _schedule, _schedules, _initialSchedule, _initialSchedules);
    } else if (event is FeedScheduleFormBlocEventCreate) {
      yield FeedScheduleFormBlocStateLoading();
      final db = RelDB.get();

      if (_device != null) {
        _device = await db.devicesDAO.getDevice(_args.box.device);
        if (_device.isReachable == false) {
          yield FeedScheduleFormBlocStateNotReachable();
          return;
        }
        Param onHour = await db.devicesDAO
            .getParam(_device.id, 'BOX_${_args.box.deviceBox}_ON_HOUR');
        await DeviceHelper.updateIntParam(
            _device, onHour, _schedules[_schedule]['ON_HOUR']);
        Param offHour = await db.devicesDAO
            .getParam(_device.id, 'BOX_${_args.box.deviceBox}_OFF_HOUR');
        await DeviceHelper.updateIntParam(
            _device, offHour, _schedules[_schedule]['OFF_HOUR']);
      }

      final Map<String, dynamic> settings = db.boxesDAO.boxSettings(_args.box);
      settings['phase'] = _schedule;
      settings['schedule'] = _schedule;
      settings['schedules'] = _schedules;
      await db.boxesDAO.updateBox(_args.box.id,
          BoxesCompanion(settings: Value(JsonEncoder().convert(settings))));

      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_SCHEDULE',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'initialSchedule': _initialSchedule,
          'initialSchedules': _initialSchedules,
          'schedule': _schedule,
          'schedules': _schedules,
        })),
      ));
      yield FeedScheduleFormBlocStateDone();
    }
  }
}
