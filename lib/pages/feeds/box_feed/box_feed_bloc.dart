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
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

abstract class BoxFeedBlocEvent extends Equatable {}

class BoxFeedBlocEventLoadBox extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocEventReloadChart extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocEventBoxUpdated extends BoxFeedBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  BoxFeedBlocEventBoxUpdated();

  @override
  List<Object> get props => [rand];
}

class BoxFeedBlocEventSunglasses extends BoxFeedBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  @override
  List<Object> get props => [rand];
}

abstract class BoxFeedBlocState extends Equatable {}

class BoxFeedBlocStateInit extends BoxFeedBlocState {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateNoBox extends BoxFeedBlocState {
  BoxFeedBlocStateNoBox() : super();

  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateBoxLoaded extends BoxFeedBlocState {
  final Plant box;
  final int nTimelapses;

  BoxFeedBlocStateBoxLoaded(this.box, this.nTimelapses);

  @override
  List<Object> get props => [box, nTimelapses];
}

class BoxFeedBloc extends Bloc<BoxFeedBlocEvent, BoxFeedBlocState> {
  final HomeNavigateToBoxFeedEvent _args;

  Plant _plant;
  int _nTimelapses;

  BoxFeedBloc(this._args) {
    this.add(BoxFeedBlocEventLoadBox());
  }

  @override
  BoxFeedBlocState get initialState => BoxFeedBlocStateInit();

  @override
  Stream<BoxFeedBlocState> mapEventToState(BoxFeedBlocEvent event) async* {
    if (event is BoxFeedBlocEventLoadBox) {
      AppDB _db = AppDB();
      _plant = _args.box;
      if (_plant == null) {
        AppData appData = _db.getAppData();
        if (appData.lastBoxID == null) {
          yield BoxFeedBlocStateNoBox();
          return;
        }
        _plant = await RelDB.get().plantsDAO.getPlant(appData.lastBoxID);
      } else {
        _db.setLastBox(_plant.id);
      }

      _nTimelapses =
          await RelDB.get().plantsDAO.nTimelapses(_plant.id).getSingle();
      RelDB.get()
          .plantsDAO
          .nTimelapses(_plant.id)
          .watchSingle()
          .listen(_onNTimelapsesUpdated);
      RelDB.get().plantsDAO.watchPlant(_plant.id).listen(_onBoxUpdated);
      yield BoxFeedBlocStateBoxLoaded(_plant, _nTimelapses);
    } else if (event is BoxFeedBlocEventBoxUpdated) {
      yield BoxFeedBlocStateBoxLoaded(_plant, _nTimelapses);
    } else if (event is BoxFeedBlocEventSunglasses) {
      if (_plant.device == null) {
        return;
      }
      Device device = await RelDB.get().devicesDAO.getDevice(_plant.device);
      Param dimParam = await RelDB.get()
          .devicesDAO
          .getParam(device.id, 'BOX_${_plant.deviceBox}_LED_DIM');
      try {
        if (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 -
                dimParam.ivalue >
            1200) {
          await DeviceHelper.updateIntParam(device, dimParam,
              DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
        } else {
          await DeviceHelper.updateIntParam(device, dimParam, 0);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _onBoxUpdated(Plant box) {
    _plant = box;
    add(BoxFeedBlocEventBoxUpdated());
  }

  void _onNTimelapsesUpdated(int nTimelapses) {
    _nTimelapses = nTimelapses;
    add(BoxFeedBlocEventBoxUpdated());
  }
}
