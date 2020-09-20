/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'devices.g.dart';

class DeletedDevicesCompanion extends DevicesCompanion {
  DeletedDevicesCompanion(serverID) : super(serverID: serverID);
}

class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get identifier => text().withLength(min: 1, max: 16)();
  TextColumn get name => text().withLength(min: 1, max: 24)();
  TextColumn get ip => text().withLength(min: 7, max: 15)();
  TextColumn get mdns => text().withLength(min: 1, max: 64)();
  BoolColumn get isReachable => boolean().withDefault(Constant(true))();
  BoolColumn get isSetup => boolean().withDefault(Constant(false))();

  TextColumn get serverID => text().withLength(min: 36, max: 36).nullable()();
  BoolColumn get synced => boolean().withDefault(Constant(false))();

  static DevicesCompanion fromMap(Map<String, dynamic> map) {
    if (map['deleted'] == true) {
      return DeletedDevicesCompanion(Value(map['id'] as String));
    }
    return DevicesCompanion(
        identifier: Value(map['identifier'] as String),
        name: Value(map['name'] as String),
        ip: Value(map['ip'] as String),
        mdns: Value(map['mdns'] as String),
        isReachable: Value(false),
        synced: Value(true),
        serverID: Value(map['id'] as String));
  }

  static Future<Map<String, dynamic>> toMap(Device device) async {
    return {
      'id': device.serverID,
      'identifier': device.identifier,
      'name': device.name,
      'ip': device.ip,
      'mdns': device.mdns,
    };
  }
}

class Modules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get device => integer()();
  TextColumn get name => text().withLength(min: 1, max: 24)();
  BoolColumn get isArray => boolean()();
  IntColumn get arrayLen => integer()();
}

const STRING_TYPE = 0;
const INTEGER_TYPE = 1;

class Params extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get device => integer()();
  IntColumn get module => integer()();
  TextColumn get key => text().withLength(min: 1, max: 30)();
  IntColumn get type => integer()();
  TextColumn get svalue => text().nullable().withLength(min: 0, max: 64)();
  IntColumn get ivalue => integer().nullable()();
}

@UseDao(tables: [
  Devices,
  Modules,
  Params
], queries: {
  'nDevices': 'SELECT COUNT(*) FROM devices',
})
class DevicesDAO extends DatabaseAccessor<RelDB> with _$DevicesDAOMixin {
  DevicesDAO(RelDB db) : super(db);

  Future<int> addDevice(DevicesCompanion device) {
    return into(devices).insert(device);
  }

  Future<Device> getDevice(int id) {
    return (select(devices)..where((d) => d.id.equals(id))).getSingle();
  }

  Future<Device> getDeviceForServerID(String serverID) {
    return (select(devices)..where((d) => d.serverID.equals(serverID)))
        .getSingle();
  }

  Stream<Device> watchDevice(int id) {
    return (select(devices)..where((d) => d.id.equals(id))).watchSingle();
  }

  Future<Device> getDeviceByIdentifier(String identifier) {
    return (select(devices)..where((d) => d.identifier.equals(identifier)))
        .getSingle();
  }

  Future<List<Device>> getDevices() {
    return select(devices).get();
  }

  Future<List<Device>> getUnsyncedDevices() {
    return (select(devices)..where((d) => d.synced.equals(false))).get();
  }

  Stream<List<Device>> watchDevices() {
    return (select(devices)
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .watch();
  }

  Future updateDevice(DevicesCompanion device) {
    return (update(devices)..where((tbl) => tbl.id.equals(device.id.value)))
        .write(device);
  }

  Future deleteDevice(Device device) {
    return delete(devices).delete(device);
  }

  Future<int> addModule(ModulesCompanion module) {
    return into(modules).insert(module);
  }

  Future<Module> getModule(int deviceID, String name) {
    return (select(modules)
          ..where((m) => m.device.equals(deviceID) & m.name.equals(name)))
        .getSingle();
  }

  Future deleteModules(int deviceID) {
    return (delete(modules)..where((m) => m.device.equals(deviceID))).go();
  }

  Future<int> addParam(ParamsCompanion param) {
    return into(params).insert(param);
  }

  SimpleSelectStatement<Params, Param> _getParam(int deviceID, String key) {
    return (select(params)
      ..where((p) => p.device.equals(deviceID) & p.key.equals(key)));
  }

  Future<Param> getParam(int deviceID, String key) {
    return _getParam(deviceID, key).getSingle();
  }

  Stream<Param> watchParam(int deviceID, String key) {
    return _getParam(deviceID, key).watchSingle();
  }

  Future updateParam(Param param) {
    return update(params).replace(param);
  }

  Future deleteParams(int deviceID) {
    return (delete(params)..where((p) => p.device.equals(deviceID))).go();
  }
}
