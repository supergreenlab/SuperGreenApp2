import 'package:hive/hive.dart';

part 'module_data.g.dart';

@HiveType()
class ModuleData {
  @HiveField(0)
  String deviceId;
  @HiveField(1)
  String name;
  @HiveField(2)
  bool isArray = false;
  @HiveField(3)
  int arrayLen = 0;
  @HiveField(4)
  List<String> params = List();

  ModuleData(this.deviceId, this.name, this.isArray);
}