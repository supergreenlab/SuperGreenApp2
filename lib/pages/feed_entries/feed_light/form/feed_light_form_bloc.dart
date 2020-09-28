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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_light.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';
import 'package:wifi_iot/wifi_iot.dart';

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
  final List<int> values;

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

class FeedLightFormBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedLightFormBlocStateLightsLoaded extends FeedLightFormBlocState {
  final List<int> values;
  final Box box;

  FeedLightFormBlocStateLightsLoaded(this.values, this.box);

  @override
  List<Object> get props => [values, box];
}

class FeedLightFormBlocStateNoDevice
    extends FeedLightFormBlocStateLightsLoaded {
  FeedLightFormBlocStateNoDevice(List<int> values, Box box)
      : super(values, box);
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
  final Plant plant;
  final FeedEntry feedEntry;

  FeedLightFormBlocStateDone(this.plant, this.feedEntry);

  @override
  List<Object> get props => [];
}

class FeedLightFormBloc
    extends Bloc<FeedLightFormBlocEvent, FeedLightFormBlocState> {
  final MainNavigateToFeedLightFormEvent args;

  Device device;
  List<Param> lightParams;
  List<int> initialValues;

  FeedLightFormBloc(this.args) : super(FeedLightFormBlocState()) {
    add(FeedLightFormBlocEventLoadLights());
  }

  @override
  Stream<FeedLightFormBlocState> mapEventToState(
      FeedLightFormBlocEvent event) async* {
    if (event is FeedLightFormBlocEventLoadLights) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        yield FeedLightFormBlocStateNoDevice([45, 45, 65, 65], box);
        return;
      }
      device = await db.devicesDAO.getDevice(box.device);
      Module lightModule = await db.devicesDAO.getModule(device.id, "led");
      lightParams = [];
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param boxParam =
            await db.devicesDAO.getParam(device.id, "LED_${i}_BOX");
        if (boxParam.ivalue == box.deviceBox) {
          lightParams
              .add(await db.devicesDAO.getParam(device.id, "LED_${i}_DIM"));
        }
      }
      List<int> values = lightParams.map((l) => l.ivalue).toList();
      initialValues = values;
      yield FeedLightFormBlocStateLightsLoaded(values, box);
    } else if (event is FeedLightFormBlocValueChangedEvent) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        return;
      }
      try {
        await DeviceHelper.updateIntParam(
            device, lightParams[event.i], (event.value).toInt());
      } catch (e) {
        Logger.log(e);
      }
    } else if (event is FeedLightFormBlocEventCreate) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        return;
      }
      yield FeedLightFormBlocStateLoading();
      List<Plant> plants = await db.plantsDAO.getPlantsInBox(args.plant.box);
      FeedEntry feedEntry;
      for (int i = 0; i < plants.length; ++i) {
        PlantSettings plantSettings =
            PlantSettings.fromJSON(plants[i].settings);
        if (plantSettings.dryingStart != null ||
            plantSettings.curingStart != null) {
          continue;
        }
        int feedEntryID =
            await FeedEntryHelper.addFeedEntry(FeedEntriesCompanion.insert(
          type: 'FE_LIGHT',
          feed: plants[i].feed,
          date: DateTime.now(),
          params: Value(FeedLightParams(event.values, initialValues).toJSON()),
        ));
        if (i == 0) {
          feedEntry = await db.feedsDAO.getFeedEntry(feedEntryID);
        }
      }
      yield FeedLightFormBlocStateDone(args.plant, feedEntry);
    } else if (event is FeedLightFormBlocEventCancel) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      if (box.device == null) {
        yield FeedLightFormBlocStateDone(args.plant, null);
        return;
      }
      yield FeedLightFormBlocStateCancelling();
      for (int i = 0; i < lightParams.length; ++i) {
        try {
          await DeviceHelper.updateIntParam(
              device, lightParams[i], initialValues[i]);
        } catch (e) {
          Logger.log(e);
          return;
        }
      }
      yield FeedLightFormBlocStateDone(args.plant, null);
    }
  }
}
