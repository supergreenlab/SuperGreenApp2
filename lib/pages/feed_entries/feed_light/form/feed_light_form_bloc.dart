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

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_light.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

abstract class FeedLightFormBlocEvent extends Equatable {}

class FeedLightFormBlocEventLoadLights extends FeedLightFormBlocEvent {
  FeedLightFormBlocEventLoadLights();

  @override
  List<Object> get props => [];
}

class FeedLightFormBlocEventCancel extends FeedLightFormBlocEvent {
  FeedLightFormBlocEventCancel();

  @override
  List<Object> get props => [];
}

class FeedLightFormBlocEventCreate extends FeedLightFormBlocEvent {
  final List<BoxLight> values;

  FeedLightFormBlocEventCreate(this.values);

  @override
  List<Object> get props => [values];
}

class FeedLightFormBlocValueChangedEvent extends FeedLightFormBlocEvent {
  final int i;
  final int value;

  FeedLightFormBlocValueChangedEvent(this.i, this.value);

  @override
  List<Object> get props => [i, value];
}

class FeedLightFormBlocNameChangedEvent extends FeedLightFormBlocEvent {
  final int i;
  final String name;

  FeedLightFormBlocNameChangedEvent(this.i, this.name);

  @override
  List<Object> get props => [i, name];
}

class FeedLightFormBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedLightFormBlocStateLightsLoaded extends FeedLightFormBlocState {
  final List<BoxLight> values;
  final Box box;

  FeedLightFormBlocStateLightsLoaded(this.values, this.box);

  @override
  List<Object> get props => [values, box];
}

class FeedLightFormBlocStateLightsLoading extends FeedLightFormBlocState {
  final int index;

  FeedLightFormBlocStateLightsLoading(this.index);

  @override
  List<Object> get props => [index];
}

class FeedLightFormBlocStateNoDevice extends FeedLightFormBlocStateLightsLoaded {
  FeedLightFormBlocStateNoDevice(List<BoxLight> values, Box box) : super(values, box);
}

class FeedLightFormBlocStateLoading extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBlocStateCancelling extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBlocStateDone extends FeedLightFormBlocState {
  final FeedEntry? feedEntry;

  FeedLightFormBlocStateDone(this.feedEntry);

  @override
  List<Object?> get props => [feedEntry];
}

class BoxLight extends Equatable {
  final Param value;
  final LightSettings? lightSettings;

  BoxLight({required this.value, required this.lightSettings});

  @override
  List<Object?> get props => [value, lightSettings];

  BoxLight copyWith({Param? value, LightSettings? lightSettings}) {
    return BoxLight(value: value ?? this.value, lightSettings: lightSettings ?? this.lightSettings);
  }
}

class FeedLightFormBloc extends LegacyBloc<FeedLightFormBlocEvent, FeedLightFormBlocState> {
  final MainNavigateToFeedLightFormEvent args;

  late Device device;
  late List<Param> lightParams;
  late List<Param> initialLightParams;

  FeedLightFormBloc(this.args) : super(FeedLightFormBlocState()) {
    add(FeedLightFormBlocEventLoadLights());
  }

  @override
  Stream<FeedLightFormBlocState> mapEventToState(FeedLightFormBlocEvent event) async* {
    if (event is FeedLightFormBlocEventLoadLights) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      device = await db.devicesDAO.getDevice(box.device!);
      Module lightModule = await db.devicesDAO.getModule(device.id, "led");
      lightParams = [];
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param boxParam = await db.devicesDAO.getParam(device.id, "LED_${i}_BOX");
        if (boxParam.ivalue == box.deviceBox) {
          lightParams.add(await db.devicesDAO.getParam(device.id, "LED_${i}_DIM"));
        }
      }
      initialLightParams = lightParams;
      BoxSettings boxSettings = BoxSettings.fromJSON(box.settings);
      List<LightSettings> lightSettings = boxSettings.lightSettings ?? [];
      if (lightSettings.length < lightParams.length) {
        for (int i = 0; i < lightParams.length - lightSettings.length; ++i) {
          lightSettings.add(LightSettings());
        }
        boxSettings = boxSettings.copyWith(lightSettings: lightSettings);
        box = box.copyWith(settings: boxSettings.toJSON());
        db.plantsDAO.updateBox(box.toCompanion(true));
      }
      List<BoxLight> boxLights = [];
      for (int i = 0; i < lightParams.length; ++i) {
        boxLights.add(BoxLight(value: lightParams[i], lightSettings: lightSettings[i]));
      }
      yield FeedLightFormBlocStateLightsLoaded(boxLights, box);
    } else if (event is FeedLightFormBlocValueChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      yield FeedLightFormBlocStateLightsLoading(event.i);
      try {
        await DeviceHelper.updateIntParam(device, lightParams[event.i], (event.value).toInt());
        lightParams[event.i] = lightParams[event.i].copyWith(ivalue: Value(event.value.toInt()));
      } catch (e, trace) {
        Logger.logError(e, trace);
      }
      yield FeedLightFormBlocStateLightsLoading(-1);
    } else if (event is FeedLightFormBlocNameChangedEvent) {

    } else if (event is FeedLightFormBlocEventCreate) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        return;
      }
      yield FeedLightFormBlocStateLoading();
      List<Plant> plants = await db.plantsDAO.getPlantsInBox(args.box.id);
      FeedEntry? feedEntry;
      for (int i = 0; i < plants.length; ++i) {
        PlantSettings plantSettings = PlantSettings.fromJSON(plants[i].settings);
        if (plantSettings.dryingStart != null || plantSettings.curingStart != null) {
          continue;
        }
        List<int> values = event.values.map((l) => l.value.ivalue!).toList();
        List<int> initialValues = initialLightParams.map((l) => l.ivalue!).toList();
        int feedEntryID = await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
          type: 'FE_LIGHT',
          feed: plants[i].feed,
          date: DateTime.now(),
          params: Value(FeedLightParams(values, initialValues).toJSON()),
        ));
        if (i == 0) {
          feedEntry = await db.feedsDAO.getFeedEntry(feedEntryID);
        }
      }
      yield FeedLightFormBlocStateDone(feedEntry);
    } else if (event is FeedLightFormBlocEventCancel) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.box.id);
      if (box.device == null) {
        yield FeedLightFormBlocStateDone(null);
        return;
      }
      yield FeedLightFormBlocStateCancelling();
      List<Future> futures = [];
      for (int i = 0; i < lightParams.length; ++i) {
        futures.add(DeviceHelper.updateIntParam(device, lightParams[i], initialLightParams[i].ivalue!));
      }
      try {
        await Future.wait(futures);
      } catch (e, trace) {
        Logger.logError(e, trace);
        return;
      }
      yield FeedLightFormBlocStateDone(null);
    }
  }
}
