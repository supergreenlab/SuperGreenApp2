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
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/feeds/box_helper.dart';
import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/api/device/device_params.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

class BoxControlParamsController extends ParamsController {
  BoxControlParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get blower => params['blower']!;
  ParamController get light => params['light']!;
  ParamController get onHour => params['onHour']!;
  ParamController get onMin => params['onMin']!;
  ParamController get offHour => params['offHour']!;
  ParamController get offMin => params['offMin']!;

  late final int nLights;
  List<ParamController> get lightsDimming {
    List<ParamController> dimmings = [];
    for (int i = 0; i < nLights; ++i) {
      dimmings.add(params['dim$i']!);
    }
    return dimmings;
  }

  static Future<BoxControlParamsController> load(Device device, Box box) async {
    BoxControlParamsController c = BoxControlParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_DUTY', 'blower');
    await c.loadBoxParam(device, box, 'TIMER_OUTPUT', 'light');
    await c.loadBoxParam(device, box, 'ON_HOUR', 'onHour');
    await c.loadBoxParam(device, box, 'ON_MIN', 'onMin');
    await c.loadBoxParam(device, box, 'OFF_HOUR', 'offHour');
    await c.loadBoxParam(device, box, 'OFF_MIN', 'offMin');

    int nLights = 0;
    try {
      Module lightModule = await RelDB.get().devicesDAO.getModule(device.id, "led");
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param boxParam = await RelDB.get().devicesDAO.getParam(device.id, "LED_${i}_BOX");
        if (boxParam.ivalue != box.deviceBox!) {
          continue;
        }
        await c.loadParam(device, "LED_${i}_DIM", 'dim$nLights');
        nLights++;
      }
    } catch (e) {}
    c.nLights = nLights;
    return c;
  }

  ParamsController copyWith({Map<String, ParamController>? params}) =>
      BoxControlParamsController(params: params ?? this.params);
}

abstract class BoxControlsBlocEvent extends Equatable {}

class BoxControlsBlocEventInit extends BoxControlsBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  @override
  List<Object?> get props => [rand];
}

class BoxControlsBlocEventLoaded extends BoxControlsBlocEvent {
  final BoxControlsBlocStateLoaded state;

  BoxControlsBlocEventLoaded(this.state);

  @override
  List<Object?> get props => [state];
}

class BoxControlsBlocEventSetScreenDevice extends BoxControlsBlocEvent {
  final Device device;
  final int deviceBox;

  BoxControlsBlocEventSetScreenDevice(this.device, this.deviceBox);

  @override
  List<Object?> get props => [device, deviceBox];
}

class BoxControlsBlocEventSetDevice extends BoxControlsBlocEvent {
  final Device device;
  final int deviceBox;

  BoxControlsBlocEventSetDevice(this.device, this.deviceBox);

  @override
  List<Object?> get props => [device, deviceBox];
}

abstract class BoxControlsBlocState extends Equatable {}

class BoxControlsBlocStateNoDevice extends BoxControlsBlocState {
  final Plant? plant;
  final Box box;

  BoxControlsBlocStateNoDevice(this.plant, this.box);

  @override
  List<Object?> get props => [
        this.plant,
        this.box,
      ];
}

class BoxControlsBlocStateInit extends BoxControlsBlocState {
  BoxControlsBlocStateInit();

  @override
  List<Object?> get props => [];
}

class BoxControlsBlocStateLoaded extends BoxControlsBlocState {
  final Device device;
  final Plant? plant;
  final Box box;
  final BoxControlParamsController metrics;

  BoxControlsBlocStateLoaded(this.device, this.plant, this.box, this.metrics);

  @override
  List<Object?> get props => [
        this.device,
        this.plant,
        this.box,
        metrics,
      ];
}

class BoxControlsBloc extends LegacyBloc<BoxControlsBlocEvent, BoxControlsBlocState> {
  final Plant? plant;
  Box box;
  Device? device;
  BoxControlParamsController? metrics;

  late List<StreamSubscription<Param>> subscriptions;

  BoxControlsBloc(this.plant, this.box) : super(BoxControlsBlocStateInit()) {
    add(BoxControlsBlocEventInit());
  }

  @override
  Stream<BoxControlsBlocState> mapEventToState(BoxControlsBlocEvent event) async* {
    if (event is BoxControlsBlocEventInit) {
      final db = RelDB.get();
      if (box.device == null) {
        yield BoxControlsBlocStateNoDevice(plant, box);
        return;
      }
      device = await db.devicesDAO.getDevice(box.device!);
      metrics = await BoxControlParamsController.load(device!, box);
      subscriptions = metrics!.listenParams(device!, onParamUpdate);
      yield BoxControlsBlocStateLoaded(device!, plant, box, metrics!);
      metrics!.refreshParams(device!);
    } else if (event is BoxControlsBlocEventLoaded) {
      yield event.state;
    } else if (event is BoxControlsBlocEventSetScreenDevice) {
      final db = RelDB.get();
      await BoxHelper.setBoxDevice(box, screenDevice: event.device);
      this.box = await db.plantsDAO.getBox(box.id);
      add(BoxControlsBlocEventInit());
    } else if (event is BoxControlsBlocEventSetDevice) {
      final db = RelDB.get();
      await BoxHelper.setBoxDevice(box, device: event.device, deviceBox: event.deviceBox, screenDevice: event.device.isScreen ? event.device : null);
      this.box = await db.plantsDAO.getBox(box.id);
      add(BoxControlsBlocEventInit());
    }
  }

  void onParamUpdate(ParamsController newValue) {
    metrics = newValue as BoxControlParamsController;
    add(BoxControlsBlocEventLoaded(BoxControlsBlocStateLoaded(device!, plant, box, metrics!)));
  }

  @override
  Future<void> close() async {
    if (metrics != null) {
      await metrics!.closeSubscriptions(subscriptions);
    }
    return super.close();
  }
}
