// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rel_db.dart';

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
  final bool isDraft;
  Device(
      {@required this.id,
      @required this.identifier,
      @required this.name,
      @required this.config,
      @required this.ip,
      @required this.mdns,
      @required this.isDraft});
  factory Device.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Device(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      identifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}identifier']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      config:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}config']),
      ip: stringType.mapFromDatabaseResponse(data['${effectivePrefix}ip']),
      mdns: stringType.mapFromDatabaseResponse(data['${effectivePrefix}mdns']),
      isDraft:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_draft']),
    );
  }
  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      name: serializer.fromJson<String>(json['name']),
      config: serializer.fromJson<String>(json['config']),
      ip: serializer.fromJson<String>(json['ip']),
      mdns: serializer.fromJson<String>(json['mdns']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'name': serializer.toJson<String>(name),
      'config': serializer.toJson<String>(config),
      'ip': serializer.toJson<String>(ip),
      'mdns': serializer.toJson<String>(mdns),
      'isDraft': serializer.toJson<bool>(isDraft),
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
      isDraft: isDraft == null && nullToAbsent
          ? const Value.absent()
          : Value(isDraft),
    );
  }

  Device copyWith(
          {int id,
          String identifier,
          String name,
          String config,
          String ip,
          String mdns,
          bool isDraft}) =>
      Device(
        id: id ?? this.id,
        identifier: identifier ?? this.identifier,
        name: name ?? this.name,
        config: config ?? this.config,
        ip: ip ?? this.ip,
        mdns: mdns ?? this.mdns,
        isDraft: isDraft ?? this.isDraft,
      );
  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('config: $config, ')
          ..write('ip: $ip, ')
          ..write('mdns: $mdns, ')
          ..write('isDraft: $isDraft')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          identifier.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  config.hashCode,
                  $mrjc(
                      ip.hashCode, $mrjc(mdns.hashCode, isDraft.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.name == this.name &&
          other.config == this.config &&
          other.ip == this.ip &&
          other.mdns == this.mdns &&
          other.isDraft == this.isDraft);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> identifier;
  final Value<String> name;
  final Value<String> config;
  final Value<String> ip;
  final Value<String> mdns;
  final Value<bool> isDraft;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.name = const Value.absent(),
    this.config = const Value.absent(),
    this.ip = const Value.absent(),
    this.mdns = const Value.absent(),
    this.isDraft = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    @required String identifier,
    @required String name,
    @required String config,
    @required String ip,
    @required String mdns,
    this.isDraft = const Value.absent(),
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
      Value<String> mdns,
      Value<bool> isDraft}) {
    return DevicesCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      config: config ?? this.config,
      ip: ip ?? this.ip,
      mdns: mdns ?? this.mdns,
      isDraft: isDraft ?? this.isDraft,
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
        minTextLength: 1, maxTextLength: 24);
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

  final VerificationMeta _isDraftMeta = const VerificationMeta('isDraft');
  GeneratedBoolColumn _isDraft;
  @override
  GeneratedBoolColumn get isDraft => _isDraft ??= _constructIsDraft();
  GeneratedBoolColumn _constructIsDraft() {
    return GeneratedBoolColumn('is_draft', $tableName, false,
        defaultValue: Constant(true));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, identifier, name, config, ip, mdns, isDraft];
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
    }
    if (d.identifier.present) {
      context.handle(_identifierMeta,
          identifier.isAcceptableValue(d.identifier.value, _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.config.present) {
      context.handle(
          _configMeta, config.isAcceptableValue(d.config.value, _configMeta));
    } else if (isInserting) {
      context.missing(_configMeta);
    }
    if (d.ip.present) {
      context.handle(_ipMeta, ip.isAcceptableValue(d.ip.value, _ipMeta));
    } else if (isInserting) {
      context.missing(_ipMeta);
    }
    if (d.mdns.present) {
      context.handle(
          _mdnsMeta, mdns.isAcceptableValue(d.mdns.value, _mdnsMeta));
    } else if (isInserting) {
      context.missing(_mdnsMeta);
    }
    if (d.isDraft.present) {
      context.handle(_isDraftMeta,
          isDraft.isAcceptableValue(d.isDraft.value, _isDraftMeta));
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
    if (d.isDraft.present) {
      map['is_draft'] = Variable<bool, BoolType>(d.isDraft.value);
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
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Module(
      id: serializer.fromJson<int>(json['id']),
      device: serializer.fromJson<int>(json['device']),
      name: serializer.fromJson<String>(json['name']),
      isArray: serializer.fromJson<bool>(json['isArray']),
      arrayLen: serializer.fromJson<int>(json['arrayLen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
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
  bool operator ==(dynamic other) =>
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
    }
    if (d.device.present) {
      context.handle(
          _deviceMeta, device.isAcceptableValue(d.device.value, _deviceMeta));
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.isArray.present) {
      context.handle(_isArrayMeta,
          isArray.isAcceptableValue(d.isArray.value, _isArrayMeta));
    } else if (isInserting) {
      context.missing(_isArrayMeta);
    }
    if (d.arrayLen.present) {
      context.handle(_arrayLenMeta,
          arrayLen.isAcceptableValue(d.arrayLen.value, _arrayLenMeta));
    } else if (isInserting) {
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
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
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
  bool operator ==(dynamic other) =>
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
    }
    if (d.device.present) {
      context.handle(
          _deviceMeta, device.isAcceptableValue(d.device.value, _deviceMeta));
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (d.module.present) {
      context.handle(
          _moduleMeta, module.isAcceptableValue(d.module.value, _moduleMeta));
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (d.key.present) {
      context.handle(_keyMeta, key.isAcceptableValue(d.key.value, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (d.svalue.present) {
      context.handle(
          _svalueMeta, svalue.isAcceptableValue(d.svalue.value, _svalueMeta));
    }
    if (d.ivalue.present) {
      context.handle(
          _ivalueMeta, ivalue.isAcceptableValue(d.ivalue.value, _ivalueMeta));
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

class Box extends DataClass implements Insertable<Box> {
  final int id;
  final int feed;
  final int device;
  final int deviceBox;
  final String name;
  final String settings;
  Box(
      {@required this.id,
      @required this.feed,
      this.device,
      this.deviceBox,
      @required this.name,
      @required this.settings});
  factory Box.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Box(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feed: intType.mapFromDatabaseResponse(data['${effectivePrefix}feed']),
      device: intType.mapFromDatabaseResponse(data['${effectivePrefix}device']),
      deviceBox:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}device_box']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      settings: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}settings']),
    );
  }
  factory Box.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Box(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      device: serializer.fromJson<int>(json['device']),
      deviceBox: serializer.fromJson<int>(json['deviceBox']),
      name: serializer.fromJson<String>(json['name']),
      settings: serializer.fromJson<String>(json['settings']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'device': serializer.toJson<int>(device),
      'deviceBox': serializer.toJson<int>(deviceBox),
      'name': serializer.toJson<String>(name),
      'settings': serializer.toJson<String>(settings),
    };
  }

  @override
  BoxesCompanion createCompanion(bool nullToAbsent) {
    return BoxesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feed: feed == null && nullToAbsent ? const Value.absent() : Value(feed),
      device:
          device == null && nullToAbsent ? const Value.absent() : Value(device),
      deviceBox: deviceBox == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceBox),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      settings: settings == null && nullToAbsent
          ? const Value.absent()
          : Value(settings),
    );
  }

  Box copyWith(
          {int id,
          int feed,
          int device,
          int deviceBox,
          String name,
          String settings}) =>
      Box(
        id: id ?? this.id,
        feed: feed ?? this.feed,
        device: device ?? this.device,
        deviceBox: deviceBox ?? this.deviceBox,
        name: name ?? this.name,
        settings: settings ?? this.settings,
      );
  @override
  String toString() {
    return (StringBuffer('Box(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('device: $device, ')
          ..write('deviceBox: $deviceBox, ')
          ..write('name: $name, ')
          ..write('settings: $settings')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feed.hashCode,
          $mrjc(
              device.hashCode,
              $mrjc(deviceBox.hashCode,
                  $mrjc(name.hashCode, settings.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Box &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.device == this.device &&
          other.deviceBox == this.deviceBox &&
          other.name == this.name &&
          other.settings == this.settings);
}

class BoxesCompanion extends UpdateCompanion<Box> {
  final Value<int> id;
  final Value<int> feed;
  final Value<int> device;
  final Value<int> deviceBox;
  final Value<String> name;
  final Value<String> settings;
  const BoxesCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.device = const Value.absent(),
    this.deviceBox = const Value.absent(),
    this.name = const Value.absent(),
    this.settings = const Value.absent(),
  });
  BoxesCompanion.insert({
    this.id = const Value.absent(),
    @required int feed,
    this.device = const Value.absent(),
    this.deviceBox = const Value.absent(),
    @required String name,
    this.settings = const Value.absent(),
  })  : feed = Value(feed),
        name = Value(name);
  BoxesCompanion copyWith(
      {Value<int> id,
      Value<int> feed,
      Value<int> device,
      Value<int> deviceBox,
      Value<String> name,
      Value<String> settings}) {
    return BoxesCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
      device: device ?? this.device,
      deviceBox: deviceBox ?? this.deviceBox,
      name: name ?? this.name,
      settings: settings ?? this.settings,
    );
  }
}

class $BoxesTable extends Boxes with TableInfo<$BoxesTable, Box> {
  final GeneratedDatabase _db;
  final String _alias;
  $BoxesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _feedMeta = const VerificationMeta('feed');
  GeneratedIntColumn _feed;
  @override
  GeneratedIntColumn get feed => _feed ??= _constructFeed();
  GeneratedIntColumn _constructFeed() {
    return GeneratedIntColumn(
      'feed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _deviceMeta = const VerificationMeta('device');
  GeneratedIntColumn _device;
  @override
  GeneratedIntColumn get device => _device ??= _constructDevice();
  GeneratedIntColumn _constructDevice() {
    return GeneratedIntColumn(
      'device',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deviceBoxMeta = const VerificationMeta('deviceBox');
  GeneratedIntColumn _deviceBox;
  @override
  GeneratedIntColumn get deviceBox => _deviceBox ??= _constructDeviceBox();
  GeneratedIntColumn _constructDeviceBox() {
    return GeneratedIntColumn(
      'device_box',
      $tableName,
      true,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 32);
  }

  final VerificationMeta _settingsMeta = const VerificationMeta('settings');
  GeneratedTextColumn _settings;
  @override
  GeneratedTextColumn get settings => _settings ??= _constructSettings();
  GeneratedTextColumn _constructSettings() {
    return GeneratedTextColumn('settings', $tableName, false,
        defaultValue: Constant('{}'));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, device, deviceBox, name, settings];
  @override
  $BoxesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'boxes';
  @override
  final String actualTableName = 'boxes';
  @override
  VerificationContext validateIntegrity(BoxesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.feed.present) {
      context.handle(
          _feedMeta, feed.isAcceptableValue(d.feed.value, _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (d.device.present) {
      context.handle(
          _deviceMeta, device.isAcceptableValue(d.device.value, _deviceMeta));
    }
    if (d.deviceBox.present) {
      context.handle(_deviceBoxMeta,
          deviceBox.isAcceptableValue(d.deviceBox.value, _deviceBoxMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.settings.present) {
      context.handle(_settingsMeta,
          settings.isAcceptableValue(d.settings.value, _settingsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Box map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Box.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BoxesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.feed.present) {
      map['feed'] = Variable<int, IntType>(d.feed.value);
    }
    if (d.device.present) {
      map['device'] = Variable<int, IntType>(d.device.value);
    }
    if (d.deviceBox.present) {
      map['device_box'] = Variable<int, IntType>(d.deviceBox.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.settings.present) {
      map['settings'] = Variable<String, StringType>(d.settings.value);
    }
    return map;
  }

  @override
  $BoxesTable createAlias(String alias) {
    return $BoxesTable(_db, alias);
  }
}

class ChartPoint extends DataClass implements Insertable<ChartPoint> {
  final int id;
  final int box;
  final String name;
  final DateTime date;
  final int value;
  ChartPoint(
      {@required this.id,
      @required this.box,
      @required this.name,
      @required this.date,
      @required this.value});
  factory ChartPoint.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return ChartPoint(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      box: intType.mapFromDatabaseResponse(data['${effectivePrefix}box']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      value: intType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
    );
  }
  factory ChartPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChartPoint(
      id: serializer.fromJson<int>(json['id']),
      box: serializer.fromJson<int>(json['box']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'box': serializer.toJson<int>(box),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'value': serializer.toJson<int>(value),
    };
  }

  @override
  ChartPointsCompanion createCompanion(bool nullToAbsent) {
    return ChartPointsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      box: box == null && nullToAbsent ? const Value.absent() : Value(box),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  ChartPoint copyWith(
          {int id, int box, String name, DateTime date, int value}) =>
      ChartPoint(
        id: id ?? this.id,
        box: box ?? this.box,
        name: name ?? this.name,
        date: date ?? this.date,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('ChartPoint(')
          ..write('id: $id, ')
          ..write('box: $box, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(box.hashCode,
          $mrjc(name.hashCode, $mrjc(date.hashCode, value.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ChartPoint &&
          other.id == this.id &&
          other.box == this.box &&
          other.name == this.name &&
          other.date == this.date &&
          other.value == this.value);
}

class ChartPointsCompanion extends UpdateCompanion<ChartPoint> {
  final Value<int> id;
  final Value<int> box;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<int> value;
  const ChartPointsCompanion({
    this.id = const Value.absent(),
    this.box = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.value = const Value.absent(),
  });
  ChartPointsCompanion.insert({
    this.id = const Value.absent(),
    @required int box,
    @required String name,
    @required DateTime date,
    @required int value,
  })  : box = Value(box),
        name = Value(name),
        date = Value(date),
        value = Value(value);
  ChartPointsCompanion copyWith(
      {Value<int> id,
      Value<int> box,
      Value<String> name,
      Value<DateTime> date,
      Value<int> value}) {
    return ChartPointsCompanion(
      id: id ?? this.id,
      box: box ?? this.box,
      name: name ?? this.name,
      date: date ?? this.date,
      value: value ?? this.value,
    );
  }
}

class $ChartPointsTable extends ChartPoints
    with TableInfo<$ChartPointsTable, ChartPoint> {
  final GeneratedDatabase _db;
  final String _alias;
  $ChartPointsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _boxMeta = const VerificationMeta('box');
  GeneratedIntColumn _box;
  @override
  GeneratedIntColumn get box => _box ??= _constructBox();
  GeneratedIntColumn _constructBox() {
    return GeneratedIntColumn(
      'box',
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
        minTextLength: 1, maxTextLength: 32);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedIntColumn _value;
  @override
  GeneratedIntColumn get value => _value ??= _constructValue();
  GeneratedIntColumn _constructValue() {
    return GeneratedIntColumn(
      'value',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, box, name, date, value];
  @override
  $ChartPointsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'chart_points';
  @override
  final String actualTableName = 'chart_points';
  @override
  VerificationContext validateIntegrity(ChartPointsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.box.present) {
      context.handle(_boxMeta, box.isAcceptableValue(d.box.value, _boxMeta));
    } else if (isInserting) {
      context.missing(_boxMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (d.value.present) {
      context.handle(
          _valueMeta, value.isAcceptableValue(d.value.value, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartPoint map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ChartPoint.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ChartPointsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.box.present) {
      map['box'] = Variable<int, IntType>(d.box.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.date.present) {
      map['date'] = Variable<DateTime, DateTimeType>(d.date.value);
    }
    if (d.value.present) {
      map['value'] = Variable<int, IntType>(d.value.value);
    }
    return map;
  }

  @override
  $ChartPointsTable createAlias(String alias) {
    return $ChartPointsTable(_db, alias);
  }
}

class Feed extends DataClass implements Insertable<Feed> {
  final int id;
  final String name;
  Feed({@required this.id, @required this.name});
  factory Feed.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Feed(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Feed.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Feed(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  FeedsCompanion createCompanion(bool nullToAbsent) {
    return FeedsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Feed copyWith({int id, String name}) => Feed(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Feed(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Feed && other.id == this.id && other.name == this.name);
}

class FeedsCompanion extends UpdateCompanion<Feed> {
  final Value<int> id;
  final Value<String> name;
  const FeedsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  FeedsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  FeedsCompanion copyWith({Value<int> id, Value<String> name}) {
    return FeedsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class $FeedsTable extends Feeds with TableInfo<$FeedsTable, Feed> {
  final GeneratedDatabase _db;
  final String _alias;
  $FeedsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 24);
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  $FeedsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feeds';
  @override
  final String actualTableName = 'feeds';
  @override
  VerificationContext validateIntegrity(FeedsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Feed map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Feed.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(FeedsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $FeedsTable createAlias(String alias) {
    return $FeedsTable(_db, alias);
  }
}

class FeedEntry extends DataClass implements Insertable<FeedEntry> {
  final int id;
  final int feed;
  final DateTime date;
  final String type;
  final bool isNew;
  final String params;
  FeedEntry(
      {@required this.id,
      @required this.feed,
      @required this.date,
      @required this.type,
      @required this.isNew,
      @required this.params});
  factory FeedEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return FeedEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feed: intType.mapFromDatabaseResponse(data['${effectivePrefix}feed']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      isNew: boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_new']),
      params:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}params']),
    );
  }
  factory FeedEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FeedEntry(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      params: serializer.fromJson<String>(json['params']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'isNew': serializer.toJson<bool>(isNew),
      'params': serializer.toJson<String>(params),
    };
  }

  @override
  FeedEntriesCompanion createCompanion(bool nullToAbsent) {
    return FeedEntriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feed: feed == null && nullToAbsent ? const Value.absent() : Value(feed),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      isNew:
          isNew == null && nullToAbsent ? const Value.absent() : Value(isNew),
      params:
          params == null && nullToAbsent ? const Value.absent() : Value(params),
    );
  }

  FeedEntry copyWith(
          {int id,
          int feed,
          DateTime date,
          String type,
          bool isNew,
          String params}) =>
      FeedEntry(
        id: id ?? this.id,
        feed: feed ?? this.feed,
        date: date ?? this.date,
        type: type ?? this.type,
        isNew: isNew ?? this.isNew,
        params: params ?? this.params,
      );
  @override
  String toString() {
    return (StringBuffer('FeedEntry(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('isNew: $isNew, ')
          ..write('params: $params')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feed.hashCode,
          $mrjc(date.hashCode,
              $mrjc(type.hashCode, $mrjc(isNew.hashCode, params.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FeedEntry &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.date == this.date &&
          other.type == this.type &&
          other.isNew == this.isNew &&
          other.params == this.params);
}

class FeedEntriesCompanion extends UpdateCompanion<FeedEntry> {
  final Value<int> id;
  final Value<int> feed;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<bool> isNew;
  final Value<String> params;
  const FeedEntriesCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.isNew = const Value.absent(),
    this.params = const Value.absent(),
  });
  FeedEntriesCompanion.insert({
    this.id = const Value.absent(),
    @required int feed,
    @required DateTime date,
    @required String type,
    this.isNew = const Value.absent(),
    this.params = const Value.absent(),
  })  : feed = Value(feed),
        date = Value(date),
        type = Value(type);
  FeedEntriesCompanion copyWith(
      {Value<int> id,
      Value<int> feed,
      Value<DateTime> date,
      Value<String> type,
      Value<bool> isNew,
      Value<String> params}) {
    return FeedEntriesCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
      date: date ?? this.date,
      type: type ?? this.type,
      isNew: isNew ?? this.isNew,
      params: params ?? this.params,
    );
  }
}

class $FeedEntriesTable extends FeedEntries
    with TableInfo<$FeedEntriesTable, FeedEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $FeedEntriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _feedMeta = const VerificationMeta('feed');
  GeneratedIntColumn _feed;
  @override
  GeneratedIntColumn get feed => _feed ??= _constructFeed();
  GeneratedIntColumn _constructFeed() {
    return GeneratedIntColumn(
      'feed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn('type', $tableName, false,
        minTextLength: 1, maxTextLength: 24);
  }

  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  GeneratedBoolColumn _isNew;
  @override
  GeneratedBoolColumn get isNew => _isNew ??= _constructIsNew();
  GeneratedBoolColumn _constructIsNew() {
    return GeneratedBoolColumn('is_new', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _paramsMeta = const VerificationMeta('params');
  GeneratedTextColumn _params;
  @override
  GeneratedTextColumn get params => _params ??= _constructParams();
  GeneratedTextColumn _constructParams() {
    return GeneratedTextColumn('params', $tableName, false,
        defaultValue: Constant('{}'));
  }

  @override
  List<GeneratedColumn> get $columns => [id, feed, date, type, isNew, params];
  @override
  $FeedEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feed_entries';
  @override
  final String actualTableName = 'feed_entries';
  @override
  VerificationContext validateIntegrity(FeedEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.feed.present) {
      context.handle(
          _feedMeta, feed.isAcceptableValue(d.feed.value, _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (d.isNew.present) {
      context.handle(
          _isNewMeta, isNew.isAcceptableValue(d.isNew.value, _isNewMeta));
    }
    if (d.params.present) {
      context.handle(
          _paramsMeta, params.isAcceptableValue(d.params.value, _paramsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FeedEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(FeedEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.feed.present) {
      map['feed'] = Variable<int, IntType>(d.feed.value);
    }
    if (d.date.present) {
      map['date'] = Variable<DateTime, DateTimeType>(d.date.value);
    }
    if (d.type.present) {
      map['type'] = Variable<String, StringType>(d.type.value);
    }
    if (d.isNew.present) {
      map['is_new'] = Variable<bool, BoolType>(d.isNew.value);
    }
    if (d.params.present) {
      map['params'] = Variable<String, StringType>(d.params.value);
    }
    return map;
  }

  @override
  $FeedEntriesTable createAlias(String alias) {
    return $FeedEntriesTable(_db, alias);
  }
}

class FeedMedia extends DataClass implements Insertable<FeedMedia> {
  final int id;
  final int feedEntry;
  final String filePath;
  final String thumbnailPath;
  final String params;
  FeedMedia(
      {@required this.id,
      @required this.feedEntry,
      @required this.filePath,
      @required this.thumbnailPath,
      @required this.params});
  factory FeedMedia.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return FeedMedia(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feedEntry:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}feed_entry']),
      filePath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}file_path']),
      thumbnailPath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_path']),
      params:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}params']),
    );
  }
  factory FeedMedia.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FeedMedia(
      id: serializer.fromJson<int>(json['id']),
      feedEntry: serializer.fromJson<int>(json['feedEntry']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      params: serializer.fromJson<String>(json['params']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feedEntry': serializer.toJson<int>(feedEntry),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'params': serializer.toJson<String>(params),
    };
  }

  @override
  FeedMediasCompanion createCompanion(bool nullToAbsent) {
    return FeedMediasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feedEntry: feedEntry == null && nullToAbsent
          ? const Value.absent()
          : Value(feedEntry),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      params:
          params == null && nullToAbsent ? const Value.absent() : Value(params),
    );
  }

  FeedMedia copyWith(
          {int id,
          int feedEntry,
          String filePath,
          String thumbnailPath,
          String params}) =>
      FeedMedia(
        id: id ?? this.id,
        feedEntry: feedEntry ?? this.feedEntry,
        filePath: filePath ?? this.filePath,
        thumbnailPath: thumbnailPath ?? this.thumbnailPath,
        params: params ?? this.params,
      );
  @override
  String toString() {
    return (StringBuffer('FeedMedia(')
          ..write('id: $id, ')
          ..write('feedEntry: $feedEntry, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('params: $params')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feedEntry.hashCode,
          $mrjc(filePath.hashCode,
              $mrjc(thumbnailPath.hashCode, params.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FeedMedia &&
          other.id == this.id &&
          other.feedEntry == this.feedEntry &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.params == this.params);
}

class FeedMediasCompanion extends UpdateCompanion<FeedMedia> {
  final Value<int> id;
  final Value<int> feedEntry;
  final Value<String> filePath;
  final Value<String> thumbnailPath;
  final Value<String> params;
  const FeedMediasCompanion({
    this.id = const Value.absent(),
    this.feedEntry = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.params = const Value.absent(),
  });
  FeedMediasCompanion.insert({
    this.id = const Value.absent(),
    @required int feedEntry,
    @required String filePath,
    @required String thumbnailPath,
    this.params = const Value.absent(),
  })  : feedEntry = Value(feedEntry),
        filePath = Value(filePath),
        thumbnailPath = Value(thumbnailPath);
  FeedMediasCompanion copyWith(
      {Value<int> id,
      Value<int> feedEntry,
      Value<String> filePath,
      Value<String> thumbnailPath,
      Value<String> params}) {
    return FeedMediasCompanion(
      id: id ?? this.id,
      feedEntry: feedEntry ?? this.feedEntry,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      params: params ?? this.params,
    );
  }
}

class $FeedMediasTable extends FeedMedias
    with TableInfo<$FeedMediasTable, FeedMedia> {
  final GeneratedDatabase _db;
  final String _alias;
  $FeedMediasTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _feedEntryMeta = const VerificationMeta('feedEntry');
  GeneratedIntColumn _feedEntry;
  @override
  GeneratedIntColumn get feedEntry => _feedEntry ??= _constructFeedEntry();
  GeneratedIntColumn _constructFeedEntry() {
    return GeneratedIntColumn(
      'feed_entry',
      $tableName,
      false,
    );
  }

  final VerificationMeta _filePathMeta = const VerificationMeta('filePath');
  GeneratedTextColumn _filePath;
  @override
  GeneratedTextColumn get filePath => _filePath ??= _constructFilePath();
  GeneratedTextColumn _constructFilePath() {
    return GeneratedTextColumn(
      'file_path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _thumbnailPathMeta =
      const VerificationMeta('thumbnailPath');
  GeneratedTextColumn _thumbnailPath;
  @override
  GeneratedTextColumn get thumbnailPath =>
      _thumbnailPath ??= _constructThumbnailPath();
  GeneratedTextColumn _constructThumbnailPath() {
    return GeneratedTextColumn(
      'thumbnail_path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _paramsMeta = const VerificationMeta('params');
  GeneratedTextColumn _params;
  @override
  GeneratedTextColumn get params => _params ??= _constructParams();
  GeneratedTextColumn _constructParams() {
    return GeneratedTextColumn('params', $tableName, false,
        defaultValue: Constant('{}'));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, feedEntry, filePath, thumbnailPath, params];
  @override
  $FeedMediasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feed_medias';
  @override
  final String actualTableName = 'feed_medias';
  @override
  VerificationContext validateIntegrity(FeedMediasCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.feedEntry.present) {
      context.handle(_feedEntryMeta,
          feedEntry.isAcceptableValue(d.feedEntry.value, _feedEntryMeta));
    } else if (isInserting) {
      context.missing(_feedEntryMeta);
    }
    if (d.filePath.present) {
      context.handle(_filePathMeta,
          filePath.isAcceptableValue(d.filePath.value, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (d.thumbnailPath.present) {
      context.handle(
          _thumbnailPathMeta,
          thumbnailPath.isAcceptableValue(
              d.thumbnailPath.value, _thumbnailPathMeta));
    } else if (isInserting) {
      context.missing(_thumbnailPathMeta);
    }
    if (d.params.present) {
      context.handle(
          _paramsMeta, params.isAcceptableValue(d.params.value, _paramsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedMedia map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FeedMedia.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(FeedMediasCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.feedEntry.present) {
      map['feed_entry'] = Variable<int, IntType>(d.feedEntry.value);
    }
    if (d.filePath.present) {
      map['file_path'] = Variable<String, StringType>(d.filePath.value);
    }
    if (d.thumbnailPath.present) {
      map['thumbnail_path'] =
          Variable<String, StringType>(d.thumbnailPath.value);
    }
    if (d.params.present) {
      map['params'] = Variable<String, StringType>(d.params.value);
    }
    return map;
  }

  @override
  $FeedMediasTable createAlias(String alias) {
    return $FeedMediasTable(_db, alias);
  }
}

abstract class _$RelDB extends GeneratedDatabase {
  _$RelDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $DevicesTable _devices;
  $DevicesTable get devices => _devices ??= $DevicesTable(this);
  $ModulesTable _modules;
  $ModulesTable get modules => _modules ??= $ModulesTable(this);
  $ParamsTable _params;
  $ParamsTable get params => _params ??= $ParamsTable(this);
  $BoxesTable _boxes;
  $BoxesTable get boxes => _boxes ??= $BoxesTable(this);
  $ChartPointsTable _chartPoints;
  $ChartPointsTable get chartPoints => _chartPoints ??= $ChartPointsTable(this);
  $FeedsTable _feeds;
  $FeedsTable get feeds => _feeds ??= $FeedsTable(this);
  $FeedEntriesTable _feedEntries;
  $FeedEntriesTable get feedEntries => _feedEntries ??= $FeedEntriesTable(this);
  $FeedMediasTable _feedMedias;
  $FeedMediasTable get feedMedias => _feedMedias ??= $FeedMediasTable(this);
  DevicesDAO _devicesDAO;
  DevicesDAO get devicesDAO => _devicesDAO ??= DevicesDAO(this as RelDB);
  BoxesDAO _boxesDAO;
  BoxesDAO get boxesDAO => _boxesDAO ??= BoxesDAO(this as RelDB);
  FeedsDAO _feedsDAO;
  FeedsDAO get feedsDAO => _feedsDAO ??= FeedsDAO(this as RelDB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        devices,
        modules,
        params,
        boxes,
        chartPoints,
        feeds,
        feedEntries,
        feedMedias
      ];
}
