import 'package:hive/hive.dart';

part 'app_data.g.dart';

@HiveType()
class AppData {
  @HiveField(0)
  bool firstStart = true;
  @HiveField(1)
  String lastController = "";
}