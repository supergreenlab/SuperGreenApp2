// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'param_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParamTypeAdapter extends TypeAdapter<ParamType> {
  @override
  ParamType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ParamType.STRING;
      case 1:
        return ParamType.INTEGER;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ParamType obj) {
    switch (obj) {
      case ParamType.STRING:
        writer.writeByte(0);
        break;
      case ParamType.INTEGER:
        writer.writeByte(1);
        break;
    }
  }
}

class ParamDataAdapter extends TypeAdapter<ParamData> {
  @override
  ParamData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParamData(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as ParamType,
    )
      ..stringValue = fields[4] as String
      ..intValue = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, ParamData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.deviceId)
      ..writeByte(1)
      ..write(obj.moduleName)
      ..writeByte(2)
      ..write(obj.key)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.stringValue)
      ..writeByte(5)
      ..write(obj.intValue);
  }
}
