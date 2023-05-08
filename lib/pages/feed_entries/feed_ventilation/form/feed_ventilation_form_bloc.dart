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
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_ventilation.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

// TODO ref source values from config

const int TEMP_REF_OFFSET = 0x1;
const int TIMER_REF_OFFSET = 0x8;
const int HUMI_REF_OFFSET = 0xf;

bool isTempSource(int source) => source >= TEMP_REF_OFFSET && source < TIMER_REF_OFFSET;
bool isTimerSource(int source) => source >= TIMER_REF_OFFSET && source < HUMI_REF_OFFSET;
bool isHumiSource(int source) => source >= HUMI_REF_OFFSET;

class FanParamsController extends ParamsController {
  FanParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get fanMin => params['fanMin']!;
  ParamController get fanMax => params['fanMax']!;
  ParamController get fanRefMin => params['fanRefMin']!;
  ParamController get fanRefMax => params['fanRefMax']!;
  ParamController get fanRefSource => params['fanRefSource']!;

  static Future<FanParamsController> load(Device device, Box box) async {
    FanParamsController c = FanParamsController();
    await c.loadBoxParam(device, box, 'FAN_MIN', 'fanMin');
    await c.loadBoxParam(device, box, 'FAN_MAX', 'fanMax');
    await c.loadBoxParam(device, box, 'FAN_REF_MIN', 'fanRefMin');
    await c.loadBoxParam(device, box, 'FAN_REF_MAX', 'fanRefMax');
    await c.loadBoxParam(device, box, 'FAN_REF_SOURCE', 'fanRefSource');
    return c;
  }

  ParamsController copyWith({Map<String, ParamController>? params}) =>
      FanParamsController(params: params ?? this.params);
}

class BlowerParamsController extends ParamsController {
  BlowerParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get blowerMin => params['blowerMin']!;
  ParamController get blowerMax => params['blowerMax']!;
  ParamController get blowerRefMin => params['blowerRefMin']!;
  ParamController get blowerRefMax => params['blowerRefMax']!;
  ParamController get blowerRefSource => params['blowerRefSource']!;

  static Future<BlowerParamsController> load(Device device, Box box) async {
    BlowerParamsController c = BlowerParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_MIN', 'blowerMin');
    await c.loadBoxParam(device, box, 'BLOWER_MAX', 'blowerMax');
    await c.loadBoxParam(device, box, 'BLOWER_REF_MIN', 'blowerRefMin');
    await c.loadBoxParam(device, box, 'BLOWER_REF_MAX', 'blowerRefMax');
    await c.loadBoxParam(device, box, 'BLOWER_REF_SOURCE', 'blowerRefSource');
    return c;
  }

  ParamsController copyWith({Map<String, ParamController>? params}) =>
      BlowerParamsController(params: params ?? this.params);
}

class LegacyBlowerParamsController extends ParamsController {
  LegacyBlowerParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get blowerDay => params['blowerDay']!;
  ParamController get blowerNight => params['blowerNight']!;

  static Future<LegacyBlowerParamsController> load(Device device, Box box) async {
    LegacyBlowerParamsController c = LegacyBlowerParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_DAY', 'blowerDay');
    await c.loadBoxParam(device, box, 'BLOWER_NIGHT', 'blowerNight');
    return c;
  }

  ParamsController copyWith({Map<String, ParamController>? params}) =>
      LegacyBlowerParamsController(params: params ?? this.params);
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
  final FanParamsController? fanParamsController;
  final BlowerParamsController? blowerParamsController;

  // legacy fields
  final LegacyBlowerParamsController? legacyBlowerParamsController;

  FeedVentilationFormBlocParamsChangedEvent({
    this.fanParamsController,
    this.blowerParamsController,
    this.legacyBlowerParamsController,
  });

  @override
  List<Object?> get props => [fanParamsController, blowerParamsController, legacyBlowerParamsController];
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

  final FanParamsController? fanParamsController;
  final BlowerParamsController? blowerParamsController;

  // legacy fields
  final LegacyBlowerParamsController? legacyBlowerParamsController;

  FeedVentilationFormBlocStateLoaded({
    this.noDevice = false,
    required this.box,
    required this.temperature,
    required this.humidity,
    this.fanParamsController,
    this.blowerParamsController,
    this.legacyBlowerParamsController,
  });

  @override
  List<Object?> get props => [
        noDevice,
        box,
        temperature,
        humidity,
        fanParamsController,
        blowerParamsController,
        legacyBlowerParamsController,
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

  FanParamsController? fanParamsController;
  BlowerParamsController? blowerParamsController;

  // Legacy fields
  LegacyBlowerParamsController? legacyBlowerParamsController;

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
      } catch (e, trace) {
        Logger.logError(e, trace);
        yield FeedVentilationFormBlocStateNoDevice();
        return;
      }

      try {
        legacyBlowerParamsController = await LegacyBlowerParamsController.load(device!, box);
        yield loadedState();
      } catch (e) {
        fanParamsController = await FanParamsController.load(device!, box);
        blowerParamsController = await BlowerParamsController.load(device!, box);
        yield loadedState();
      }
    } else if (event is FeedVentilationFormBlocParamsChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      fanParamsController = event.fanParamsController;
      blowerParamsController = event.blowerParamsController;
      legacyBlowerParamsController = event.legacyBlowerParamsController;
      try {
        await syncParams();
      } catch (e, trace) {
        Logger.logError(e, trace);
      }

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
                      fanMin: fanParamsController?.fanMin.value,
                      fanMax: fanParamsController?.fanMax.value,
                      fanRefMin: fanParamsController?.fanRefMin.value,
                      fanRefMax: fanParamsController?.fanRefMax.value,
                      fanRefSource: fanParamsController?.fanRefSource.value,
                      blowerMin: blowerParamsController?.blowerMin.value,
                      blowerMax: blowerParamsController?.blowerMax.value,
                      blowerRefMin: blowerParamsController?.blowerRefMin.value,
                      blowerRefMax: blowerParamsController?.blowerRefMax.value,
                      blowerRefSource: blowerParamsController?.blowerRefSource.value,
                      blowerDay: legacyBlowerParamsController?.blowerDay.value,
                      blowerNight: legacyBlowerParamsController?.blowerNight.value),
                  FeedVentilationParamsValues(
                      fanMin: fanParamsController?.fanMin.initialValue,
                      fanMax: fanParamsController?.fanMax.initialValue,
                      fanRefMin: fanParamsController?.fanRefMin.initialValue,
                      fanRefMax: fanParamsController?.fanRefMax.initialValue,
                      fanRefSource: fanParamsController?.fanRefSource.initialValue,
                      blowerMin: blowerParamsController?.blowerMin.initialValue,
                      blowerMax: blowerParamsController?.blowerMax.initialValue,
                      blowerRefMin: blowerParamsController?.blowerRefMin.initialValue,
                      blowerRefMax: blowerParamsController?.blowerRefMax.initialValue,
                      blowerRefSource: blowerParamsController?.blowerRefSource.initialValue,
                      blowerDay: legacyBlowerParamsController?.blowerDay.initialValue,
                      blowerNight: legacyBlowerParamsController?.blowerNight.initialValue))
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
    if (legacyBlowerParamsController != null) {
      legacyBlowerParamsController = await legacyBlowerParamsController!.syncParams(device!) as LegacyBlowerParamsController;
    } else {
      fanParamsController = await fanParamsController!.syncParams(device!) as FanParamsController;
      blowerParamsController = await blowerParamsController!.syncParams(device!) as BlowerParamsController;
    }
  }

  Future<void> cancelParams() async {
    if (legacyBlowerParamsController != null) {
      legacyBlowerParamsController = await legacyBlowerParamsController!.cancelParams(device!) as LegacyBlowerParamsController;
    } else {
      fanParamsController = await fanParamsController!.cancelParams(device!) as FanParamsController;
      blowerParamsController = await blowerParamsController!.cancelParams(device!) as BlowerParamsController;
    }
  }

  FeedVentilationFormBlocStateLoaded loadedState() => FeedVentilationFormBlocStateLoaded(
        box: box,
        temperature: temperature,
        humidity: humidity,
        fanParamsController: fanParamsController,
        blowerParamsController: blowerParamsController,
        legacyBlowerParamsController: legacyBlowerParamsController,
      );
}
