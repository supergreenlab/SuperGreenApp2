import 'package:moor_flutter/moor_flutter.dart';

part 'devices.g.dart';

class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get identifier => text().withLength(min: 1, max: 16)();
  TextColumn get name => text().withLength(min: 8, max: 24)();
  TextColumn get config => text()();
  TextColumn get ip => text().withLength(min: 7, max: 15)();
  TextColumn get mdns => text().withLength(min: 1, max: 64)();
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

@UseMoor(tables: [Devices, Modules, Params])
class DevicesDB extends _$DevicesDB {
  static DevicesDB _instance;

  factory DevicesDB.get() {
    if (_instance == null) {
      _instance = DevicesDB();
    }
    return _instance;
  }

  DevicesDB()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<int> addDevice(DevicesCompanion device) {
    return into(devices).insert(device);
  }

  Future<Device> getDevice(int id) {
    return (select(devices)..where((d) => d.id.equals(id))).getSingle();
  }

  Future<List<Device>> getDevices() {
    return select(devices).get();
  }

  Future<int> addModule(ModulesCompanion module) {
    return into(modules).insert(module);
  }

  Future<Module> getModule(int deviceID, String name) {
    return (select(modules)..where((m) => m.device.equals(deviceID) & m.name.equals(name)))
        .getSingle();
  }

  Future<int> addParam(ParamsCompanion param) {
    return into(params).insert(param);
  }

  SimpleSelectStatement<Params, Param> _getParam(int deviceID, String key) {
    return (select(params)..where((p) => p.device.equals(deviceID) & p.key.equals(key)));
  }

  Stream<Param> getParam(int deviceID, String key) {
    return _getParam(deviceID, key).watchSingle();
  }

}
