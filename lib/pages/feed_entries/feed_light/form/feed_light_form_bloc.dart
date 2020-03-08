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

abstract class FeedLightFormBlocEvent extends Equatable {}

class FeedLightFormBlocEventLoadLights extends FeedLightFormBlocEvent {
  FeedLightFormBlocEventLoadLights();

  @override
  List<Object> get props => [];
}

class FeedLightFormBlocEventCancel extends FeedLightFormBlocEvent {
  FeedLightFormBlocEventCancel();

  @override
  List<Object> get props => [];
}

class FeedLightFormBlocEventCreate extends FeedLightFormBlocEvent {
  final List<int> values;

  FeedLightFormBlocEventCreate(this.values);

  @override
  List<Object> get props => [values];
}

class FeedLightFormBlocValueChangedEvent extends FeedLightFormBlocEvent {
  final int i;
  final double value;

  FeedLightFormBlocValueChangedEvent(this.i, this.value);

  @override
  List<Object> get props => [i, value];
}

class FeedLightFormBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedLightFormBlocStateLightsLoaded extends FeedLightFormBlocState {
  final List<int> values;

  FeedLightFormBlocStateLightsLoaded(this.values);

  @override
  List<Object> get props => [values];
}

class FeedLightFormBlocStateNoDevice
    extends FeedLightFormBlocStateLightsLoaded {
  FeedLightFormBlocStateNoDevice(List<int> values) : super(values);
}

class FeedLightFormBlocStateLoading extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBlocStateDone extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBloc
    extends Bloc<FeedLightFormBlocEvent, FeedLightFormBlocState> {
  final MainNavigateToFeedLightFormEvent _args;

  Device _device;
  List<Param> _lightParams;
  List<int> _initialValues;

  @override
  FeedLightFormBlocState get initialState => FeedLightFormBlocState();

  FeedLightFormBloc(this._args) {
    add(FeedLightFormBlocEventLoadLights());
  }

  @override
  Stream<FeedLightFormBlocState> mapEventToState(
      FeedLightFormBlocEvent event) async* {
    if (event is FeedLightFormBlocEventLoadLights) {
      final db = RelDB.get();
      if (_args.box.device == null) {
        yield FeedLightFormBlocStateNoDevice([45, 45, 65, 65]);
        return;
      }
      _device = await db.devicesDAO.getDevice(_args.box.device);
      Module lightModule = await db.devicesDAO.getModule(_device.id, "led");
      _lightParams = [];
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param box = await db.devicesDAO.getParam(_device.id, "LED_${i}_BOX");
        if (box.ivalue == _args.box.deviceBox) {
          _lightParams
              .add(await db.devicesDAO.getParam(_device.id, "LED_${i}_DIM"));
        }
      }
      List<int> values = _lightParams.map((l) => l.ivalue).toList();
      _initialValues = values;
      yield FeedLightFormBlocStateLightsLoaded(values);
    } else if (event is FeedLightFormBlocValueChangedEvent) {
      if (_args.box.device == null) {
        return;
      }
      await DeviceHelper.updateIntParam(
          _device, _lightParams[event.i], (event.value).toInt());
    } else if (event is FeedLightFormBlocEventCreate) {
      if (_args.box.device == null) {
        return;
      }
      yield FeedLightFormBlocStateLoading();
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_LIGHT',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert(
            {'initialValues': _initialValues, 'values': event.values})),
      ));
      yield FeedLightFormBlocStateDone();
    } else if (event is FeedLightFormBlocEventCancel) {
      if (_args.box.device == null) {
        yield FeedLightFormBlocStateDone();
        return;
      }
      for (int i = 0; i < _lightParams.length; ++i) {
        await DeviceHelper.updateIntParam(
            _device, _lightParams[i], _initialValues[i]);
      }
      yield FeedLightFormBlocStateDone();
    }
  }
}
