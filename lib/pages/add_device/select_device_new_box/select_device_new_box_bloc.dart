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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/helpers/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceNewBoxBlocEvent extends Equatable {}

class SelectDeviceNewBoxBlocEventInitialize extends SelectDeviceNewBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectDeviceNewBoxBlocEventSelectLed extends SelectDeviceNewBoxBlocEvent {
  final int ledID;

  SelectDeviceNewBoxBlocEventSelectLed(this.ledID);

  @override
  List<Object> get props => [ledID];
}

class SelectDeviceNewBoxBlocEventUnselectLed extends SelectDeviceNewBoxBlocEvent {
  final int ledID;

  SelectDeviceNewBoxBlocEventUnselectLed(this.ledID);

  @override
  List<Object> get props => [ledID];
}

class SelectDeviceNewBoxBlocEventSelectLeds extends SelectDeviceNewBoxBlocEvent {
  final List<int> leds;

  SelectDeviceNewBoxBlocEventSelectLeds(this.leds);

  @override
  List<Object> get props => [leds];
}

class SelectDeviceNewBoxBlocState extends Equatable {
  final List<int> leds;

  SelectDeviceNewBoxBlocState(this.leds);

  @override
  List<Object> get props => [leds];
}

class SelectDeviceNewBoxBlocStateLoaded extends SelectDeviceNewBoxBlocState {
  SelectDeviceNewBoxBlocStateLoaded(List<int> leds) : super(leds);
}

class SelectDeviceNewBoxBlocStateDeviceFull extends SelectDeviceNewBoxBlocState {
  SelectDeviceNewBoxBlocStateDeviceFull(List<int> leds) : super(leds);
}

class SelectDeviceNewBoxBlocStateLoading extends SelectDeviceNewBoxBlocState {
  SelectDeviceNewBoxBlocStateLoading(List<int> leds) : super(leds);
}

class SelectDeviceNewBoxBlocStateDone extends SelectDeviceNewBoxBlocState {
  SelectDeviceNewBoxBlocStateDone(List<int> leds) : super(leds);

  @override
  List<Object> get props => [leds];
}

class SelectDeviceNewBoxBloc
    extends Bloc<SelectDeviceNewBoxBlocEvent, SelectDeviceNewBoxBlocState> {
  List<int> boxes = [];
  List<int> leds = [];
  final MainNavigateToSelectNewDeviceBoxEvent args;

  SelectDeviceNewBoxBloc(this.args) {
    add(SelectDeviceNewBoxBlocEventInitialize());
  }

  @override
  SelectDeviceNewBoxBlocState get initialState => SelectDeviceNewBoxBlocState(leds);

  @override
  Stream<SelectDeviceNewBoxBlocState> mapEventToState(
      SelectDeviceNewBoxBlocEvent event) async* {
    if (event is SelectDeviceNewBoxBlocEventInitialize) {
      final ddb = RelDB.get().devicesDAO;
      final Device device = await ddb.getDevice(args.device.id);
      final boxModule = await ddb.getModule(device.id, 'box');
      for (int i = 0; i < boxModule.arrayLen; ++i) {
        final boxEnabled = await ddb.getParam(device.id, 'BOX_${i}_ENABLED');
        if (boxEnabled.ivalue == 0) {
          boxes.add(i);
        }
      }
      if (boxes.length == 0) {
        yield SelectDeviceNewBoxBlocStateDeviceFull(leds);
        return;
      }
      final ledModule = await ddb.getModule(device.id, 'led');
      for (int i = 0; i < ledModule.arrayLen; ++i) {
        final ledBox = await ddb.getParam(device.id, 'LED_${i}_BOX');
        if (ledBox.ivalue < 0 || boxes.contains(ledBox.ivalue)) {
          leds.add(i);
        }
      }
      if (leds.length == 0) {
        yield SelectDeviceNewBoxBlocStateDeviceFull(leds);
        return;
      }
      yield SelectDeviceNewBoxBlocStateLoaded(leds);
    } else if (event is SelectDeviceNewBoxBlocEventSelectLed) {
      final ddb = RelDB.get().devicesDAO;
      final ledDuty =
          await ddb.getParam(args.device.id, 'LED_${event.ledID}_DUTY');
      await DeviceHelper.updateIntParam(args.device, ledDuty, 20);
      final ledDim =
          await ddb.getParam(args.device.id, 'LED_${event.ledID}_DIM');
      await DeviceHelper.updateIntParam(args.device, ledDim, 100);
    } else if (event is SelectDeviceNewBoxBlocEventUnselectLed) {
      final ddb = RelDB.get().devicesDAO;
      final ledDuty =
          await ddb.getParam(args.device.id, 'LED_${event.ledID}_DUTY');
      await DeviceHelper.updateIntParam(args.device, ledDuty, 0);
    } else if (event is SelectDeviceNewBoxBlocEventSelectLeds) {
      yield SelectDeviceNewBoxBlocStateLoading(leds);
      final ddb = RelDB.get().devicesDAO;
      final Device device = await ddb.getDevice(args.device.id);
      for (int i = 0; i < event.leds.length; ++i) {
        final ledBox =
            await ddb.getParam(device.id, 'LED_${event.leds[i]}_BOX');
        await DeviceHelper.updateIntParam(device, ledBox, args.boxID);
        final ledDuty =
            await ddb.getParam(device.id, 'LED_${event.leds[i]}_DUTY');
        await DeviceHelper.updateIntParam(device, ledDuty, 0);
      }
      final boxEnabled = await ddb.getParam(device.id, 'BOX_${args.boxID}_ENABLED');
      await DeviceHelper.updateIntParam(device, boxEnabled, 1);
      yield SelectDeviceNewBoxBlocStateDone(leds);
    }
  }
}
