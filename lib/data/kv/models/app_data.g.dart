// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppDataAdapter extends TypeAdapter<AppData> {
  @override
  final typeId = 35;

  @override
  AppData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppData()
      ..firstStart = fields[0] as bool
      ..lastBoxID = fields[1] as int
      ..allowAnalytics = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, AppData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.firstStart)
      ..writeByte(1)
      ..write(obj.lastBoxID)
      ..writeByte(2)
      ..write(obj.allowAnalytics);
  }
}
