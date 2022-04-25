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

import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device/device_params.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

class BoxControlParamsController extends ParamsController {
  ParamController get blower => params['blower']!;
  ParamController get light => params['light']!;
  ParamController get onHour => params['onHour']!;
  ParamController get onMin => params['onMin']!;
  ParamController get offHour => params['offHour']!;
  ParamController get offMin => params['offMin']!;

  static Future<BoxControlParamsController> load(Device device, Box box) async {
    BoxControlParamsController c = BoxControlParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_DUTY', 'blower');
    await c.loadBoxParam(device, box, 'TIMER_OUTPUT', 'light');
    await c.loadBoxParam(device, box, 'ON_HOUR', 'onHour');
    await c.loadBoxParam(device, box, 'ON_MIN', 'onMin');
    await c.loadBoxParam(device, box, 'OFF_HOUR', 'offHour');
    await c.loadBoxParam(device, box, 'OFF_MIN', 'offMin');
    return c;
  }
}

abstract class BoxControlsBlocEvent extends Equatable {}

class BoxControlsBlocEventInit extends BoxControlsBlocEvent {
  @override
  List<Object?> get props => [];
}

class BoxControlsBlocEventLoaded extends BoxControlsBlocEvent {
  final BoxControlsBlocStateLoaded state;

  BoxControlsBlocEventLoaded(this.state);

  @override
  List<Object?> get props => [state];
}

abstract class BoxControlsBlocState extends Equatable {}

class BoxControlsBlocStateInit extends BoxControlsBlocState {
  BoxControlsBlocStateInit();

  @override
  List<Object?> get props => [];
}

class BoxControlsBlocStateLoaded extends BoxControlsBlocState {
  final Plant? plant;
  final Box box;
  final BoxControlParamsController metrics;

  BoxControlsBlocStateLoaded(this.plant, this.box, this.metrics);

  @override
  List<Object?> get props => [
        this.plant,
        this.box,
        metrics,
      ];
}

class BoxControlsBloc extends LegacyBloc<BoxControlsBlocEvent, BoxControlsBlocState> {
  final Plant? plant;
  final Box box;
  Device? device;
  late BoxControlParamsController metrics;

  late List<StreamSubscription<Param>> subscriptions;

  BoxControlsBloc(this.plant, this.box) : super(BoxControlsBlocStateInit()) {
    add(BoxControlsBlocEventInit());
  }

  @override
  Stream<BoxControlsBlocState> mapEventToState(BoxControlsBlocEvent event) async* {
    if (event is BoxControlsBlocEventInit) {
      final db = RelDB.get();
      device = await db.devicesDAO.getDevice(box.device!);
      metrics = await BoxControlParamsController.load(device!, box);
      subscriptions = metrics.listenParams(device!, onParamUpdate);
      yield BoxControlsBlocStateLoaded(plant, box, metrics);
    } else if (event is BoxControlsBlocEventLoaded) {
      yield event.state;
    }
  }

  void onParamUpdate(ParamsController newValue) {
    metrics = newValue as BoxControlParamsController;
    add(BoxControlsBlocEventLoaded(BoxControlsBlocStateLoaded(plant, box, metrics)));
  }

  @override
  Future<void> close() async {
    await metrics.closeSubscriptions(subscriptions);
    return super.close();
  }
}
