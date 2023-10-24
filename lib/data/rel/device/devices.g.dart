// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// ignore_for_file: type=lint
mixin _$DevicesDAOMixin on DatabaseAccessor<RelDB> {
  $DevicesTable get devices => attachedDatabase.devices;
  $ModulesTable get modules => attachedDatabase.modules;
  $ParamsTable get params => attachedDatabase.params;
  Selectable<int> nDevices() {
    return customSelect('SELECT COUNT(*) AS _c0 FROM devices',
        variables: [],
        readsFrom: {
          devices,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }
}
