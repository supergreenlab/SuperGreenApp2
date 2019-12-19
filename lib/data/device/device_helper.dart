import 'package:super_green_app/data/device/api/device_api.dart';
import 'package:super_green_app/data/device/storage/devices.dart';

class DeviceHelper {
  
  static Future updateDeviceName(Device device, String name) async {
    await DeviceAPI.setStringParam(device.ip, 'DEVICE_NAME', name);
    await DevicesDB.get().updateDevice(device.copyWith(name: name));
  } 

}