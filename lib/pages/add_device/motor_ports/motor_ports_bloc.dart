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

import 'package:super_green_app/data/api/device/device_config.dart';
import 'package:super_green_app/data/api/device/device_params.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class MotorSourceParamsController extends ParamsController {
  final int index;

  MotorSourceParamsController({required this.index, Map<String, ParamController>? params}) : super(params: params ?? {});

  ParamController get source => params['source']!;

  static Future<MotorSourceParamsController> load(Device device, String key, int index) async {
    MotorSourceParamsController c = MotorSourceParamsController(index: index);
    await c.loadParam(device, key, 'source');
    return c;
  }

  @override
  ParamsController copyWith({Map<String, ParamController>? params}) => MotorSourceParamsController(index: this.index, params: params ?? this.params);
}

abstract class MotorPortBlocEvent extends Equatable {}

class MotorPortBlocEventInit extends MotorPortBlocEvent {
  MotorPortBlocEventInit() : super();

  @override
  List<Object> get props => [];
}

class MotorPortBlocEventUpdated extends MotorPortBlocEvent {
  MotorPortBlocEventUpdated() : super();

  @override
  List<Object> get props => [];
}

class MotorPortBlocEventSourceUpdated extends MotorPortBlocEvent {
  final MotorSourceParamsController source;

  MotorPortBlocEventSourceUpdated(this.source) : super();

  @override
  List<Object> get props => [source];
}

abstract class MotorPortBlocState extends Equatable {}

class MotorPortBlocStateInit extends MotorPortBlocState {
  MotorPortBlocStateInit() : super();

  @override
  List<Object> get props => [];
}

class MotorPortBlocStateLoaded extends MotorPortBlocState {
  final List<int> values;
  final List<String> helpers;
  final List<MotorSourceParamsController> sources;

  MotorPortBlocStateLoaded(this.values, this.helpers, this.sources) : super();
  
  @override
  List<Object?> get props => [values, helpers, sources];
}

class MotorPortBlocStateMissingConfig extends MotorPortBlocState {
  final Device device;

  MotorPortBlocStateMissingConfig(this.device) : super();

  @override
  List<Object> get props => [device];
}

class MotorPortBlocStateDone extends MotorPortBlocState {
  MotorPortBlocStateDone() : super();

  @override
  List<Object> get props => [];
}

class MotorPortBloc extends LegacyBloc<MotorPortBlocEvent, MotorPortBlocState> {
  //ignore: unused_field
  final MainNavigateToMotorPortEvent args;

  StreamSubscription<Device>? deviceStream;
  late Device device;
  late Config? config;

  late List<MotorSourceParamsController> sources;
  late List<int> values;
  late List<String> helpers;

  MotorPortBloc(this.args) : super(MotorPortBlocStateInit()) {
    this.add(MotorPortBlocEventInit());
  }

  @override
  Stream<MotorPortBlocState> mapEventToState(MotorPortBlocEvent event) async* {
    if (event is MotorPortBlocEventInit) {
      final ddb = RelDB.get().devicesDAO;
      deviceStream = ddb.watchDevice(args.device.id).listen(_onDeviceUpdated);
    } if (event is MotorPortBlocEventUpdated) {
      if (config == null) {
        yield MotorPortBlocStateMissingConfig(device);
        return;
      }
      sources = [];
      for (var k in config!.keys) {
        int i = config!.keys.indexOf(k);
        if (k.array != null && k.array!.name == 'motor' && k.array!.param == 'source') {
          values = k.indir!.values;
          helpers = k.indir!.helpers;
          sources.add(await MotorSourceParamsController.load(device, k.capsName, i));
        }
      }
      yield MotorPortBlocStateLoaded(values, helpers, sources);
    } else if (event is MotorPortBlocEventSourceUpdated) {
      sources[event.source.index] = await event.source.syncParams(device) as MotorSourceParamsController;
      yield MotorPortBlocStateLoaded(values, helpers, sources);
    }
  }

  void _onDeviceUpdated(Device d) {
    device = d;
    if (device.config != null) {
      config = Config.fromString(device.config!);
    }
    add(MotorPortBlocEventUpdated());
  }

  @override
  Future<void> close() async {
    await deviceStream?.cancel();
    return super.close();
  }
}
