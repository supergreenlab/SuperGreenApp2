import 'package:hive/hive.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';

class AppDB {
  static final AppDB _instance = AppDB.newInstance();

  Box _settingsDB;

  factory AppDB() => _instance;

  AppDB.newInstance();

  Future<void> init() async {
    _settingsDB = await Hive.openBox('settings');
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

}