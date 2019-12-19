// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Device extends DataClass implements Insertable<Device> {
  final int id;
  final String identifier;
  final String name;
  final String config;
  final String ip;
  final String mdns;
  Device(
      {@required this.id,
      @required this.identifier,
      @required this.name,
      @required this.config,
      @required this.ip,
      @required this.mdns});
  factory Device.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Device(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      identifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}identifier']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      config:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}config']),
      ip: stringType.mapFromDatabaseResponse(data['${effectivePrefix}ip']),
      mdns: stringType.mapFromDatabaseResponse(data['${effectivePrefix}mdns']),
    );
  }
  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Device(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      name: serializer.fromJson<String>(json['name']),
      config: serializer.fromJson<String>(json['config']),
      ip: serializer.fromJson<String>(json['ip']),
      mdns: serializer.fromJson<String>(json['mdns']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'name': serializer.toJson<String>(name),
      'config': serializer.toJson<String>(config),
      'ip': serializer.toJson<String>(ip),
      'mdns': serializer.toJson<String>(mdns),
    };
  }

  @override
  DevicesCompanion createCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      identifier: identifier == null && nullToAbsent
          ? const Value.absent()
          : Value(identifier),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      config:
          config == null && nullToAbsent ? const Value.absent() : Value(config),
      ip: ip == null && nullToAbsent ? const Value.absent() : Value(ip),
      mdns: mdns == null && nullToAbsent ? const Value.absent() : Value(mdns),
    );
  }

  Device copyWith(
          {int id,
          String identifier,
          String name,
          String config,
          String ip,
          String mdns}) =>
      Device(
        id: id ?? this.id,
        identifier: identifier ?? this.identifier,
        name: name ?? this.name,
        config: config ?? this.config,
        ip: ip ?? this.ip,
        mdns: mdns ?? this.mdns,
      );
  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('config: $config, ')
          ..write('ip: $ip, ')
          ..write('mdns: $mdns')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          identifier.hashCode,
          $mrjc(name.hashCode,
              $mrjc(config.hashCode, $mrjc(ip.hashCode, mdns.hashCode))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.name == this.name &&
          other.config == this.config &&
          other.ip == this.ip &&
          other.mdns == this.mdns);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> identifier;
  final Value<String> name;
  final Value<String> config;
  final Value<String> ip;
  final Value<String> mdns;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.name = const Value.absent(),
    this.config = const Value.absent(),
    this.ip = const Value.absent(),
    this.mdns = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    @required String identifier,
    @required String name,
    @required String config,
    @required String ip,
    @required String mdns,
  })  : identifier = Value(identifier),
        name = Value(name),
        config = Value(config),
        ip = Value(ip),
        mdns = Value(mdns);
  DevicesCompanion copyWith(
      {Value<int> id,
      Value<String> identifier,
      Value<String> name,
      Value<String> config,
      Value<String> ip,
      Value<String> mdns}) {
    return DevicesCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      config: config ?? this.config,
      ip: ip ?? this.ip,
      mdns: mdns ?? this.mdns,
    );
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  final GeneratedDatabase _db;
  final String _alias;
  $DevicesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _identifierMeta = const VerificationMeta('identifier');
  GeneratedTextColumn _identifier;
  @override
  GeneratedTextColumn get identifier => _identifier ??= _constructIdentifier();
  GeneratedTextColumn _constructIdentifier() {
    return GeneratedTextColumn('identifier', $tableName, false,
        minTextLength: 1, maxTextLength: 16);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 8, maxTextLength: 24);
  }

  final VerificationMeta _configMeta = const VerificationMeta('config');
  GeneratedTextColumn _config;
  @override
  GeneratedTextColumn get config => _config ??= _constructConfig();
  GeneratedTextColumn _constructConfig() {
    return GeneratedTextColumn(
      'config',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ipMeta = const VerificationMeta('ip');
  GeneratedTextColumn _ip;
  @override
  GeneratedTextColumn get ip => _ip ??= _constructIp();
  GeneratedTextColumn _constructIp() {
    return GeneratedTextColumn('ip', $tableName, false,
        minTextLength: 7, maxTextLength: 15);
  }

  final VerificationMeta _mdnsMeta = const VerificationMeta('mdns');
  GeneratedTextColumn _mdns;
  @override
  GeneratedTextColumn get mdns => _mdns ??= _constructMdns();
  GeneratedTextColumn _constructMdns() {
    return GeneratedTextColumn('mdns', $tableName, false,
        minTextLength: 1, maxTextLength: 64);
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, identifier, name, config, ip, mdns];
  @override
  $DevicesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'devices';
  @override
  final String actualTableName = 'devices';
  @override
  VerificationContext validateIntegrity(DevicesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.identifier.present) {
      context.handle(_identifierMeta,
          identifier.isAcceptableValue(d.identifier.value, _identifierMeta));
    } else if (identifier.isRequired && isInserting) {
      context.missing(_identifierMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.config.present) {
      context.handle(
          _configMeta, config.isAcceptableValue(d.config.value, _configMeta));
    } else if (config.isRequired && isInserting) {
      context.missing(_configMeta);
    }
    if (d.ip.present) {
      context.handle(_ipMeta, ip.isAcceptableValue(d.ip.value, _ipMeta));
    } else if (ip.isRequired && isInserting) {
      context.missing(_ipMeta);
    }
    if (d.mdns.present) {
      context.handle(
          _mdnsMeta, mdns.isAcceptableValue(d.mdns.value, _mdnsMeta));
    } else if (mdns.isRequired && isInserting) {
      context.missing(_mdnsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Device.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(DevicesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.identifier.present) {
      map['identifier'] = Variable<String, StringType>(d.identifier.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.config.present) {
      map['config'] = Variable<String, StringType>(d.config.value);
    }
    if (d.ip.present) {
      map['ip'] = Variable<String, StringType>(d.ip.value);
    }
    if (d.mdns.present) {
      map['mdns'] = Variable<String, StringType>(d.mdns.value);
    }
    return map;
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(_db, alias);
  }
}

class Module extends DataClass implements Insertable<Module> {
  final int id;
  final int device;
  final String name;
  final bool isArray;
  final int arrayLen;
  Module(
      {@required this.id,
      @required this.device,
      @required this.name,
      @required this.isArray,
      @required this.arrayLen});
  factory Module.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Module(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      device: intType.mapFromDatabaseResponse(data['${effectivePrefix}device']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      isArray:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_array']),
      arrayLen:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}array_len']),
    );
  }
  factory Module.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Module(
      id: serializer.fromJson<int>(json['id']),
      device: serializer.fromJson<int>(json['device']),
      name: serializer.fromJson<String>(json['name']),
      isArray: serializer.fromJson<bool>(json['isArray']),
      arrayLen: serializer.fromJson<int>(json['arrayLen']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'device': serializer.toJson<int>(device),
      'name': serializer.toJson<String>(name),
      'isArray': serializer.toJson<bool>(isArray),
      'arrayLen': serializer.toJson<int>(arrayLen),
    };
  }

  @override
  ModulesCompanion createCompanion(bool nullToAbsent) {
    return ModulesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      device:
          device == null && nullToAbsent ? const Value.absent() : Value(device),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isArray: isArray == null && nullToAbsent
          ? const Value.absent()
          : Value(isArray),
      arrayLen: arrayLen == null && nullToAbsent
          ? const Value.absent()
          : Value(arrayLen),
    );
  }

  Module copyWith(
          {int id, int device, String name, bool isArray, int arrayLen}) =>
      Module(
        id: id ?? this.id,
        device: device ?? this.device,
        name: name ?? this.name,
        isArray: isArray ?? this.isArray,
        arrayLen: arrayLen ?? this.arrayLen,
      );
  @override
  String toString() {
    return (StringBuffer('Module(')
          ..write('id: $id, ')
          ..write('device: $device, ')
          ..write('name: $name, ')
          ..write('isArray: $isArray, ')
          ..write('arrayLen: $arrayLen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(device.hashCode,
          $mrjc(name.hashCode, $mrjc(isArray.hashCode, arrayLen.hashCode)))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Module &&
          other.id == this.id &&
          other.device == this.device &&
          other.name == this.name &&
          other.isArray == this.isArray &&
          other.arrayLen == this.arrayLen);
}

class ModulesCompanion extends UpdateCompanion<Module> {
  final Value<int> id;
  final Value<int> device;
  final Value<String> name;
  final Value<bool> isArray;
  final Value<int> arrayLen;
  const ModulesCompanion({
    this.id = const Value.absent(),
    this.device = const Value.absent(),
    this.name = const Value.absent(),
    this.isArray = const Value.absent(),
    this.arrayLen = const Value.absent(),
  });
  ModulesCompanion.insert({
    this.id = const Value.absent(),
    @required int device,
    @required String name,
    @required bool isArray,
    @required int arrayLen,
  })  : device = Value(device),
        name = Value(name),
        isArray = Value(isArray),
        arrayLen = Value(arrayLen);
  ModulesCompanion copyWith(
      {Value<int> id,
      Value<int> device,
      Value<String> name,
      Value<bool> isArray,
      Value<int> arrayLen}) {
    return ModulesCompanion(
      id: id ?? this.id,
      device: device ?? this.device,
      name: name ?? this.name,
      isArray: isArray ?? this.isArray,
      arrayLen: arrayLen ?? this.arrayLen,
    );
  }
}

class $ModulesTable extends Modules with TableInfo<$ModulesTable, Module> {
  final GeneratedDatabase _db;
  final String _alias;
  $ModulesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _deviceMeta = const VerificationMeta('device');
  GeneratedIntColumn _device;
  @override
  GeneratedIntColumn get device => _device ??= _constructDevice();
  GeneratedIntColumn _constructDevice() {
    return GeneratedIntColumn(
      'device',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 24);
  }

  final VerificationMeta _isArrayMeta = const VerificationMeta('isArray');
  GeneratedBoolColumn _isArray;
  @override
  GeneratedBoolColumn get isArray => _isArray ??= _constructIsArray();
  GeneratedBoolColumn _constructIsArray() {
    return GeneratedBoolColumn(
      'is_array',
      $tableName,
      false,
    );
  }

  final VerificationMeta _arrayLenMeta = const VerificationMeta('arrayLen');
  GeneratedIntColumn _arrayLen;
  @override
  GeneratedIntColumn get arrayLen => _arrayLen ??= _constructArrayLen();
  GeneratedIntColumn _constructArrayLen() {
    return GeneratedIntColumn(
      'array_len',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, device, name, isArray, arrayLen];
  @override
  $ModulesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'modules';
  @override
  final String actualTableName = 'modules';
  @override
  VerificationContext validateIntegrity(ModulesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.device.present) {
      context.handle(
          _deviceMeta, device.isAcceptableValue(d.device.value, _deviceMeta));
    } else if (device.isRequired && isInserting) {
      context.missing(_deviceMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.isArray.present) {
      context.handle(_isArrayMeta,
          isArray.isAcceptableValue(d.isArray.value, _isArrayMeta));
    } else if (isArray.isRequired && isInserting) {
      context.missing(_isArrayMeta);
    }
    if (d.arrayLen.present) {
      context.handle(_arrayLenMeta,
          arrayLen.isAcceptableValue(d.arrayLen.value, _arrayLenMeta));
    } else if (arrayLen.isRequired && isInserting) {
      context.missing(_arrayLenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Module map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Module.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ModulesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.device.present) {
      map['device'] = Variable<int, IntType>(d.device.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.isArray.present) {
      map['is_array'] = Variable<bool, BoolType>(d.isArray.value);
    }
    if (d.arrayLen.present) {
      map['array_len'] = Variable<int, IntType>(d.arrayLen.value);
    }
    return map;
  }

  @override
  $ModulesTable createAlias(String alias) {
    return $ModulesTable(_db, alias);
  }
}

class Param extends DataClass implements Insertable<Param> {
  final int id;
  final int device;
  final int module;
  final String key;
  final int type;
  final String svalue;
  final int ivalue;
  Param(
      {@required this.id,
      @required this.device,
      @required this.module,
      @required this.key,
      @required this.type,
      this.svalue,
      this.ivalue});
  factory Param.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Param(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      device: intType.mapFromDatabaseResponse(data['${effectivePrefix}device']),
      module: intType.mapFromDatabaseResponse(data['${effectivePrefix}module']),
      key: stringType.mapFromDatabaseResponse(data['${effectivePrefix}key']),
      type: intType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      svalue:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}svalue']),
      ivalue: intType.mapFromDatabaseResponse(data['${effectivePrefix}ivalue']),
    );
  }
  factory Param.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Param(
      id: serializer.fromJson<int>(json['id']),
      device: serializer.fromJson<int>(json['device']),
      module: serializer.fromJson<int>(json['module']),
      key: serializer.fromJson<String>(json['key']),
      type: serializer.fromJson<int>(json['type']),
      svalue: serializer.fromJson<String>(json['svalue']),
      ivalue: serializer.fromJson<int>(json['ivalue']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'device': serializer.toJson<int>(device),
      'module': serializer.toJson<int>(module),
      'key': serializer.toJson<String>(key),
      'type': serializer.toJson<int>(type),
      'svalue': serializer.toJson<String>(svalue),
      'ivalue': serializer.toJson<int>(ivalue),
    };
  }

  @override
  ParamsCompanion createCompanion(bool nullToAbsent) {
    return ParamsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      device:
          device == null && nullToAbsent ? const Value.absent() : Value(device),
      module:
          module == null && nullToAbsent ? const Value.absent() : Value(module),
      key: key == null && nullToAbsent ? const Value.absent() : Value(key),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      svalue:
          svalue == null && nullToAbsent ? const Value.absent() : Value(svalue),
      ivalue:
          ivalue == null && nullToAbsent ? const Value.absent() : Value(ivalue),
    );
  }

  Param copyWith(
          {int id,
          int device,
          int module,
          String key,
          int type,
          String svalue,
          int ivalue}) =>
      Param(
        id: id ?? this.id,
        device: device ?? this.device,
        module: module ?? this.module,
        key: key ?? this.key,
        type: type ?? this.type,
        svalue: svalue ?? this.svalue,
        ivalue: ivalue ?? this.ivalue,
      );
  @override
  String toString() {
    return (StringBuffer('Param(')
          ..write('id: $id, ')
          ..write('device: $device, ')
          ..write('module: $module, ')
          ..write('key: $key, ')
          ..write('type: $type, ')
          ..write('svalue: $svalue, ')
          ..write('ivalue: $ivalue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          device.hashCode,
          $mrjc(
              module.hashCode,
              $mrjc(
                  key.hashCode,
                  $mrjc(type.hashCode,
                      $mrjc(svalue.hashCode, ivalue.hashCode)))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Param &&
          other.id == this.id &&
          other.device == this.device &&
          other.module == this.module &&
          other.key == this.key &&
          other.type == this.type &&
          other.svalue == this.svalue &&
          other.ivalue == this.ivalue);
}

class ParamsCompanion extends UpdateCompanion<Param> {
  final Value<int> id;
  final Value<int> device;
  final Value<int> module;
  final Value<String> key;
  final Value<int> type;
  final Value<String> svalue;
  final Value<int> ivalue;
  const ParamsCompanion({
    this.id = const Value.absent(),
    this.device = const Value.absent(),
    this.module = const Value.absent(),
    this.key = const Value.absent(),
    this.type = const Value.absent(),
    this.svalue = const Value.absent(),
    this.ivalue = const Value.absent(),
  });
  ParamsCompanion.insert({
    this.id = const Value.absent(),
    @required int device,
    @required int module,
    @required String key,
    @required int type,
    this.svalue = const Value.absent(),
    this.ivalue = const Value.absent(),
  })  : device = Value(device),
        module = Value(module),
        key = Value(key),
        type = Value(type);
  ParamsCompanion copyWith(
      {Value<int> id,
      Value<int> device,
      Value<int> module,
      Value<String> key,
      Value<int> type,
      Value<String> svalue,
      Value<int> ivalue}) {
    return ParamsCompanion(
      id: id ?? this.id,
      device: device ?? this.device,
      module: module ?? this.module,
      key: key ?? this.key,
      type: type ?? this.type,
      svalue: svalue ?? this.svalue,
      ivalue: ivalue ?? this.ivalue,
    );
  }
}

class $ParamsTable extends Params with TableInfo<$ParamsTable, Param> {
  final GeneratedDatabase _db;
  final String _alias;
  $ParamsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _deviceMeta = const VerificationMeta('device');
  GeneratedIntColumn _device;
  @override
  GeneratedIntColumn get device => _device ??= _constructDevice();
  GeneratedIntColumn _constructDevice() {
    return GeneratedIntColumn(
      'device',
      $tableName,
      false,
    );
  }

  final VerificationMeta _moduleMeta = const VerificationMeta('module');
  GeneratedIntColumn _module;
  @override
  GeneratedIntColumn get module => _module ??= _constructModule();
  GeneratedIntColumn _constructModule() {
    return GeneratedIntColumn(
      'module',
      $tableName,
      false,
    );
  }

  final VerificationMeta _keyMeta = const VerificationMeta('key');
  GeneratedTextColumn _key;
  @override
  GeneratedTextColumn get key => _key ??= _constructKey();
  GeneratedTextColumn _constructKey() {
    return GeneratedTextColumn('key', $tableName, false,
        minTextLength: 1, maxTextLength: 30);
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedIntColumn _type;
  @override
  GeneratedIntColumn get type => _type ??= _constructType();
  GeneratedIntColumn _constructType() {
    return GeneratedIntColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _svalueMeta = const VerificationMeta('svalue');
  GeneratedTextColumn _svalue;
  @override
  GeneratedTextColumn get svalue => _svalue ??= _constructSvalue();
  GeneratedTextColumn _constructSvalue() {
    return GeneratedTextColumn('svalue', $tableName, true,
        minTextLength: 0, maxTextLength: 64);
  }

  final VerificationMeta _ivalueMeta = const VerificationMeta('ivalue');
  GeneratedIntColumn _ivalue;
  @override
  GeneratedIntColumn get ivalue => _ivalue ??= _constructIvalue();
  GeneratedIntColumn _constructIvalue() {
    return GeneratedIntColumn(
      'ivalue',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, device, module, key, type, svalue, ivalue];
  @override
  $ParamsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'params';
  @override
  final String actualTableName = 'params';
  @override
  VerificationContext validateIntegrity(ParamsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.device.present) {
      context.handle(
          _deviceMeta, device.isAcceptableValue(d.device.value, _deviceMeta));
    } else if (device.isRequired && isInserting) {
      context.missing(_deviceMeta);
    }
    if (d.module.present) {
      context.handle(
          _moduleMeta, module.isAcceptableValue(d.module.value, _moduleMeta));
    } else if (module.isRequired && isInserting) {
      context.missing(_moduleMeta);
    }
    if (d.key.present) {
      context.handle(_keyMeta, key.isAcceptableValue(d.key.value, _keyMeta));
    } else if (key.isRequired && isInserting) {
      context.missing(_keyMeta);
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (type.isRequired && isInserting) {
      context.missing(_typeMeta);
    }
    if (d.svalue.present) {
      context.handle(
          _svalueMeta, svalue.isAcceptableValue(d.svalue.value, _svalueMeta));
    } else if (svalue.isRequired && isInserting) {
      context.missing(_svalueMeta);
    }
    if (d.ivalue.present) {
      context.handle(
          _ivalueMeta, ivalue.isAcceptableValue(d.ivalue.value, _ivalueMeta));
    } else if (ivalue.isRequired && isInserting) {
      context.missing(_ivalueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Param map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Param.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ParamsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.device.present) {
      map['device'] = Variable<int, IntType>(d.device.value);
    }
    if (d.module.present) {
      map['module'] = Variable<int, IntType>(d.module.value);
    }
    if (d.key.present) {
      map['key'] = Variable<String, StringType>(d.key.value);
    }
    if (d.type.present) {
      map['type'] = Variable<int, IntType>(d.type.value);
    }
    if (d.svalue.present) {
      map['svalue'] = Variable<String, StringType>(d.svalue.value);
    }
    if (d.ivalue.present) {
      map['ivalue'] = Variable<int, IntType>(d.ivalue.value);
    }
    return map;
  }

  @override
  $ParamsTable createAlias(String alias) {
    return $ParamsTable(_db, alias);
  }
}

abstract class _$DevicesDB extends GeneratedDatabase {
  _$DevicesDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $DevicesTable _devices;
  $DevicesTable get devices => _devices ??= $DevicesTable(this);
  $ModulesTable _modules;
  $ModulesTable get modules => _modules ??= $ModulesTable(this);
  $ParamsTable _params;
  $ParamsTable get params => _params ??= $ParamsTable(this);
  @override
  List<TableInfo> get allTables => [devices, modules, params];
}
