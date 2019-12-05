import 'package:hive/hive.dart';
import 'package:super_green_app/models/app_data.dart';

class AppDB {

  Box _db;

  Future<void> init() async {
    _db = await Hive.openBox('app');
  }

  AppData getAppData() {
    return _db.get('data', defaultValue: AppData());
  }

  void setFirstStart(firstStart) {
    AppData appData = getAppData();
    appData.firstStart = firstStart;
    setAppData(appData);
  }

  void setAppData(AppData appData) {
    _db.put('data', appData);
  }

}