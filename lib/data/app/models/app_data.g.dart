// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppDataAdapter extends TypeAdapter<AppData> {
  @override
  AppData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppData()
      ..firstStart = fields[0] as bool
      ..lastController = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, AppData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.firstStart)
      ..writeByte(1)
      ..write(obj.lastController);
  }
}
