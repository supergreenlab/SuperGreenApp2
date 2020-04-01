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

class FeedVentilationFormBlocStateVentilationLoaded
    extends FeedVentilationFormBlocState {
  final int initialBlowerDay;
  final int initialBlowerNight;
  final int blowerDay;
  final int blowerNight;

  FeedVentilationFormBlocStateVentilationLoaded(this.initialBlowerDay,
      this.initialBlowerNight, this.blowerDay, this.blowerNight);

  @override
  List<Object> get props =>
      [initialBlowerDay, initialBlowerNight, blowerDay, blowerNight];
}

class FeedVentilationFormBlocStateNotReachable
    extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
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
    extends FeedVentilationFormBlocStateVentilationLoaded {
  FeedVentilationFormBlocStateNoDevice(int initialBlowerDay,
      int initialBlowerNight, int blowerDay, int blowerNight)
      : super(initialBlowerDay, initialBlowerNight, blowerDay, blowerNight);
}

class FeedVentilationFormBloc
    extends Bloc<FeedVentilationFormBlocEvent, FeedVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent _args;

  Device _device;
  Param _blowerDay;
  Param _blowerNight;
  int _initialBlowerDay;
  int _initialBlowerNight;

  @override
  FeedVentilationFormBlocState get initialState =>
      FeedVentilationFormBlocState();

  FeedVentilationFormBloc(this._args) {
    add(FeedVentilationFormBlocEventLoadVentilations());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(
      FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventLoadVentilations) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(_args.plant.box);
      if (box.device == null) {
        yield FeedVentilationFormBlocStateNoDevice(15, 5, 15, 5);
        return;
      }
      _device = await db.devicesDAO.getDevice(box.device);
      if (_device.isReachable == false) {
        yield FeedVentilationFormBlocStateNotReachable();
        return;
      }
      _blowerDay = await db.devicesDAO
          .getParam(_device.id, "BOX_${box.deviceBox}_BLOWER_DAY");
      _initialBlowerDay = _blowerDay.ivalue;
      _blowerNight = await db.devicesDAO
          .getParam(_device.id, "BOX_${box.deviceBox}_BLOWER_NIGHT");
      _initialBlowerNight = _blowerNight.ivalue;
      yield FeedVentilationFormBlocStateVentilationLoaded(_initialBlowerDay,
          _initialBlowerNight, _blowerDay.ivalue, _blowerNight.ivalue);
    } else if (event is FeedVentilationFormBlocBlowerDayChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(_args.plant.box);
      if (box.device == null) {
        return;
      }
      _blowerDay = _blowerDay.copyWith(ivalue: event.blowerDay);
      await DeviceHelper.updateIntParam(
          _device, _blowerDay, (event.blowerDay).toInt());
      yield FeedVentilationFormBlocStateVentilationLoaded(_initialBlowerDay,
          _initialBlowerNight, _blowerDay.ivalue, _blowerNight.ivalue);
    } else if (event is FeedVentilationFormBlocBlowerNightChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(_args.plant.box);
      if (box.device == null) {
        return;
      }
      if (_device.isReachable == false) {
        yield FeedVentilationFormBlocStateNotReachable();
        return;
      }
      _blowerNight = _blowerNight.copyWith(ivalue: event.blowerNight);
      await DeviceHelper.updateIntParam(
          _device, _blowerNight, (event.blowerNight).toInt());
      yield FeedVentilationFormBlocStateVentilationLoaded(_initialBlowerDay,
          _initialBlowerNight, _blowerDay.ivalue, _blowerNight.ivalue);
    } else if (event is FeedVentilationFormBlocEventCreate) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(_args.plant.box);
      if (box.device == null) {
        return;
      }
      yield FeedVentilationFormBlocStateLoading('Saving..');
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_VENTILATION',
        feed: _args.plant.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'initialValues': {
            'blowerDay': _initialBlowerDay,
            'blowerNight': _initialBlowerNight
          },
          'values': {
            'blowerDay': event.blowerDay,
            'blowerNight': event.blowerNight
          }
        })),
      ));
      yield FeedVentilationFormBlocStateDone();
    } else if (event is FeedVentilationFormBlocEventCancelEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(_args.plant.box);
      if (box.device == null) {
        return;
      }
      if (_device.isReachable == false) {
        yield FeedVentilationFormBlocStateNotReachable();
        return;
      }
      yield FeedVentilationFormBlocStateLoading('Cancelling..');
      try {
        await DeviceHelper.updateIntParam(
            _device, _blowerDay, _initialBlowerDay);
        await DeviceHelper.updateIntParam(
            _device, _blowerNight, _initialBlowerNight);
      } catch (e) {}
      yield FeedVentilationFormBlocStateDone();
    }
  }
}
