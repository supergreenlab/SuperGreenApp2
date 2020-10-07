// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$DevicesDAOMixin on DatabaseAccessor<RelDB> {
  $DevicesTable get devices => attachedDatabase.devices;
  $ModulesTable get modules => attachedDatabase.modules;
  $ParamsTable get params => attachedDatabase.params;
  Selectable<int> nDevices() {
    return customSelect('SELECT COUNT(*) FROM devices',
        variables: [],
        readsFrom: {devices}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }
}
