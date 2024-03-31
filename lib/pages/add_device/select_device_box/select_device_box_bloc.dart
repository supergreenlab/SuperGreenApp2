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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:collection/collection.dart';

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

  SelectDeviceBoxBlocStateLoaded(this.boxes, this.nLeds, this.nBoxes, this.device);

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

class SelectDeviceBoxBloc extends LegacyBloc<SelectDeviceBoxBlocEvent, SelectDeviceBoxBlocState> {
  final MainNavigateToSelectDeviceBoxEvent args;

  SelectDeviceBoxBloc(this.args) : super(SelectDeviceBoxBlocStateInit()) {
    add(SelectDeviceBoxBlocEventInitialize());
  }

  @override
  Stream<SelectDeviceBoxBlocState> mapEventToState(SelectDeviceBoxBlocEvent event) async* {
    if (event is SelectDeviceBoxBlocEventInitialize) {
      yield* _loadAll();
    } else if (event is SelectDeviceBoxBlocEventDelete) {
      // lots of duplicated execution follows.. this needs a proper way to represent a group of Params (ie. ll params for a single LED channel for ex)
      yield SelectDeviceBoxBlocStateInit();
      final ddb = RelDB.get().devicesDAO;
      final Device device = await ddb.getDevice(args.device.id);
      final boxEnabledParam = await ddb.getParam(device.id, 'BOX_${event.box}_ENABLED');
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
      //if (boxEnabledParam.ivalue == 1) {
      boxes.add(SelectData(i, boxEnabledParam.ivalue == 1, []));
      //}
    }
    int nLeds = 0;
    try {
      final ledModule = await ddb.getModule(device.id, 'led');
      for (int i = 0; i < ledModule.arrayLen; ++i) {
        final ledBox = await ddb.getParam(device.id, 'LED_${i}_BOX');
        if (ledBox.ivalue! >= 0) {
          SelectData? selectData = boxes.firstWhereOrNull((b) => b.box == ledBox.ivalue);
          if (selectData != null) {
            selectData.leds.add(i);
          }
        }
      }
      nLeds = ledModule.arrayLen;
    } catch (e) {}
    yield SelectDeviceBoxBlocStateLoaded(boxes, nLeds, boxModule.arrayLen, device);
  }
}

class SelectData extends Equatable {
  final int box;
  final bool enabled;
  final List<int> leds;

  SelectData(this.box, this.enabled, this.leds);

  @override
  List<Object> get props => [box, enabled, leds];
}
