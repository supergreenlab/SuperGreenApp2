import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/storage/models/devices.dart';

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
  final Device device;
  DeviceSetupBlocStateDone(this.device);

  @override
  List<Object> get props => [device];
}

class DeviceSetupBloc extends Bloc<DeviceSetupBlocEvent, DeviceSetupBlocState> {
  String _ip;

  @override
  DeviceSetupBlocState get initialState => DeviceSetupBlocStateIdle();

  DeviceSetupBloc(this._ip) {
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

    final deviceName = await KVDevice.fetchStringParam(_ip, "DEVICE_NAME");
    final deviceId = await KVDevice.fetchStringParam(_ip, "BROKER_CLIENTID");
    final mdnsDomain = await KVDevice.fetchStringParam(_ip, "MDNS_DOMAIN");
    final config = await KVDevice.fetchConfig(_ip);
    final keys = json.decode(config);

    final db = DevicesDB.get();
    final device = DevicesCompanion.insert(identifier: deviceId, name: deviceName, config: config, ip: _ip, mdns: mdnsDomain);
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
        final value = await KVDevice.fetchIntParam(_ip, k['caps_name']);
        param = ParamsCompanion.insert(device: deviceID, module: modules[moduleName], key: k['caps_name'], type: type, ivalue: Value(value));
      } else {
        final value = await KVDevice.fetchStringParam(_ip, k['caps_name']);
        param = ParamsCompanion.insert(device: deviceID, module: modules[moduleName], key: k['caps_name'], type: type, svalue: Value(value));
      }
      await db.addParam(param);
    }

    final d = await db.getDevice(deviceID);
    yield DeviceSetupBlocStateDone(d);
  }
}
