import 'package:hive/hive.dart';
import 'package:super_green_app/models/app_data.dart';
import 'package:super_green_app/models/device/device_data.dart';

class AppDB {
  static final AppDB _instance = AppDB.newInstance();

  Box _settingsDB;
  Box _devicesDB;

  factory AppDB() => _instance;

  AppDB.newInstance();

  Future<void> init() async {
    _settingsDB = await Hive.openBox('settings');
    _devicesDB = await Hive.openBox('devices');
  }

  AppData getAppData() {
    return _settingsDB.get('data', defaultValue: AppData());
  }

  void setFirstStart(firstStart) {
    AppData appData = getAppData();
    appData.firstStart = firstStart;
    setAppData(appData);
  }

  void setAppData(AppData appData) {
    _settingsDB.put('data', appData);
  }

  void addDevice(DeviceData deviceData) {
    _devicesDB.add(deviceData);
  }

}