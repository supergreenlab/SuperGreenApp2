import 'package:hive/hive.dart';

part 'device_data.g.dart';

@HiveType()
class DeviceData {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(3)
  String config;

  List<String> modules = List();

  DeviceData(this.id, this.name);
}