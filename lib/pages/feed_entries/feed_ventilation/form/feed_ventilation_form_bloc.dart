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

class IntControllerParam extends Equatable {
  final Param? _param;
  final int value;
  final int initialValue;

  bool get isChanged => value != initialValue;

  IntControllerParam(this._param, this.value, this.initialValue);

  IntControllerParam copyWith({Param? param, int? value, int? initialValue}) =>
      IntControllerParam(param ?? this._param, value ?? this.value, initialValue ?? this.initialValue);

  Future<IntControllerParam> _syncParam(Device device) async {
    if (value != _param!.ivalue) {
      Param param = await DeviceHelper.updateIntParam(device, _param!, value);
      return this.copyWith(param: param, value: param.ivalue);
    }
    return this;
  }

  Future<IntControllerParam> _cancelParam(Device device) async {
    if (initialValue != _param!.ivalue) {
      Param param = await DeviceHelper.updateIntParam(device, _param!, initialValue);
      return this.copyWith(param: param);
    }
    return this;
  }

  static Future<IntControllerParam> loadFromDB(Device device, Box box, String key) async {
    Param param = await RelDB.get().devicesDAO.getParam(device.id, "BOX_${box.deviceBox}_$key");
    return IntControllerParam(param, param.ivalue!, param.ivalue!);
  }

  @override
  List<Object?> get props => [_param, value, initialValue];
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
  final IntControllerParam? blowerMin;
  final IntControllerParam? blowerMax;
  final IntControllerParam? blowerRefMin;
  final IntControllerParam? blowerRefMax;
  final IntControllerParam? blowerRefSource;

  // legacy fields
  final IntControllerParam? blowerDay;
  final IntControllerParam? blowerNight;

  FeedVentilationFormBlocParamsChangedEvent({
    this.blowerMin,
    this.blowerMax,
    this.blowerRefMin,
    this.blowerRefMax,
    this.blowerRefSource,
    this.blowerDay,
    this.blowerNight,
  });

  @override
  List<Object?> get props =>
      [blowerMin, blowerMax, blowerRefMin, blowerRefMax, blowerRefSource, blowerDay, blowerNight];
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

class FeedVentilationFormBlocStateLoaded extends FeedVentilationFormBlocState {
  final bool noDevice;
  final Box box;

  late final IntControllerParam temperature;
  late final IntControllerParam humidity;

  late final bool isLegacy;
  final IntControllerParam? blowerMin;
  final IntControllerParam? blowerMax;
  final IntControllerParam? blowerRefMin;
  final IntControllerParam? blowerRefMax;
  final IntControllerParam? blowerRefSource;

  // legacy fields
  final IntControllerParam? blowerDay;
  final IntControllerParam? blowerNight;

  FeedVentilationFormBlocStateLoaded({
    this.noDevice = false,
    required this.box,
    required this.temperature,
    required this.humidity,
    required this.isLegacy,
    this.blowerMin,
    this.blowerMax,
    this.blowerRefMin,
    this.blowerRefMax,
    this.blowerRefSource,
    this.blowerDay,
    this.blowerNight,
  });

  @override
  List<Object?> get props => [
        noDevice,
        box,
        temperature,
        humidity,
        isLegacy,
        blowerMin,
        blowerMax,
        blowerRefMin,
        blowerRefMax,
        blowerRefSource,
        blowerDay,
        blowerNight,
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

  late IntControllerParam temperature;
  late IntControllerParam humidity;

  late bool isLegacy;
  IntControllerParam? blowerMin;
  IntControllerParam? blowerMax;
  IntControllerParam? blowerRefMin;
  IntControllerParam? blowerRefMax;
  IntControllerParam? blowerRefSource;

  // Legacy fields
  IntControllerParam? blowerDay;
  IntControllerParam? blowerNight;

  FeedVentilationFormBloc(this.args) : super(FeedVentilationFormBlocStateInit()) {
    add(FeedVentilationFormBlocEventInit());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventInit) {
      final db = RelDB.get();
      box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        yield FeedVentilationFormBlocStateLoaded(
            noDevice: true,
            isLegacy: false,
            blowerMin: IntControllerParam(null, 5, 5),
            blowerMax: IntControllerParam(null, 40, 40),
            blowerRefMin: IntControllerParam(null, 20, 20),
            blowerRefMax: IntControllerParam(null, 32, 32),
            blowerRefSource: IntControllerParam(null, 1, 1),
            temperature: IntControllerParam(null, 25, 25),
            humidity: IntControllerParam(null, 25, 25),
            box: box);
        return;
      }
      device = await db.devicesDAO.getDevice(box.device!);

      try {
        temperature = await IntControllerParam.loadFromDB(device!, box, "TEMP");
        temperature = temperature.copyWith(param: await DeviceHelper.refreshIntParam(device!, temperature._param!));

        humidity = await IntControllerParam.loadFromDB(device!, box, "HUMI");
        humidity = humidity.copyWith(param: await DeviceHelper.refreshIntParam(device!, humidity._param!));
      } catch (e) {
        yield FeedVentilationFormBlocStateLoaded(
            noDevice: false,
            isLegacy: false,
            blowerMin: IntControllerParam(null, 5, 5),
            blowerMax: IntControllerParam(null, 40, 40),
            blowerRefMin: IntControllerParam(null, 20, 20),
            blowerRefMax: IntControllerParam(null, 32, 32),
            blowerRefSource: IntControllerParam(null, 1, 1),
            temperature: IntControllerParam(null, 25, 25),
            humidity: IntControllerParam(null, 25, 25),
            box: box);
        return;
      }

      try {
        isLegacy = true;
        blowerDay = await IntControllerParam.loadFromDB(device!, box, "BLOWER_DAY");
        blowerNight = await IntControllerParam.loadFromDB(device!, box, "BLOWER_NIGHT");
        yield loadedState();
      } catch (e) {
        isLegacy = false;
        blowerMin = await IntControllerParam.loadFromDB(device!, box, "BLOWER_MIN");
        blowerMax = await IntControllerParam.loadFromDB(device!, box, "BLOWER_MAX");
        blowerRefMin = await IntControllerParam.loadFromDB(device!, box, "BLOWER_REF_MIN");
        blowerRefMax = await IntControllerParam.loadFromDB(device!, box, "BLOWER_REF_MAX");
        blowerRefSource = await IntControllerParam.loadFromDB(device!, box, "BLOWER_REF_SOURCE");
        yield loadedState();
      }
    } else if (event is FeedVentilationFormBlocParamsChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      blowerMin = event.blowerMin ?? blowerMin;
      blowerMax = event.blowerMax ?? blowerMax;
      blowerRefMin = event.blowerRefMin ?? blowerRefMin;
      blowerRefMax = event.blowerRefMax ?? blowerRefMax;
      blowerRefSource = event.blowerRefSource ?? blowerRefSource;
      blowerDay = event.blowerDay ?? blowerDay;
      blowerNight = event.blowerNight ?? blowerNight;
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
                      blowerMin: blowerMin?.value,
                      blowerMax: blowerMax?.value,
                      blowerRefMin: blowerRefMin?.value,
                      blowerRefMax: blowerRefMax?.value,
                      blowerRefSource: blowerRefSource?.value,
                      blowerDay: blowerDay?.value,
                      blowerNight: blowerNight?.value),
                  FeedVentilationParamsValues(
                      blowerMin: blowerMin?.initialValue,
                      blowerMax: blowerMax?.initialValue,
                      blowerRefMin: blowerRefMin?.initialValue,
                      blowerRefMax: blowerRefMax?.initialValue,
                      blowerRefSource: blowerRefSource?.initialValue,
                      blowerDay: blowerDay?.initialValue,
                      blowerNight: blowerNight?.initialValue))
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
    if (isLegacy) {
      futures = [
        (() async {
          blowerDay = await blowerDay!._syncParam(device!);
        }()),
        (() async {
          blowerNight = await blowerNight!._syncParam(device!);
        }()),
      ];
    } else {
      futures = [
        (() async {
          blowerMin = await blowerMin!._syncParam(device!);
        }()),
        (() async {
          blowerMax = await blowerMax!._syncParam(device!);
        }()),
        (() async {
          blowerRefMin = await blowerRefMin!._syncParam(device!);
        }()),
        (() async {
          blowerRefMax = await blowerRefMax!._syncParam(device!);
        }()),
        (() async {
          blowerRefSource = await blowerRefSource!._syncParam(device!);
        }()),
      ];
    }
    await Future.wait(futures);
  }

  Future<void> cancelParams() async {
    List<Future> futures = [];
    if (isLegacy) {
      futures = [
        (() async {
          blowerDay = await blowerDay!._cancelParam(device!);
        }()),
        (() async {
          blowerNight = await blowerNight!._cancelParam(device!);
        }()),
      ];
    } else {
      futures = [
        (() async {
          blowerMin = await blowerMin!._cancelParam(device!);
        }()),
        (() async {
          blowerMax = await blowerMax!._cancelParam(device!);
        }()),
        (() async {
          blowerRefMin = await blowerRefMin!._cancelParam(device!);
        }()),
        (() async {
          blowerRefMax = await blowerRefMax!._cancelParam(device!);
        }()),
        (() async {
          blowerRefSource = await blowerRefSource!._cancelParam(device!);
        }()),
      ];
    }
    await Future.wait(futures);
  }

  FeedVentilationFormBlocStateLoaded loadedState() => FeedVentilationFormBlocStateLoaded(
        box: box,
        temperature: temperature,
        humidity: humidity,
        isLegacy: isLegacy,
        blowerMin: blowerMin,
        blowerMax: blowerMax,
        blowerRefMin: blowerRefMin,
        blowerRefMax: blowerRefMax,
        blowerRefSource: blowerRefSource,
        blowerDay: blowerDay,
        blowerNight: blowerNight,
      );
}
