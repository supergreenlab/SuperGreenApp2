import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceSetupBlocEvent extends Equatable {}

class DeviceSetupBlocEventStartSetup extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocEventReset extends DeviceSetupBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class DeviceSetupBlocState extends Equatable {}

class DeviceSetupBlocStateIdle extends DeviceSetupBlocState {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocStateOutdated extends DeviceSetupBlocState {
  @override
  List<Object> get props => [];
}

class DeviceSetupBlocStateDone extends DeviceSetupBlocState {
  final Box box;
  final Device device;
  DeviceSetupBlocStateDone(this.box, this.device);

  @override
  List<Object> get props => [device];
}

class DeviceSetupBloc extends Bloc<DeviceSetupBlocEvent, DeviceSetupBlocState> {
  final MainNavigateToDeviceSetupEvent _args;

  @override
  DeviceSetupBlocState get initialState => DeviceSetupBlocStateIdle();

  DeviceSetupBloc(this._args) {
    Future.delayed(const Duration(seconds: 1),
        () => this.add(DeviceSetupBlocEventStartSetup()));
  }

  @override
  Stream<DeviceSetupBlocState> mapEventToState(
      DeviceSetupBlocEvent event) async* {
    if (event is DeviceSetupBlocEventStartSetup) {
      yield* this._startSearch(event);
    } else if (event is DeviceSetupBlocEventReset) {
      yield DeviceSetupBlocStateIdle();
    }
  }

  Stream<DeviceSetupBlocState> _startSearch(
      DeviceSetupBlocEventStartSetup event) async* {

    final deviceName = await DeviceAPI.fetchStringParam(_args.ip, "DEVICE_NAME");
    final deviceId = await DeviceAPI.fetchStringParam(_args.ip, "BROKER_CLIENTID");
    final mdnsDomain = await DeviceAPI.fetchStringParam(_args.ip, "MDNS_DOMAIN");
    final config = await DeviceAPI.fetchConfig(_args.ip);
    final keys = json.decode(config);

    final db = RelDB.get().devicesDAO;
    final device = DevicesCompanion.insert(identifier: deviceId, name: deviceName, config: config, ip: _args.ip, mdns: mdnsDomain);
    final deviceID = await db.addDevice(device);
    final Map<String, int> modules = Map();

    for (Map<String, dynamic> k in keys['keys']) {
      var moduleName = k['module'];
      if (modules.containsKey(moduleName) == false) {
        bool isArray = k.containsKey('array');
        ModulesCompanion module = ModulesCompanion.insert(device: deviceID, name: moduleName, isArray: isArray, arrayLen: isArray ? k['array']['len'] : 0);
        final moduleID = await db.addModule(module);
        modules[moduleName] = moduleID;
      }
      int type = k['type'] == 'integer' ? INTEGER_TYPE : STRING_TYPE;
      ParamsCompanion param;
      if (type == INTEGER_TYPE) {
        final value = await DeviceAPI.fetchIntParam(_args.ip, k['caps_name']);
        param = ParamsCompanion.insert(device: deviceID, module: modules[moduleName], key: k['caps_name'], type: type, ivalue: Value(value));
      } else {
        final value = await DeviceAPI.fetchStringParam(_args.ip, k['caps_name']);
        param = ParamsCompanion.insert(device: deviceID, module: modules[moduleName], key: k['caps_name'], type: type, svalue: Value(value));
      }
      await db.addParam(param);
    }

    final d = await db.getDevice(deviceID);
    yield DeviceSetupBlocStateDone(_args.box, d);
  }
}
