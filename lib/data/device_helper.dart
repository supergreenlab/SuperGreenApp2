
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class DeviceHelper {
  
  static Future updateDeviceName(Device device, String name) async {
    await DeviceAPI.setStringParam(device.ip, 'DEVICE_NAME', name);
    await RelDB.get().devicesDAO.updateDevice(device.copyWith(name: name));
  } 

}