import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/models/device/device_data.dart';
import 'package:super_green_app/models/device/module_data.dart';
import 'package:super_green_app/models/device/param_data.dart';
import 'package:super_green_app/storage/app_db.dart';
import 'package:super_green_app/storage/device/device_db.dart';

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
  final DeviceData deviceData;
  DeviceSetupBlocStateDone(this.deviceData);

  @override
  List<Object> get props => [deviceData];
}

class DeviceSetupBloc extends Bloc<DeviceSetupBlocEvent, DeviceSetupBlocState> {
  DeviceData _deviceData;

  @override
  DeviceSetupBlocState get initialState => DeviceSetupBlocStateIdle();

  DeviceSetupBloc(this._deviceData) {
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

    final ip = _deviceData.ip;
    final deviceName = await KVDevice.fetchStringParam(ip, "DEVICE_NAME");
    final deviceId = await KVDevice.fetchStringParam(ip, "BROKER_CLIENTID");
    final mdnsDomain = await KVDevice.fetchStringParam(ip, "MDNS_DOMAIN");
    final config = await KVDevice.fetchConfig(ip);
    final keys = json.decode(config);

    final deviceData = DeviceData(deviceId, deviceName, config, ip, mdnsDomain);
    final Map<String, ModuleData> modules = Map();
    final List<ParamData> params = List();

    for (Map<String, dynamic> k in keys['keys']) {
      var moduleName = k['module'];
      if (modules.containsKey(moduleName) == false) {
        modules[moduleName] =
            ModuleData(deviceId, moduleName, k.containsKey('array'));
      }
      var moduleData = modules[moduleName];
      if (moduleData.isArray) {
        if (moduleData.params.contains(k['array']['param']) == false) {
          moduleData.params.add(k['array']['param']);
        }
      } else {
        moduleData.params.add(k['name']);
      }
      var paramData = ParamData(deviceId, moduleName, k['name'], k['type'] == 'integer' ? ParamType.INTEGER : ParamType.STRING);
      if (paramData.type == ParamType.INTEGER) {
        paramData.intValue = await KVDevice.fetchIntParam(ip, paramData.key);
      } else {
        paramData.stringValue = await KVDevice.fetchStringParam(ip, paramData.key);
      }
      params.add(paramData);
    }

    AppDB appDB = AppDB();
    await appDB.init();
    DeviceDB deviceDB = DeviceDB(deviceId);
    await deviceDB.init();

    appDB.addDevice(deviceData);
    deviceDB.setModules(modules.values.toList());
    deviceDB.setParams(params);

    yield DeviceSetupBlocStateDone(deviceData);
  }
}
