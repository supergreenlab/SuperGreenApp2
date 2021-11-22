// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceDataAdapter extends TypeAdapter<DeviceData> {
  @override
  final int typeId = 36;

  @override
  DeviceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceData()
      ..auth = fields[0] as String?
      ..signing = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, DeviceData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.auth)
      ..writeByte(1)
      ..write(obj.signing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
