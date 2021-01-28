// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppDataAdapter extends TypeAdapter<AppData> {
  @override
  final int typeId = 35;

  @override
  AppData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppData()
      ..firstStart = fields[0] as bool
      ..lastPlantID = fields[1] as int
      ..allowAnalytics = fields[2] as bool
      ..freedomUnits = fields[3] as bool
      ..jwt = fields[4] as String
      ..storeGeo = fields[5] as String
      ..syncOverGSM = fields[6] as bool
      ..notificationToken = fields[7] as String
      ..notificationTokenSent = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, AppData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.firstStart)
      ..writeByte(1)
      ..write(obj.lastPlantID)
      ..writeByte(2)
      ..write(obj.allowAnalytics)
      ..writeByte(3)
      ..write(obj.freedomUnits)
      ..writeByte(4)
      ..write(obj.jwt)
      ..writeByte(5)
      ..write(obj.storeGeo)
      ..writeByte(6)
      ..write(obj.syncOverGSM)
      ..writeByte(7)
      ..write(obj.notificationToken)
      ..writeByte(8)
      ..write(obj.notificationTokenSent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
