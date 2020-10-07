// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$DevicesDAOMixin on DatabaseAccessor<RelDB> {
  $DevicesTable get devices => db.devices;
  $ModulesTable get modules => db.modules;
  $ParamsTable get params => db.params;
  Selectable<int> nDevices() {
    return customSelectQuery('SELECT COUNT(*) FROM devices',
        variables: [],
        readsFrom: {devices}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }
}
