import 'package:hive/hive.dart';
import 'package:super_green_app/models/device/module_data.dart';
import 'package:super_green_app/models/device/param_data.dart';

class DeviceDB {
  static Map<String, DeviceDB> _instances = Map<String, DeviceDB>();

  final String deviceId;
  Box _modulesDB;
  Box _paramsDB;

  factory DeviceDB(String deviceId) {
    if (_instances.containsKey(deviceId) == false) {
      _instances[deviceId] = DeviceDB.newInstance(deviceId);
    }
    return _instances[deviceId];
  }

  DeviceDB.newInstance(this.deviceId);

  Future<void> init() async {
    _modulesDB = await Hive.openBox('modules_$deviceId');
    _paramsDB = await Hive.openBox('params_$deviceId');
  }

  void setModules(List<ModuleData> modulesData) {
    _modulesDB.clear();
    _modulesDB.addAll(modulesData);
  }

  void setParams(List<ParamData> paramsData) {
    _paramsDB.clear();
    _paramsDB.addAll(paramsData);
  }
}