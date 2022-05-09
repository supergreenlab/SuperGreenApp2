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

import 'package:super_green_app/data/api/device/device_params.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_ventilation.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

// TODO make device param management/module helpers based on VentilationControllerParam
// TODO ref source values from config

const int TEMP_REF_OFFSET = 0x1;
const int TIMER_REF_OFFSET = 0x8;
const int HUMI_REF_OFFSET = 0xf;

bool isTempSource(int source) => source >= TEMP_REF_OFFSET && source < TIMER_REF_OFFSET;
bool isTimerSource(int source) => source >= TIMER_REF_OFFSET && source < HUMI_REF_OFFSET;
bool isHumiSource(int source) => source >= HUMI_REF_OFFSET;

class MinMaxParamsController extends ParamsController {
  ParamController get blowerMin => params['blowerMin']!;
  ParamController get blowerMax => params['blowerMax']!;
  ParamController get blowerRefMin => params['blowerRefMin']!;
  ParamController get blowerRefMax => params['blowerRefMax']!;
  ParamController get blowerRefSource => params['blowerRefSource']!;

  static Future<MinMaxParamsController> load(Device device, Box box) async {
    MinMaxParamsController c = MinMaxParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_MIN', 'blowerMin');
    await c.loadBoxParam(device, box, 'BLOWER_MAX', 'blowerMax');
    await c.loadBoxParam(device, box, 'BLOWER_REF_MIN', 'blowerRefMin');
    await c.loadBoxParam(device, box, 'BLOWER_REF_MAX', 'blowerRefMax');
    await c.loadBoxParam(device, box, 'BLOWER_REF_SOURCE', 'blowerRefSource');
    return c;
  }
}

class LegacyParamsController extends ParamsController {
  ParamController get blowerDay => params['blowerDay']!;
  ParamController get blowerNight => params['blowerNight']!;

  static Future<LegacyParamsController> load(Device device, Box box) async {
    LegacyParamsController c = LegacyParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_DAY', 'blowerDay');
    await c.loadBoxParam(device, box, 'BLOWER_NIGHT', 'blowerNight');
    return c;
  }
}

abstract class FeedVentilationFormBlocEvent extends Equatable {}

class FeedVentilationFormBlocEventInit extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventInit();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocEventCreate extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventCreate();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocParamsChangedEvent extends FeedVentilationFormBlocEvent {
  final MinMaxParamsController? minMaxController;

  // legacy fields
  final LegacyParamsController? legacyController;

  FeedVentilationFormBlocParamsChangedEvent({
    this.minMaxController,
    this.legacyController,
  });

  @override
  List<Object?> get props => [minMaxController, legacyController];
}

class FeedVentilationFormBlocEventCancelEvent extends FeedVentilationFormBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class FeedVentilationFormBlocState extends Equatable {}

class FeedVentilationFormBlocStateInit extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocStateNoDevice extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocStateLoaded extends FeedVentilationFormBlocState {
  final bool noDevice;
  final Box box;

  late final Param temperature;
  late final Param humidity;

  final MinMaxParamsController? minMaxParams;

  // legacy fields
  final LegacyParamsController? legacyParams;

  FeedVentilationFormBlocStateLoaded({
    this.noDevice = false,
    required this.box,
    required this.temperature,
    required this.humidity,
    this.minMaxParams,
    this.legacyParams,
  });

  @override
  List<Object?> get props => [
        noDevice,
        box,
        temperature,
        humidity,
        minMaxParams,
        legacyParams,
      ];
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

class FeedVentilationFormBloc extends LegacyBloc<FeedVentilationFormBlocEvent, FeedVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent args;

  Device? device;
  late Box box;

  late Param temperature;
  late Param humidity;

  MinMaxParamsController? minMaxParams;

  // Legacy fields
  LegacyParamsController? legacyParams;

  FeedVentilationFormBloc(this.args) : super(FeedVentilationFormBlocStateInit()) {
    add(FeedVentilationFormBlocEventInit());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventInit) {
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        yield FeedVentilationFormBlocStateNoDevice();
        return;
      }
      device = await db.devicesDAO.getDevice(box.device!);

      try {
        temperature = await DeviceHelper.loadBoxParam(device!, box, 'TEMP');
        humidity = await DeviceHelper.loadBoxParam(device!, box, 'HUMI');
      } catch (e) {
        yield FeedVentilationFormBlocStateNoDevice();
        return;
      }

      try {
        legacyParams = await LegacyParamsController.load(device!, box);
        yield loadedState();
      } catch (e) {
        minMaxParams = await MinMaxParamsController.load(device!, box);
        yield loadedState();
      }
    } else if (event is FeedVentilationFormBlocParamsChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      minMaxParams = event.minMaxController;
      legacyParams = event.legacyController;
      await syncParams();
      yield loadedState();
    } else if (event is FeedVentilationFormBlocEventCreate) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      yield FeedVentilationFormBlocStateLoading('Saving..');
      List<Plant> plants = await db.plantsDAO.getPlantsInBox(args.box.id);
      for (int i = 0; i < plants.length; ++i) {
        PlantSettings plantSettings = PlantSettings.fromJSON(plants[i].settings);
        if (plantSettings.dryingStart != null || plantSettings.curingStart != null) {
          continue;
        }
        await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
          type: 'FE_VENTILATION',
          feed: plants[i].feed,
          date: DateTime.now(),
          params: Value(FeedVentilationParams(
                  FeedVentilationParamsValues(
                      blowerMin: minMaxParams?.blowerMin.value,
                      blowerMax: minMaxParams?.blowerMax.value,
                      blowerRefMin: minMaxParams?.blowerRefMin.value,
                      blowerRefMax: minMaxParams?.blowerRefMax.value,
                      blowerRefSource: minMaxParams?.blowerRefSource.value,
                      blowerDay: legacyParams?.blowerDay.value,
                      blowerNight: legacyParams?.blowerNight.value),
                  FeedVentilationParamsValues(
                      blowerMin: minMaxParams?.blowerMin.initialValue,
                      blowerMax: minMaxParams?.blowerMax.initialValue,
                      blowerRefMin: minMaxParams?.blowerRefMin.initialValue,
                      blowerRefMax: minMaxParams?.blowerRefMax.initialValue,
                      blowerRefSource: minMaxParams?.blowerRefSource.initialValue,
                      blowerDay: legacyParams?.blowerDay.initialValue,
                      blowerNight: legacyParams?.blowerNight.initialValue))
              .toJSON()),
        ));
      }
      yield FeedVentilationFormBlocStateDone();
    } else if (event is FeedVentilationFormBlocEventCancelEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      yield FeedVentilationFormBlocStateLoading('Cancelling..');
      try {
        await cancelParams();
      } catch (e) {}
      yield FeedVentilationFormBlocStateDone();
    }
  }

  Future<void> syncParams() async {
    List<Future> futures = [];
    if (legacyParams != null) {
      await legacyParams!.syncParams(device!);
    } else {
      await minMaxParams!.syncParams(device!);
    }
    await Future.wait(futures);
  }

  Future<void> cancelParams() async {
    List<Future> futures = [];
    if (legacyParams != null) {
      await legacyParams!.cancelParams(device!);
    } else {
      await minMaxParams!.cancelParams(device!);
    }
    await Future.wait(futures);
  }

  FeedVentilationFormBlocStateLoaded loadedState() => FeedVentilationFormBlocStateLoaded(
        box: box,
        temperature: temperature,
        humidity: humidity,
        minMaxParams: minMaxParams,
        legacyParams: legacyParams,
      );
}
