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

abstract class FeedVentilationParamsController extends ParamsController {
  FeedVentilationParamsController({required Map<String, ParamController> params}) : super(params: params);

  FeedVentilationParamsController copyWith({Map<String, ParamController>? params});

  FeedVentilationParams toCardParams();
}

abstract class VentilationParamsController extends FeedVentilationParamsController {
  VentilationParamsController({required Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get min;
  ParamController get max;
  ParamController get refMin;
  ParamController get refMax;
  ParamController get refSource;
}

class FanParamsController extends VentilationParamsController {
  FanParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get min => params['min']!;
  ParamController get max => params['max']!;
  ParamController get refMin => params['refMin']!;
  ParamController get refMax => params['refMax']!;
  ParamController get refSource => params['refSource']!;

  static Future<FanParamsController> load(Device device, Box box) async {
    FanParamsController c = FanParamsController();
    await c.loadBoxParam(device, box, 'FAN_MIN', 'min');
    await c.loadBoxParam(device, box, 'FAN_MAX', 'max');
    await c.loadBoxParam(device, box, 'FAN_REF_MIN', 'refMin');
    await c.loadBoxParam(device, box, 'FAN_REF_MAX', 'refMax');
    await c.loadBoxParam(device, box, 'FAN_REF_SOURCE', 'refSource');
    return c;
  }

  FeedVentilationParamsController copyWith({Map<String, ParamController>? params}) =>
      FanParamsController(params: params ?? this.params);

  @override
  FeedVentilationParams toCardParams() {
    return FeedVentilationParams(
        FeedVentilationParamsValues(
          fanMin: min.value,
          fanMax: max.value,
          fanRefMin: refMin.value,
          fanRefMax: refMax.value,
          fanRefSource: refSource.value,
        ),
        FeedVentilationParamsValues(
          fanMin: min.initialValue,
          fanMax: max.initialValue,
          fanRefMin: refMin.initialValue,
          fanRefMax: refMax.initialValue,
          fanRefSource: refSource.initialValue,
        ));
  }
}

class BlowerParamsController extends VentilationParamsController {
  BlowerParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get min => params['min']!;
  ParamController get max => params['max']!;
  ParamController get refMin => params['refMin']!;
  ParamController get refMax => params['refMax']!;
  ParamController get refSource => params['refSource']!;

  static Future<BlowerParamsController> load(Device device, Box box) async {
    BlowerParamsController c = BlowerParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_MIN', 'min');
    await c.loadBoxParam(device, box, 'BLOWER_MAX', 'max');
    await c.loadBoxParam(device, box, 'BLOWER_REF_MIN', 'refMin');
    await c.loadBoxParam(device, box, 'BLOWER_REF_MAX', 'refMax');
    await c.loadBoxParam(device, box, 'BLOWER_REF_SOURCE', 'refSource');
    return c;
  }

  FeedVentilationParamsController copyWith({Map<String, ParamController>? params}) =>
      BlowerParamsController(params: params ?? this.params);

  @override
  FeedVentilationParams toCardParams() {
    return FeedVentilationParams(
        FeedVentilationParamsValues(
          blowerMin: min.value,
          blowerMax: max.value,
          blowerRefMin: refMin.value,
          blowerRefMax: refMax.value,
          blowerRefSource: refSource.value,
        ),
        FeedVentilationParamsValues(
          blowerMin: min.initialValue,
          blowerMax: max.initialValue,
          blowerRefMin: refMin.initialValue,
          blowerRefMax: refMax.initialValue,
          blowerRefSource: refSource.initialValue,
        ));
  }
}

class LegacyBlowerParamsController extends FeedVentilationParamsController {
  LegacyBlowerParamsController({Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get blowerDay => params['blowerDay']!;
  ParamController get blowerNight => params['blowerNight']!;

  static Future<LegacyBlowerParamsController> load(Device device, Box box) async {
    LegacyBlowerParamsController c = LegacyBlowerParamsController();
    await c.loadBoxParam(device, box, 'BLOWER_DAY', 'blowerDay');
    await c.loadBoxParam(device, box, 'BLOWER_NIGHT', 'blowerNight');
    return c;
  }

  FeedVentilationParamsController copyWith({Map<String, ParamController>? params}) =>
      LegacyBlowerParamsController(params: params ?? this.params);

  @override
  FeedVentilationParams toCardParams() {
    return FeedVentilationParams(
        FeedVentilationParamsValues(
          blowerDay: blowerDay.value,
          blowerNight: blowerNight.value,
        ),
        FeedVentilationParamsValues(
          blowerDay: blowerDay.initialValue,
          blowerNight: blowerNight.initialValue,
        ));
  }
}

abstract class FeedVentilationFormBlocEvent extends Equatable {}

class FeedVentilationFormBlocEventInit extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventInit();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocEventUpdate extends FeedVentilationFormBlocEvent {
  final int rand = Random().nextInt(1000000000);

  FeedVentilationFormBlocEventUpdate();

  @override
  List<Object> get props => [rand];
}

class FeedVentilationFormBlocEventCreate extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventCreate();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocParamsChangedEvent extends FeedVentilationFormBlocEvent {
  final FeedVentilationParamsController paramsController;

  FeedVentilationFormBlocParamsChangedEvent({
    required this.paramsController,
  });

  @override
  List<Object?> get props => [paramsController];
}

class FeedVentilationFormBlocEventCancelEvent extends FeedVentilationFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocFanModeEvent extends FeedVentilationFormBlocEvent {
  final bool savePrevious;

  FeedVentilationFormBlocFanModeEvent(this.savePrevious);

  @override
  List<Object> get props => [savePrevious];
}

class FeedVentilationFormBlocBlowerModeEvent extends FeedVentilationFormBlocEvent {
  final bool savePrevious;

  FeedVentilationFormBlocBlowerModeEvent(this.savePrevious);

  @override
  List<Object> get props => [savePrevious];
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
  final Device? device;
  final Box box;

  late final Param temperature;
  late final Param humidity;

  final FeedVentilationParamsController paramsController;

  final int rand = Random().nextInt(1000000000);

  FeedVentilationFormBlocStateLoaded({
    this.device,
    required this.box,
    required this.temperature,
    required this.humidity,
    required this.paramsController,
  });

  @override
  List<Object?> get props => [
        device,
        box,
        temperature,
        humidity,
        paramsController,
        rand,
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

  late Device device;
  late Box box;

  late Param temperature;
  late StreamSubscription<Param> temperatureListener;
  late Param humidity;
  late StreamSubscription<Param> humidityListener;

  late FeedVentilationParamsController paramsController;
  late List<StreamSubscription<Param>> paramsControllerListeners;

  FeedVentilationFormBloc(this.args) : super(FeedVentilationFormBlocStateInit()) {
    add(FeedVentilationFormBlocEventInit());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventInit) {
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(args.box.id);
      device = await db.devicesDAO.getDevice(box.device!);

      temperature = await DeviceHelper.loadBoxParam(device, box, 'TEMP', asyncRefresh: true);
      humidity = await DeviceHelper.loadBoxParam(device, box, 'HUMI', asyncRefresh: true);

      try {
        paramsController = await LegacyBlowerParamsController.load(device, box);
      } catch (e) {
        paramsController = await BlowerParamsController.load(device, box);        
      }
      paramsController.refreshParams(device); // no await
      yield loadedState();
      paramsControllerListeners = paramsController.listenParams(device, onParamsChange);
      temperatureListener = RelDB.get().devicesDAO.watchParam(device.id, temperature.key).listen(onTemperatureChange);
      humidityListener = RelDB.get().devicesDAO.watchParam(device.id, humidity.key).listen(onHumidityChange);
    } else if (event is FeedVentilationFormBlocParamsChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      paramsController = event.paramsController;
      try {
        await syncParams();
      } catch (e, trace) {
        Logger.logError(e, trace);
      }

      yield loadedState();
    } else if (event is FeedVentilationFormBlocEventCreate) {
      yield* saveParamsController();
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
    } else if (event is FeedVentilationFormBlocBlowerModeEvent) {
      if (event.savePrevious) {
        yield* saveParamsController();
      } else if (paramsController.isChanged()) {
        try {
          await cancelParams();
        } catch (e) {}
      }
      paramsController = await BlowerParamsController.load(device, box);
      yield loadedState();
    } else if (event is FeedVentilationFormBlocFanModeEvent) {
      if (event.savePrevious) {
        yield* saveParamsController();
      } else if (paramsController.isChanged()) {
        try {
          await cancelParams();
        } catch (e) {}
      }
      paramsController = await FanParamsController.load(device, box);
      yield loadedState();
    } else if (event is FeedVentilationFormBlocEventUpdate) {
      yield loadedState();
    }
  }

  Future<void> syncParams() async {
    paramsController = await paramsController.syncParams(device) as FeedVentilationParamsController;
  }

  Future<void> cancelParams() async {
    paramsController = await paramsController.cancelParams(device) as FeedVentilationParamsController;
  }

  void onTemperatureChange(Param temperature) {
    if (this.temperature.ivalue == temperature.ivalue) {
      return;
    }
    this.temperature = temperature;
    this.add(FeedVentilationFormBlocEventUpdate());
  }

  void onHumidityChange(Param humidity) {
    if (this.humidity.ivalue == humidity.ivalue) {
      return;
    }
    this.humidity = humidity;
    this.add(FeedVentilationFormBlocEventUpdate());
  }

  void onParamsChange(ParamsController paramsController) {
    this.paramsController = paramsController as FeedVentilationParamsController;
    this.add(FeedVentilationFormBlocEventUpdate());
  }

  Stream<FeedVentilationFormBlocState> saveParamsController() async* {
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
        params: Value(paramsController.toCardParams().toJSON()),
      ));
    }
  }

  @override
  Future<void> close() async {
    if (humidityListener != null) {
      await humidityListener.cancel();
    }
    if (temperatureListener != null) {
      await temperatureListener.cancel();
    }
    if (paramsController != null) {
      await paramsController.closeSubscriptions(paramsControllerListeners);
    }
    return super.close();
  }

  FeedVentilationFormBlocStateLoaded loadedState() => FeedVentilationFormBlocStateLoaded(
        device: device,
        box: box,
        temperature: temperature,
        humidity: humidity,
        paramsController: paramsController,
      );

  
}
