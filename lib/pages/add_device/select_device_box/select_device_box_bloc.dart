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
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBoxBlocEvent extends Equatable {}

class SelectDeviceBoxBlocEventInitialize extends SelectDeviceBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocEventSelectBox extends SelectDeviceBoxBlocEvent {
  final int box;

  SelectDeviceBoxBlocEventSelectBox(this.box);

  @override
  List<Object> get props => [box];
}

class SelectDeviceBoxBlocEventDelete extends SelectDeviceBoxBlocEvent {
  final int box;

  SelectDeviceBoxBlocEventDelete(this.box);

  @override
  List<Object> get props => [box];
}

abstract class SelectDeviceBoxBlocState extends Equatable {}

class SelectDeviceBoxBlocStateInit extends SelectDeviceBoxBlocState {
  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocStateLoaded extends SelectDeviceBoxBlocState {
  final List<SelectData> boxes;
  final int nLeds;
  final int nBoxes;
  final Device device;

  SelectDeviceBoxBlocStateLoaded(
      this.boxes, this.nLeds, this.nBoxes, this.device);

  @override
  List<Object> get props => [boxes, nLeds, nBoxes, device];
}

class SelectDeviceBoxBlocStateLoading extends SelectDeviceBoxBlocState {
  SelectDeviceBoxBlocStateLoading();

  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocStateDone extends SelectDeviceBoxBlocState {
  final int box;

  SelectDeviceBoxBlocStateDone(this.box);

  @override
  List<Object> get props => [box];
}

class SelectDeviceBoxBloc
    extends Bloc<SelectDeviceBoxBlocEvent, SelectDeviceBoxBlocState> {
  final MainNavigateToSelectDeviceBoxEvent args;

  SelectDeviceBoxBloc(this.args) {
    add(SelectDeviceBoxBlocEventInitialize());
  }

  @override
  SelectDeviceBoxBlocState get initialState => SelectDeviceBoxBlocStateInit();

  @override
  Stream<SelectDeviceBoxBlocState> mapEventToState(
      SelectDeviceBoxBlocEvent event) async* {
    if (event is SelectDeviceBoxBlocEventInitialize) {
      yield* _loadAll();
    } else if (event is SelectDeviceBoxBlocEventDelete) {
      // lots of duplicated execution follows.. this needs a proper way to represent a group of Params (ie. ll params for a single LED channel for ex)
      final ddb = RelDB.get().devicesDAO;
      final Device device = await ddb.getDevice(args.device.id);
      final boxEnabledParam =
          await ddb.getParam(device.id, 'BOX_${event.box}_ENABLED');
      await DeviceHelper.updateIntParam(args.device, boxEnabledParam, 0);
      final ledModule = await ddb.getModule(device.id, 'led');
      for (int i = 0; i < ledModule.arrayLen; ++i) {
        final ledBox = await ddb.getParam(device.id, 'LED_${i}_BOX');
        if (ledBox.ivalue == event.box) {
          await DeviceHelper.updateIntParam(args.device, ledBox, -1);
        }
      }
      yield* _loadAll();
    } else if (event is SelectDeviceBoxBlocEventSelectBox) {
      final ddb = RelDB.get().devicesDAO;
      final Device device = await ddb.getDevice(args.device.id);
      final timerTypeParam =
          await ddb.getParam(device.id, 'BOX_${event.box}_TIMER_TYPE');
      // TODO declare Param enums when possible
      if (timerTypeParam.ivalue != 1) {
        await DeviceHelper.updateIntParam(args.device, timerTypeParam, 1);
      }
      yield SelectDeviceBoxBlocStateDone(event.box);
    }
  }

  Stream<SelectDeviceBoxBlocState> _loadAll() async* {
    final ddb = RelDB.get().devicesDAO;
    final Device device = await ddb.getDevice(args.device.id);
    final boxModule = await ddb.getModule(device.id, 'box');
    List<SelectData> boxes = [];
    for (int i = 0; i < boxModule.arrayLen; ++i) {
      final boxEnabledParam = await ddb.getParam(device.id, 'BOX_${i}_ENABLED');
      if (boxEnabledParam.ivalue == 1) {
        boxes.add(SelectData(i, []));
      }
    }
    final ledModule = await ddb.getModule(device.id, 'led');
    for (int i = 0; i < ledModule.arrayLen; ++i) {
      final ledBox = await ddb.getParam(device.id, 'LED_${i}_BOX');
      if (ledBox.ivalue >= 0) {
        SelectData selectData = boxes.firstWhere((b) => b.box == ledBox.ivalue, orElse: () => null);
        if (selectData != null) {
          selectData.leds.add(i);
        }
      }
    }
    yield SelectDeviceBoxBlocStateLoaded(
        boxes, ledModule.arrayLen, boxModule.arrayLen, device);
  }
}

class SelectData extends Equatable {
  final int box;
  final List<int> leds;

  SelectData(this.box, this.leds);

  @override
  List<Object> get props => [box, leds];
}
