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
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class ParamController extends Equatable {
  final Param? param;
  final int value;
  final int initialValue;

  int get ivalue => param!.ivalue!;

  bool get isChanged => value != initialValue;

  final bool available;

  ParamController(this.param, this.value, this.initialValue, this.available);

  ParamController copyWith({Param? param, int? value, int? initialValue, bool? available}) => ParamController(
      param ?? this.param, value ?? this.value, initialValue ?? this.initialValue, available ?? this.available);

  Future<ParamController> refreshParam(Device device) async {
    Param param = await DeviceHelper.refreshIntParam(device, this.param!);
    return this.copyWith(param: param, value: param.ivalue, initialValue: param.ivalue);
  }

  Future<ParamController> syncParam(Device device) async {
    if (value != param!.ivalue) {
      Param p = await DeviceHelper.updateIntParam(device, param!, value);
      return this.copyWith(param: p, value: p.ivalue, initialValue: param!.ivalue);
    }
    return this;
  }

  Future<ParamController> cancelParam(Device device) async {
    if (initialValue != param!.ivalue) {
      Param p = await DeviceHelper.updateIntParam(device, param!, initialValue);
      return this.copyWith(param: p, value: p.ivalue);
    }
    return this;
  }

  StreamSubscription<Param> listenParam(Device device, void Function(Param?) fn) {
    return RelDB.get().devicesDAO.watchParam(device.id, param!.key).listen(fn);
  }

  static Future<ParamController> loadFromDB(Device device, String key) async {
    try {
      Param p = await RelDB.get().devicesDAO.getParam(device.id, key);
      return ParamController(p, p.ivalue!, p.ivalue!, true);
    } catch (e) {
      return ParamController(null, 0, 0, false);
    }
  }

  @override
  List<Object?> get props => [param, value, initialValue];
}

abstract class ParamsController extends Equatable {
  final Map<String, ParamController> params;

  ParamsController({required this.params});

  bool isAvailable() {
    for(ParamController p in params.values) {
      if (!p.available) {
        return false;
      }
    }
    return true;
  }

  Future<ParamController> loadParam(Device device, String key, name) async {
    ParamController pc = await ParamController.loadFromDB(device, key);
    params[name] = pc;
    return pc;
  }

  Future<ParamController> loadBoxParam(Device device, Box box, String key, name) async {
    return this.loadParam(device, "BOX_${box.deviceBox}_$key", name);
  }

  List<StreamSubscription<Param>> listenParams(Device device, void Function(ParamsController) fn) {
    List<StreamSubscription<Param>> subscriptions = [];
    params.keys.forEach((String key) {
      ParamController p = params[key]!;
      if (!p.available) {
        return;
      }
      subscriptions.add(p.listenParam(device, (p0) {
        if (p0!.ivalue == p.ivalue) {
          return;
        }
        p = p.copyWith(param: p0, value: p0.ivalue);
        params[key] = p;
        fn(this.copyWith(params: {...this.params}));
      }));
    });
    return subscriptions;
  }

  Future<ParamsController> refreshParams(Device device) async {
    Map<String, ParamController> p = {};
    await Future.wait(params.keys.where((k) => params[k]!.available).map<Future>((String key) async {
      p[key] = await params[key]!.refreshParam(device);
    }).toList());
    return this.copyWith(params: p);
  }

  Future<ParamsController> syncParams(Device device) async {
    Map<String, ParamController> p = {};
    await Future.wait(params.keys.where((k) => params[k]!.available).map<Future>((String key) async {
      p[key] = await params[key]!.syncParam(device);
    }).toList());
    return this.copyWith(params: p);
  }

  Future<ParamsController> cancelParams(Device device) async {
    Map<String, ParamController> p = {};
    await Future.wait(params.keys.where((k) => params[k]!.available).map<Future>((String key) async {
      p[key] = await params[key]!.cancelParam(device);
    }).toList());
    return this.copyWith(params: p);
  }

  Future closeSubscriptions(List<StreamSubscription<Param>> subscriptions) async {
    await Future.wait(subscriptions.map<Future>((s) => s.cancel()));
  }

  ParamsController copyWithValues(Map<String, int> values) {
    Map<String, ParamController> p = {...params};
    values.forEach((key, value) {
      p[key] = params[key]!.copyWith(value: value);
    });
    return this.copyWith(params: p);
  }

  bool isChanged() => params.values.any((p) => p.isChanged);

  ParamsController copyWith({Map<String, ParamController>? params});

  @override
  List<Object?> get props => [...params.values];
}
