// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleDataAdapter extends TypeAdapter<ModuleData> {
  @override
  ModuleData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleData(
      fields[0] as String,
      fields[1] as String,
      fields[2] as bool,
    )
      ..arrayLen = fields[3] as int
      ..params = (fields[4] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, ModuleData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.deviceId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isArray)
      ..writeByte(3)
      ..write(obj.arrayLen)
      ..writeByte(4)
      ..write(obj.params);
  }
}
