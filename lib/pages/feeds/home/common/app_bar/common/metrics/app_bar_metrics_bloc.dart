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
import 'package:super_green_app/data/api/device/device_params.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

class AppBarMetricsParamsController extends ParamsController {
  AppBarMetricsParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get temp => this.params['temp']!;
  ParamController get humidity => this.params['humidity']!;
  ParamController? get vpd => this.params['vpd'];
  ParamController? get co2 => this.params['co2'];
  ParamController? get weight => this.params['weight'];

  static Future<AppBarMetricsParamsController> load(Device device, Box box) async {
    AppBarMetricsParamsController c = AppBarMetricsParamsController();
    await c.loadBoxParam(device, box, 'TEMP', 'temp');
    await c.loadBoxParam(device, box, 'HUMI', 'humidity');
    await c.loadBoxParam(device, box, 'VPD', 'vpd');
    await c.loadBoxParam(device, box, 'CO2', 'co2');
    await c.loadBoxParam(device, box, 'WEIGHT', 'weight');
    return c;
  }

  ParamsController copyWith({Map<String, ParamController>? params}) =>
      AppBarMetricsParamsController(params: params ?? this.params);
}

abstract class AppBarMetricsBlocEvent extends Equatable {}

class AppBarMetricsBlocEventInit extends AppBarMetricsBlocEvent {
  @override
  List<Object?> get props => [];
}

class AppBarMetricsBlocEventLoaded extends AppBarMetricsBlocEvent {
  final AppBarMetricsBlocStateLoaded state;

  AppBarMetricsBlocEventLoaded(this.state);

  @override
  List<Object?> get props => [state];
}

abstract class AppBarMetricsBlocState extends Equatable {}

class AppBarMetricsBlocStateNoDevice extends AppBarMetricsBlocState {
  final Plant plant;

  AppBarMetricsBlocStateNoDevice(this.plant);

  @override
  List<Object?> get props => [plant];
}

class AppBarMetricsBlocStateInit extends AppBarMetricsBlocState {
  final Plant plant;

  AppBarMetricsBlocStateInit(this.plant);

  @override
  List<Object?> get props => [plant];
}

class AppBarMetricsBlocStateLoaded extends AppBarMetricsBlocState {
  final Plant plant;
  final AppBarMetricsParamsController metrics;

  AppBarMetricsBlocStateLoaded(this.plant, this.metrics);

  @override
  List<Object?> get props => [this.plant, this.metrics];
}

class AppBarMetricsBloc extends LegacyBloc<AppBarMetricsBlocEvent, AppBarMetricsBlocState> {
  final Plant plant;
  Device? device;
  late Box box;

  Timer? timer;

  AppBarMetricsParamsController? metrics;

  List<StreamSubscription<Param>>? subscriptions;

  AppBarMetricsBloc(this.plant) : super(AppBarMetricsBlocStateInit(plant)) {
    add(AppBarMetricsBlocEventInit());
  }

  @override
  Stream<AppBarMetricsBlocState> mapEventToState(AppBarMetricsBlocEvent event) async* {
    if (event is AppBarMetricsBlocEventInit) {
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(this.plant.box);
      if (box.device == null) {
        yield AppBarMetricsBlocStateNoDevice(plant);
        return;
      }

      device = await db.devicesDAO.getDevice(box.device!);

      timer = Timer.periodic(Duration(seconds: 10), (timer) {
        forceRefresh();
      });
      metrics = await AppBarMetricsParamsController.load(device!, box);
      subscriptions = metrics!.listenParams(device!, onParamsUpdate);
      yield AppBarMetricsBlocStateLoaded(plant, metrics!);
      forceRefresh();
    } else if (event is AppBarMetricsBlocEventLoaded) {
      yield event.state;
    }
  }

  void onParamsUpdate(ParamsController value) {
    this.metrics = value as AppBarMetricsParamsController;
    add(AppBarMetricsBlocEventLoaded(AppBarMetricsBlocStateLoaded(plant, metrics!)));
  }

  void forceRefresh() async {
    await metrics!.refreshParams(device!);
  }

  @override
  Future<void> close() async {
    if (timer != null) {
      timer!.cancel();
    }
    if (metrics != null) {
      await metrics!.closeSubscriptions(subscriptions!);
    }
    return super.close();
  }
}
