import 'package:hive/hive.dart';

part 'param_data.g.dart';

enum Status {
  LOADED_FROM_CACHE,
  LOADED,
  LOAD_ERROR,
}

@HiveType()
enum ParamType {
  @HiveField(0)
  STRING,
  @HiveField(1)
  INTEGER,
}

@HiveType()
class ParamData {
  @HiveField(0)
  final String deviceId;
  @HiveField(1)
  final String moduleName;
  @HiveField(2)
  final String key;
  @HiveField(3)
  final ParamType type;
  @HiveField(4)
  String stringValue;
  @HiveField(5)
  int intValue;

  Status status = Status.LOADED_FROM_CACHE;

  ParamData(this.deviceId, this.moduleName, this.key, this.type);
}