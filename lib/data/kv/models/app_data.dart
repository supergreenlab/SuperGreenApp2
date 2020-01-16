import 'package:hive/hive.dart';

part 'app_data.g.dart';

@HiveType(typeId: 35)
class AppData {
  @HiveField(0)
  bool firstStart = true;
  @HiveField(1)
  int lastBoxID;
}