
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class DeviceHelper {
  
  static Future updateDeviceName(Device device, String name) async {
    await DeviceAPI.setStringParam(device.ip, 'DEVICE_NAME', name);
    await RelDB.get().devicesDAO.updateDevice(device.copyWith(name: name));
  }

  static Future updateIntParam(Device device, Param param, int value) async {
    await DeviceAPI.setIntParam(device.ip, param.key, value);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(ivalue: value));
  }

}