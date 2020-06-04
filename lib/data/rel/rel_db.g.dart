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
  final String ip;
  final String mdns;
  final bool isReachable;
  final bool isSetup;
  final String serverID;
  final bool synced;
  Device(
      {@required this.id,
      @required this.identifier,
      @required this.name,
      @required this.ip,
      @required this.mdns,
      @required this.isReachable,
      @required this.isSetup,
      this.serverID,
      @required this.synced});
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
      ip: stringType.mapFromDatabaseResponse(data['${effectivePrefix}ip']),
      mdns: stringType.mapFromDatabaseResponse(data['${effectivePrefix}mdns']),
      isReachable: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_reachable']),
      isSetup:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_setup']),
      serverID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || identifier != null) {
      map['identifier'] = Variable<String>(identifier);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || ip != null) {
      map['ip'] = Variable<String>(ip);
    }
    if (!nullToAbsent || mdns != null) {
      map['mdns'] = Variable<String>(mdns);
    }
    if (!nullToAbsent || isReachable != null) {
      map['is_reachable'] = Variable<bool>(isReachable);
    }
    if (!nullToAbsent || isSetup != null) {
      map['is_setup'] = Variable<bool>(isSetup);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String>(serverID);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      identifier: identifier == null && nullToAbsent
          ? const Value.absent()
          : Value(identifier),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      ip: ip == null && nullToAbsent ? const Value.absent() : Value(ip),
      mdns: mdns == null && nullToAbsent ? const Value.absent() : Value(mdns),
      isReachable: isReachable == null && nullToAbsent
          ? const Value.absent()
          : Value(isReachable),
      isSetup: isSetup == null && nullToAbsent
          ? const Value.absent()
          : Value(isSetup),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      name: serializer.fromJson<String>(json['name']),
      ip: serializer.fromJson<String>(json['ip']),
      mdns: serializer.fromJson<String>(json['mdns']),
      isReachable: serializer.fromJson<bool>(json['isReachable']),
      isSetup: serializer.fromJson<bool>(json['isSetup']),
      serverID: serializer.fromJson<String>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'name': serializer.toJson<String>(name),
      'ip': serializer.toJson<String>(ip),
      'mdns': serializer.toJson<String>(mdns),
      'isReachable': serializer.toJson<bool>(isReachable),
      'isSetup': serializer.toJson<bool>(isSetup),
      'serverID': serializer.toJson<String>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Device copyWith(
          {int id,
          String identifier,
          String name,
          String ip,
          String mdns,
          bool isReachable,
          bool isSetup,
          String serverID,
          bool synced}) =>
      Device(
        id: id ?? this.id,
        identifier: identifier ?? this.identifier,
        name: name ?? this.name,
        ip: ip ?? this.ip,
        mdns: mdns ?? this.mdns,
        isReachable: isReachable ?? this.isReachable,
        isSetup: isSetup ?? this.isSetup,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('ip: $ip, ')
          ..write('mdns: $mdns, ')
          ..write('isReachable: $isReachable, ')
          ..write('isSetup: $isSetup, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
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
                  ip.hashCode,
                  $mrjc(
                      mdns.hashCode,
                      $mrjc(
                          isReachable.hashCode,
                          $mrjc(isSetup.hashCode,
                              $mrjc(serverID.hashCode, synced.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.name == this.name &&
          other.ip == this.ip &&
          other.mdns == this.mdns &&
          other.isReachable == this.isReachable &&
          other.isSetup == this.isSetup &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> identifier;
  final Value<String> name;
  final Value<String> ip;
  final Value<String> mdns;
  final Value<bool> isReachable;
  final Value<bool> isSetup;
  final Value<String> serverID;
  final Value<bool> synced;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.name = const Value.absent(),
    this.ip = const Value.absent(),
    this.mdns = const Value.absent(),
    this.isReachable = const Value.absent(),
    this.isSetup = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    @required String identifier,
    @required String name,
    @required String ip,
    @required String mdns,
    this.isReachable = const Value.absent(),
    this.isSetup = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : identifier = Value(identifier),
        name = Value(name),
        ip = Value(ip),
        mdns = Value(mdns);
  static Insertable<Device> custom({
    Expression<int> id,
    Expression<String> identifier,
    Expression<String> name,
    Expression<String> ip,
    Expression<String> mdns,
    Expression<bool> isReachable,
    Expression<bool> isSetup,
    Expression<String> serverID,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (identifier != null) 'identifier': identifier,
      if (name != null) 'name': name,
      if (ip != null) 'ip': ip,
      if (mdns != null) 'mdns': mdns,
      if (isReachable != null) 'is_reachable': isReachable,
      if (isSetup != null) 'is_setup': isSetup,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  DevicesCompanion copyWith(
      {Value<int> id,
      Value<String> identifier,
      Value<String> name,
      Value<String> ip,
      Value<String> mdns,
      Value<bool> isReachable,
      Value<bool> isSetup,
      Value<String> serverID,
      Value<bool> synced}) {
    return DevicesCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      mdns: mdns ?? this.mdns,
      isReachable: isReachable ?? this.isReachable,
      isSetup: isSetup ?? this.isSetup,
      serverID: serverID ?? this.serverID,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ip.present) {
      map['ip'] = Variable<String>(ip.value);
    }
    if (mdns.present) {
      map['mdns'] = Variable<String>(mdns.value);
    }
    if (isReachable.present) {
      map['is_reachable'] = Variable<bool>(isReachable.value);
    }
    if (isSetup.present) {
      map['is_setup'] = Variable<bool>(isSetup.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
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

  final VerificationMeta _isReachableMeta =
      const VerificationMeta('isReachable');
  GeneratedBoolColumn _isReachable;
  @override
  GeneratedBoolColumn get isReachable =>
      _isReachable ??= _constructIsReachable();
  GeneratedBoolColumn _constructIsReachable() {
    return GeneratedBoolColumn('is_reachable', $tableName, false,
        defaultValue: Constant(true));
  }

  final VerificationMeta _isSetupMeta = const VerificationMeta('isSetup');
  GeneratedBoolColumn _isSetup;
  @override
  GeneratedBoolColumn get isSetup => _isSetup ??= _constructIsSetup();
  GeneratedBoolColumn _constructIsSetup() {
    return GeneratedBoolColumn('is_setup', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  GeneratedTextColumn _serverID;
  @override
  GeneratedTextColumn get serverID => _serverID ??= _constructServerID();
  GeneratedTextColumn _constructServerID() {
    return GeneratedTextColumn('server_i_d', $tableName, true,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, identifier, name, ip, mdns, isReachable, isSetup, serverID, synced];
  @override
  $DevicesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'devices';
  @override
  final String actualTableName = 'devices';
  @override
  VerificationContext validateIntegrity(Insertable<Device> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('identifier')) {
      context.handle(
          _identifierMeta,
          identifier.isAcceptableOrUnknown(
              data['identifier'], _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip'], _ipMeta));
    } else if (isInserting) {
      context.missing(_ipMeta);
    }
    if (data.containsKey('mdns')) {
      context.handle(
          _mdnsMeta, mdns.isAcceptableOrUnknown(data['mdns'], _mdnsMeta));
    } else if (isInserting) {
      context.missing(_mdnsMeta);
    }
    if (data.containsKey('is_reachable')) {
      context.handle(
          _isReachableMeta,
          isReachable.isAcceptableOrUnknown(
              data['is_reachable'], _isReachableMeta));
    }
    if (data.containsKey('is_setup')) {
      context.handle(_isSetupMeta,
          isSetup.isAcceptableOrUnknown(data['is_setup'], _isSetupMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d'], _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<int>(device);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || isArray != null) {
      map['is_array'] = Variable<bool>(isArray);
    }
    if (!nullToAbsent || arrayLen != null) {
      map['array_len'] = Variable<int>(arrayLen);
    }
    return map;
  }

  ModulesCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<Module> custom({
    Expression<int> id,
    Expression<int> device,
    Expression<String> name,
    Expression<bool> isArray,
    Expression<int> arrayLen,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (device != null) 'device': device,
      if (name != null) 'name': name,
      if (isArray != null) 'is_array': isArray,
      if (arrayLen != null) 'array_len': arrayLen,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (device.present) {
      map['device'] = Variable<int>(device.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isArray.present) {
      map['is_array'] = Variable<bool>(isArray.value);
    }
    if (arrayLen.present) {
      map['array_len'] = Variable<int>(arrayLen.value);
    }
    return map;
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
  VerificationContext validateIntegrity(Insertable<Module> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device'], _deviceMeta));
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_array')) {
      context.handle(_isArrayMeta,
          isArray.isAcceptableOrUnknown(data['is_array'], _isArrayMeta));
    } else if (isInserting) {
      context.missing(_isArrayMeta);
    }
    if (data.containsKey('array_len')) {
      context.handle(_arrayLenMeta,
          arrayLen.isAcceptableOrUnknown(data['array_len'], _arrayLenMeta));
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<int>(device);
    }
    if (!nullToAbsent || module != null) {
      map['module'] = Variable<int>(module);
    }
    if (!nullToAbsent || key != null) {
      map['key'] = Variable<String>(key);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<int>(type);
    }
    if (!nullToAbsent || svalue != null) {
      map['svalue'] = Variable<String>(svalue);
    }
    if (!nullToAbsent || ivalue != null) {
      map['ivalue'] = Variable<int>(ivalue);
    }
    return map;
  }

  ParamsCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<Param> custom({
    Expression<int> id,
    Expression<int> device,
    Expression<int> module,
    Expression<String> key,
    Expression<int> type,
    Expression<String> svalue,
    Expression<int> ivalue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (device != null) 'device': device,
      if (module != null) 'module': module,
      if (key != null) 'key': key,
      if (type != null) 'type': type,
      if (svalue != null) 'svalue': svalue,
      if (ivalue != null) 'ivalue': ivalue,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (device.present) {
      map['device'] = Variable<int>(device.value);
    }
    if (module.present) {
      map['module'] = Variable<int>(module.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (svalue.present) {
      map['svalue'] = Variable<String>(svalue.value);
    }
    if (ivalue.present) {
      map['ivalue'] = Variable<int>(ivalue.value);
    }
    return map;
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
  VerificationContext validateIntegrity(Insertable<Param> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device'], _deviceMeta));
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (data.containsKey('module')) {
      context.handle(_moduleMeta,
          module.isAcceptableOrUnknown(data['module'], _moduleMeta));
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key'], _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('svalue')) {
      context.handle(_svalueMeta,
          svalue.isAcceptableOrUnknown(data['svalue'], _svalueMeta));
    }
    if (data.containsKey('ivalue')) {
      context.handle(_ivalueMeta,
          ivalue.isAcceptableOrUnknown(data['ivalue'], _ivalueMeta));
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
  $ParamsTable createAlias(String alias) {
    return $ParamsTable(_db, alias);
  }
}

class Plant extends DataClass implements Insertable<Plant> {
  final int id;
  final int feed;
  final int box;
  final String name;
  final bool single;
  final String settings;
  final String serverID;
  final bool synced;
  Plant(
      {@required this.id,
      @required this.feed,
      this.box,
      @required this.name,
      @required this.single,
      @required this.settings,
      this.serverID,
      @required this.synced});
  factory Plant.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Plant(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feed: intType.mapFromDatabaseResponse(data['${effectivePrefix}feed']),
      box: intType.mapFromDatabaseResponse(data['${effectivePrefix}box']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      single:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}single']),
      settings: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}settings']),
      serverID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || feed != null) {
      map['feed'] = Variable<int>(feed);
    }
    if (!nullToAbsent || box != null) {
      map['box'] = Variable<int>(box);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || single != null) {
      map['single'] = Variable<bool>(single);
    }
    if (!nullToAbsent || settings != null) {
      map['settings'] = Variable<String>(settings);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String>(serverID);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feed: feed == null && nullToAbsent ? const Value.absent() : Value(feed),
      box: box == null && nullToAbsent ? const Value.absent() : Value(box),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      single:
          single == null && nullToAbsent ? const Value.absent() : Value(single),
      settings: settings == null && nullToAbsent
          ? const Value.absent()
          : Value(settings),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory Plant.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Plant(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      box: serializer.fromJson<int>(json['box']),
      name: serializer.fromJson<String>(json['name']),
      single: serializer.fromJson<bool>(json['single']),
      settings: serializer.fromJson<String>(json['settings']),
      serverID: serializer.fromJson<String>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'box': serializer.toJson<int>(box),
      'name': serializer.toJson<String>(name),
      'single': serializer.toJson<bool>(single),
      'settings': serializer.toJson<String>(settings),
      'serverID': serializer.toJson<String>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Plant copyWith(
          {int id,
          int feed,
          int box,
          String name,
          bool single,
          String settings,
          String serverID,
          bool synced}) =>
      Plant(
        id: id ?? this.id,
        feed: feed ?? this.feed,
        box: box ?? this.box,
        name: name ?? this.name,
        single: single ?? this.single,
        settings: settings ?? this.settings,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Plant(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('box: $box, ')
          ..write('name: $name, ')
          ..write('single: $single, ')
          ..write('settings: $settings, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feed.hashCode,
          $mrjc(
              box.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(
                      single.hashCode,
                      $mrjc(settings.hashCode,
                          $mrjc(serverID.hashCode, synced.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.box == this.box &&
          other.name == this.name &&
          other.single == this.single &&
          other.settings == this.settings &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class PlantsCompanion extends UpdateCompanion<Plant> {
  final Value<int> id;
  final Value<int> feed;
  final Value<int> box;
  final Value<String> name;
  final Value<bool> single;
  final Value<String> settings;
  final Value<String> serverID;
  final Value<bool> synced;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.box = const Value.absent(),
    this.name = const Value.absent(),
    this.single = const Value.absent(),
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  PlantsCompanion.insert({
    this.id = const Value.absent(),
    @required int feed,
    this.box = const Value.absent(),
    @required String name,
    this.single = const Value.absent(),
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : feed = Value(feed),
        name = Value(name);
  static Insertable<Plant> custom({
    Expression<int> id,
    Expression<int> feed,
    Expression<int> box,
    Expression<String> name,
    Expression<bool> single,
    Expression<String> settings,
    Expression<String> serverID,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feed != null) 'feed': feed,
      if (box != null) 'box': box,
      if (name != null) 'name': name,
      if (single != null) 'single': single,
      if (settings != null) 'settings': settings,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  PlantsCompanion copyWith(
      {Value<int> id,
      Value<int> feed,
      Value<int> box,
      Value<String> name,
      Value<bool> single,
      Value<String> settings,
      Value<String> serverID,
      Value<bool> synced}) {
    return PlantsCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
      box: box ?? this.box,
      name: name ?? this.name,
      single: single ?? this.single,
      settings: settings ?? this.settings,
      serverID: serverID ?? this.serverID,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feed.present) {
      map['feed'] = Variable<int>(feed.value);
    }
    if (box.present) {
      map['box'] = Variable<int>(box.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (single.present) {
      map['single'] = Variable<bool>(single.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }
}

class $PlantsTable extends Plants with TableInfo<$PlantsTable, Plant> {
  final GeneratedDatabase _db;
  final String _alias;
  $PlantsTable(this._db, [this._alias]);
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

  final VerificationMeta _boxMeta = const VerificationMeta('box');
  GeneratedIntColumn _box;
  @override
  GeneratedIntColumn get box => _box ??= _constructBox();
  GeneratedIntColumn _constructBox() {
    return GeneratedIntColumn(
      'box',
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

  final VerificationMeta _singleMeta = const VerificationMeta('single');
  GeneratedBoolColumn _single;
  @override
  GeneratedBoolColumn get single => _single ??= _constructSingle();
  GeneratedBoolColumn _constructSingle() {
    return GeneratedBoolColumn('single', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _settingsMeta = const VerificationMeta('settings');
  GeneratedTextColumn _settings;
  @override
  GeneratedTextColumn get settings => _settings ??= _constructSettings();
  GeneratedTextColumn _constructSettings() {
    return GeneratedTextColumn('settings', $tableName, false,
        defaultValue: Constant('{}'));
  }

  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  GeneratedTextColumn _serverID;
  @override
  GeneratedTextColumn get serverID => _serverID ??= _constructServerID();
  GeneratedTextColumn _constructServerID() {
    return GeneratedTextColumn('server_i_d', $tableName, true,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, box, name, single, settings, serverID, synced];
  @override
  $PlantsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'plants';
  @override
  final String actualTableName = 'plants';
  @override
  VerificationContext validateIntegrity(Insertable<Plant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed'], _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('box')) {
      context.handle(
          _boxMeta, box.isAcceptableOrUnknown(data['box'], _boxMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('single')) {
      context.handle(_singleMeta,
          single.isAcceptableOrUnknown(data['single'], _singleMeta));
    }
    if (data.containsKey('settings')) {
      context.handle(_settingsMeta,
          settings.isAcceptableOrUnknown(data['settings'], _settingsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d'], _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plant map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Plant.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(_db, alias);
  }
}

class Box extends DataClass implements Insertable<Box> {
  final int id;
  final int device;
  final int deviceBox;
  final String name;
  final String settings;
  final String serverID;
  final bool synced;
  Box(
      {@required this.id,
      this.device,
      this.deviceBox,
      @required this.name,
      @required this.settings,
      this.serverID,
      @required this.synced});
  factory Box.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Box(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      device: intType.mapFromDatabaseResponse(data['${effectivePrefix}device']),
      deviceBox:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}device_box']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      settings: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}settings']),
      serverID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<int>(device);
    }
    if (!nullToAbsent || deviceBox != null) {
      map['device_box'] = Variable<int>(deviceBox);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || settings != null) {
      map['settings'] = Variable<String>(settings);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String>(serverID);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  BoxesCompanion toCompanion(bool nullToAbsent) {
    return BoxesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      device:
          device == null && nullToAbsent ? const Value.absent() : Value(device),
      deviceBox: deviceBox == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceBox),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      settings: settings == null && nullToAbsent
          ? const Value.absent()
          : Value(settings),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory Box.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Box(
      id: serializer.fromJson<int>(json['id']),
      device: serializer.fromJson<int>(json['device']),
      deviceBox: serializer.fromJson<int>(json['deviceBox']),
      name: serializer.fromJson<String>(json['name']),
      settings: serializer.fromJson<String>(json['settings']),
      serverID: serializer.fromJson<String>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'device': serializer.toJson<int>(device),
      'deviceBox': serializer.toJson<int>(deviceBox),
      'name': serializer.toJson<String>(name),
      'settings': serializer.toJson<String>(settings),
      'serverID': serializer.toJson<String>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Box copyWith(
          {int id,
          int device,
          int deviceBox,
          String name,
          String settings,
          String serverID,
          bool synced}) =>
      Box(
        id: id ?? this.id,
        device: device ?? this.device,
        deviceBox: deviceBox ?? this.deviceBox,
        name: name ?? this.name,
        settings: settings ?? this.settings,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Box(')
          ..write('id: $id, ')
          ..write('device: $device, ')
          ..write('deviceBox: $deviceBox, ')
          ..write('name: $name, ')
          ..write('settings: $settings, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          device.hashCode,
          $mrjc(
              deviceBox.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(settings.hashCode,
                      $mrjc(serverID.hashCode, synced.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Box &&
          other.id == this.id &&
          other.device == this.device &&
          other.deviceBox == this.deviceBox &&
          other.name == this.name &&
          other.settings == this.settings &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class BoxesCompanion extends UpdateCompanion<Box> {
  final Value<int> id;
  final Value<int> device;
  final Value<int> deviceBox;
  final Value<String> name;
  final Value<String> settings;
  final Value<String> serverID;
  final Value<bool> synced;
  const BoxesCompanion({
    this.id = const Value.absent(),
    this.device = const Value.absent(),
    this.deviceBox = const Value.absent(),
    this.name = const Value.absent(),
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  BoxesCompanion.insert({
    this.id = const Value.absent(),
    this.device = const Value.absent(),
    this.deviceBox = const Value.absent(),
    @required String name,
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Box> custom({
    Expression<int> id,
    Expression<int> device,
    Expression<int> deviceBox,
    Expression<String> name,
    Expression<String> settings,
    Expression<String> serverID,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (device != null) 'device': device,
      if (deviceBox != null) 'device_box': deviceBox,
      if (name != null) 'name': name,
      if (settings != null) 'settings': settings,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  BoxesCompanion copyWith(
      {Value<int> id,
      Value<int> device,
      Value<int> deviceBox,
      Value<String> name,
      Value<String> settings,
      Value<String> serverID,
      Value<bool> synced}) {
    return BoxesCompanion(
      id: id ?? this.id,
      device: device ?? this.device,
      deviceBox: deviceBox ?? this.deviceBox,
      name: name ?? this.name,
      settings: settings ?? this.settings,
      serverID: serverID ?? this.serverID,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (device.present) {
      map['device'] = Variable<int>(device.value);
    }
    if (deviceBox.present) {
      map['device_box'] = Variable<int>(deviceBox.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
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

  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  GeneratedTextColumn _serverID;
  @override
  GeneratedTextColumn get serverID => _serverID ??= _constructServerID();
  GeneratedTextColumn _constructServerID() {
    return GeneratedTextColumn('server_i_d', $tableName, true,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, device, deviceBox, name, settings, serverID, synced];
  @override
  $BoxesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'boxes';
  @override
  final String actualTableName = 'boxes';
  @override
  VerificationContext validateIntegrity(Insertable<Box> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device'], _deviceMeta));
    }
    if (data.containsKey('device_box')) {
      context.handle(_deviceBoxMeta,
          deviceBox.isAcceptableOrUnknown(data['device_box'], _deviceBoxMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('settings')) {
      context.handle(_settingsMeta,
          settings.isAcceptableOrUnknown(data['settings'], _settingsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d'], _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
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
  $BoxesTable createAlias(String alias) {
    return $BoxesTable(_db, alias);
  }
}

class ChartCache extends DataClass implements Insertable<ChartCache> {
  final int id;
  final int plant;
  final String name;
  final DateTime date;
  final String values;
  ChartCache(
      {@required this.id,
      @required this.plant,
      @required this.name,
      @required this.date,
      @required this.values});
  factory ChartCache.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return ChartCache(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      plant: intType.mapFromDatabaseResponse(data['${effectivePrefix}plant']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      values:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}values']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || plant != null) {
      map['plant'] = Variable<int>(plant);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || values != null) {
      map['values'] = Variable<String>(values);
    }
    return map;
  }

  ChartCachesCompanion toCompanion(bool nullToAbsent) {
    return ChartCachesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      plant:
          plant == null && nullToAbsent ? const Value.absent() : Value(plant),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      values:
          values == null && nullToAbsent ? const Value.absent() : Value(values),
    );
  }

  factory ChartCache.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChartCache(
      id: serializer.fromJson<int>(json['id']),
      plant: serializer.fromJson<int>(json['plant']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      values: serializer.fromJson<String>(json['values']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plant': serializer.toJson<int>(plant),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'values': serializer.toJson<String>(values),
    };
  }

  ChartCache copyWith(
          {int id, int plant, String name, DateTime date, String values}) =>
      ChartCache(
        id: id ?? this.id,
        plant: plant ?? this.plant,
        name: name ?? this.name,
        date: date ?? this.date,
        values: values ?? this.values,
      );
  @override
  String toString() {
    return (StringBuffer('ChartCache(')
          ..write('id: $id, ')
          ..write('plant: $plant, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('values: $values')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(plant.hashCode,
          $mrjc(name.hashCode, $mrjc(date.hashCode, values.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ChartCache &&
          other.id == this.id &&
          other.plant == this.plant &&
          other.name == this.name &&
          other.date == this.date &&
          other.values == this.values);
}

class ChartCachesCompanion extends UpdateCompanion<ChartCache> {
  final Value<int> id;
  final Value<int> plant;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<String> values;
  const ChartCachesCompanion({
    this.id = const Value.absent(),
    this.plant = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.values = const Value.absent(),
  });
  ChartCachesCompanion.insert({
    this.id = const Value.absent(),
    @required int plant,
    @required String name,
    @required DateTime date,
    this.values = const Value.absent(),
  })  : plant = Value(plant),
        name = Value(name),
        date = Value(date);
  static Insertable<ChartCache> custom({
    Expression<int> id,
    Expression<int> plant,
    Expression<String> name,
    Expression<DateTime> date,
    Expression<String> values,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plant != null) 'plant': plant,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (values != null) 'values': values,
    });
  }

  ChartCachesCompanion copyWith(
      {Value<int> id,
      Value<int> plant,
      Value<String> name,
      Value<DateTime> date,
      Value<String> values}) {
    return ChartCachesCompanion(
      id: id ?? this.id,
      plant: plant ?? this.plant,
      name: name ?? this.name,
      date: date ?? this.date,
      values: values ?? this.values,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plant.present) {
      map['plant'] = Variable<int>(plant.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (values.present) {
      map['values'] = Variable<String>(values.value);
    }
    return map;
  }
}

class $ChartCachesTable extends ChartCaches
    with TableInfo<$ChartCachesTable, ChartCache> {
  final GeneratedDatabase _db;
  final String _alias;
  $ChartCachesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _plantMeta = const VerificationMeta('plant');
  GeneratedIntColumn _plant;
  @override
  GeneratedIntColumn get plant => _plant ??= _constructPlant();
  GeneratedIntColumn _constructPlant() {
    return GeneratedIntColumn(
      'plant',
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

  final VerificationMeta _valuesMeta = const VerificationMeta('values');
  GeneratedTextColumn _values;
  @override
  GeneratedTextColumn get values => _values ??= _constructValues();
  GeneratedTextColumn _constructValues() {
    return GeneratedTextColumn('values', $tableName, false,
        defaultValue: Constant('[]'));
  }

  @override
  List<GeneratedColumn> get $columns => [id, plant, name, date, values];
  @override
  $ChartCachesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'chart_caches';
  @override
  final String actualTableName = 'chart_caches';
  @override
  VerificationContext validateIntegrity(Insertable<ChartCache> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('plant')) {
      context.handle(
          _plantMeta, plant.isAcceptableOrUnknown(data['plant'], _plantMeta));
    } else if (isInserting) {
      context.missing(_plantMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('values')) {
      context.handle(_valuesMeta,
          values.isAcceptableOrUnknown(data['values'], _valuesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartCache map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ChartCache.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ChartCachesTable createAlias(String alias) {
    return $ChartCachesTable(_db, alias);
  }
}

class Timelapse extends DataClass implements Insertable<Timelapse> {
  final int id;
  final int plant;
  final String ssid;
  final String password;
  final String controllerID;
  final String rotate;
  final String name;
  final String strain;
  final String dropboxToken;
  final String uploadName;
  final String serverID;
  final bool synced;
  Timelapse(
      {@required this.id,
      @required this.plant,
      this.ssid,
      this.password,
      this.controllerID,
      this.rotate,
      this.name,
      this.strain,
      this.dropboxToken,
      this.uploadName,
      this.serverID,
      @required this.synced});
  factory Timelapse.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Timelapse(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      plant: intType.mapFromDatabaseResponse(data['${effectivePrefix}plant']),
      ssid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}ssid']),
      password: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      controllerID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}controller_i_d']),
      rotate:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}rotate']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      strain:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}strain']),
      dropboxToken: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}dropbox_token']),
      uploadName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}upload_name']),
      serverID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || plant != null) {
      map['plant'] = Variable<int>(plant);
    }
    if (!nullToAbsent || ssid != null) {
      map['ssid'] = Variable<String>(ssid);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || controllerID != null) {
      map['controller_i_d'] = Variable<String>(controllerID);
    }
    if (!nullToAbsent || rotate != null) {
      map['rotate'] = Variable<String>(rotate);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || strain != null) {
      map['strain'] = Variable<String>(strain);
    }
    if (!nullToAbsent || dropboxToken != null) {
      map['dropbox_token'] = Variable<String>(dropboxToken);
    }
    if (!nullToAbsent || uploadName != null) {
      map['upload_name'] = Variable<String>(uploadName);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String>(serverID);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  TimelapsesCompanion toCompanion(bool nullToAbsent) {
    return TimelapsesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      plant:
          plant == null && nullToAbsent ? const Value.absent() : Value(plant),
      ssid: ssid == null && nullToAbsent ? const Value.absent() : Value(ssid),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      controllerID: controllerID == null && nullToAbsent
          ? const Value.absent()
          : Value(controllerID),
      rotate:
          rotate == null && nullToAbsent ? const Value.absent() : Value(rotate),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      strain:
          strain == null && nullToAbsent ? const Value.absent() : Value(strain),
      dropboxToken: dropboxToken == null && nullToAbsent
          ? const Value.absent()
          : Value(dropboxToken),
      uploadName: uploadName == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadName),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory Timelapse.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Timelapse(
      id: serializer.fromJson<int>(json['id']),
      plant: serializer.fromJson<int>(json['plant']),
      ssid: serializer.fromJson<String>(json['ssid']),
      password: serializer.fromJson<String>(json['password']),
      controllerID: serializer.fromJson<String>(json['controllerID']),
      rotate: serializer.fromJson<String>(json['rotate']),
      name: serializer.fromJson<String>(json['name']),
      strain: serializer.fromJson<String>(json['strain']),
      dropboxToken: serializer.fromJson<String>(json['dropboxToken']),
      uploadName: serializer.fromJson<String>(json['uploadName']),
      serverID: serializer.fromJson<String>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plant': serializer.toJson<int>(plant),
      'ssid': serializer.toJson<String>(ssid),
      'password': serializer.toJson<String>(password),
      'controllerID': serializer.toJson<String>(controllerID),
      'rotate': serializer.toJson<String>(rotate),
      'name': serializer.toJson<String>(name),
      'strain': serializer.toJson<String>(strain),
      'dropboxToken': serializer.toJson<String>(dropboxToken),
      'uploadName': serializer.toJson<String>(uploadName),
      'serverID': serializer.toJson<String>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Timelapse copyWith(
          {int id,
          int plant,
          String ssid,
          String password,
          String controllerID,
          String rotate,
          String name,
          String strain,
          String dropboxToken,
          String uploadName,
          String serverID,
          bool synced}) =>
      Timelapse(
        id: id ?? this.id,
        plant: plant ?? this.plant,
        ssid: ssid ?? this.ssid,
        password: password ?? this.password,
        controllerID: controllerID ?? this.controllerID,
        rotate: rotate ?? this.rotate,
        name: name ?? this.name,
        strain: strain ?? this.strain,
        dropboxToken: dropboxToken ?? this.dropboxToken,
        uploadName: uploadName ?? this.uploadName,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Timelapse(')
          ..write('id: $id, ')
          ..write('plant: $plant, ')
          ..write('ssid: $ssid, ')
          ..write('password: $password, ')
          ..write('controllerID: $controllerID, ')
          ..write('rotate: $rotate, ')
          ..write('name: $name, ')
          ..write('strain: $strain, ')
          ..write('dropboxToken: $dropboxToken, ')
          ..write('uploadName: $uploadName, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          plant.hashCode,
          $mrjc(
              ssid.hashCode,
              $mrjc(
                  password.hashCode,
                  $mrjc(
                      controllerID.hashCode,
                      $mrjc(
                          rotate.hashCode,
                          $mrjc(
                              name.hashCode,
                              $mrjc(
                                  strain.hashCode,
                                  $mrjc(
                                      dropboxToken.hashCode,
                                      $mrjc(
                                          uploadName.hashCode,
                                          $mrjc(serverID.hashCode,
                                              synced.hashCode))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Timelapse &&
          other.id == this.id &&
          other.plant == this.plant &&
          other.ssid == this.ssid &&
          other.password == this.password &&
          other.controllerID == this.controllerID &&
          other.rotate == this.rotate &&
          other.name == this.name &&
          other.strain == this.strain &&
          other.dropboxToken == this.dropboxToken &&
          other.uploadName == this.uploadName &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class TimelapsesCompanion extends UpdateCompanion<Timelapse> {
  final Value<int> id;
  final Value<int> plant;
  final Value<String> ssid;
  final Value<String> password;
  final Value<String> controllerID;
  final Value<String> rotate;
  final Value<String> name;
  final Value<String> strain;
  final Value<String> dropboxToken;
  final Value<String> uploadName;
  final Value<String> serverID;
  final Value<bool> synced;
  const TimelapsesCompanion({
    this.id = const Value.absent(),
    this.plant = const Value.absent(),
    this.ssid = const Value.absent(),
    this.password = const Value.absent(),
    this.controllerID = const Value.absent(),
    this.rotate = const Value.absent(),
    this.name = const Value.absent(),
    this.strain = const Value.absent(),
    this.dropboxToken = const Value.absent(),
    this.uploadName = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  TimelapsesCompanion.insert({
    this.id = const Value.absent(),
    @required int plant,
    this.ssid = const Value.absent(),
    this.password = const Value.absent(),
    this.controllerID = const Value.absent(),
    this.rotate = const Value.absent(),
    this.name = const Value.absent(),
    this.strain = const Value.absent(),
    this.dropboxToken = const Value.absent(),
    this.uploadName = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  }) : plant = Value(plant);
  static Insertable<Timelapse> custom({
    Expression<int> id,
    Expression<int> plant,
    Expression<String> ssid,
    Expression<String> password,
    Expression<String> controllerID,
    Expression<String> rotate,
    Expression<String> name,
    Expression<String> strain,
    Expression<String> dropboxToken,
    Expression<String> uploadName,
    Expression<String> serverID,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plant != null) 'plant': plant,
      if (ssid != null) 'ssid': ssid,
      if (password != null) 'password': password,
      if (controllerID != null) 'controller_i_d': controllerID,
      if (rotate != null) 'rotate': rotate,
      if (name != null) 'name': name,
      if (strain != null) 'strain': strain,
      if (dropboxToken != null) 'dropbox_token': dropboxToken,
      if (uploadName != null) 'upload_name': uploadName,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  TimelapsesCompanion copyWith(
      {Value<int> id,
      Value<int> plant,
      Value<String> ssid,
      Value<String> password,
      Value<String> controllerID,
      Value<String> rotate,
      Value<String> name,
      Value<String> strain,
      Value<String> dropboxToken,
      Value<String> uploadName,
      Value<String> serverID,
      Value<bool> synced}) {
    return TimelapsesCompanion(
      id: id ?? this.id,
      plant: plant ?? this.plant,
      ssid: ssid ?? this.ssid,
      password: password ?? this.password,
      controllerID: controllerID ?? this.controllerID,
      rotate: rotate ?? this.rotate,
      name: name ?? this.name,
      strain: strain ?? this.strain,
      dropboxToken: dropboxToken ?? this.dropboxToken,
      uploadName: uploadName ?? this.uploadName,
      serverID: serverID ?? this.serverID,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plant.present) {
      map['plant'] = Variable<int>(plant.value);
    }
    if (ssid.present) {
      map['ssid'] = Variable<String>(ssid.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (controllerID.present) {
      map['controller_i_d'] = Variable<String>(controllerID.value);
    }
    if (rotate.present) {
      map['rotate'] = Variable<String>(rotate.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (strain.present) {
      map['strain'] = Variable<String>(strain.value);
    }
    if (dropboxToken.present) {
      map['dropbox_token'] = Variable<String>(dropboxToken.value);
    }
    if (uploadName.present) {
      map['upload_name'] = Variable<String>(uploadName.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }
}

class $TimelapsesTable extends Timelapses
    with TableInfo<$TimelapsesTable, Timelapse> {
  final GeneratedDatabase _db;
  final String _alias;
  $TimelapsesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _plantMeta = const VerificationMeta('plant');
  GeneratedIntColumn _plant;
  @override
  GeneratedIntColumn get plant => _plant ??= _constructPlant();
  GeneratedIntColumn _constructPlant() {
    return GeneratedIntColumn(
      'plant',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ssidMeta = const VerificationMeta('ssid');
  GeneratedTextColumn _ssid;
  @override
  GeneratedTextColumn get ssid => _ssid ??= _constructSsid();
  GeneratedTextColumn _constructSsid() {
    return GeneratedTextColumn('ssid', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  GeneratedTextColumn _password;
  @override
  GeneratedTextColumn get password => _password ??= _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn('password', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _controllerIDMeta =
      const VerificationMeta('controllerID');
  GeneratedTextColumn _controllerID;
  @override
  GeneratedTextColumn get controllerID =>
      _controllerID ??= _constructControllerID();
  GeneratedTextColumn _constructControllerID() {
    return GeneratedTextColumn('controller_i_d', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _rotateMeta = const VerificationMeta('rotate');
  GeneratedTextColumn _rotate;
  @override
  GeneratedTextColumn get rotate => _rotate ??= _constructRotate();
  GeneratedTextColumn _constructRotate() {
    return GeneratedTextColumn('rotate', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _strainMeta = const VerificationMeta('strain');
  GeneratedTextColumn _strain;
  @override
  GeneratedTextColumn get strain => _strain ??= _constructStrain();
  GeneratedTextColumn _constructStrain() {
    return GeneratedTextColumn('strain', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _dropboxTokenMeta =
      const VerificationMeta('dropboxToken');
  GeneratedTextColumn _dropboxToken;
  @override
  GeneratedTextColumn get dropboxToken =>
      _dropboxToken ??= _constructDropboxToken();
  GeneratedTextColumn _constructDropboxToken() {
    return GeneratedTextColumn('dropbox_token', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _uploadNameMeta = const VerificationMeta('uploadName');
  GeneratedTextColumn _uploadName;
  @override
  GeneratedTextColumn get uploadName => _uploadName ??= _constructUploadName();
  GeneratedTextColumn _constructUploadName() {
    return GeneratedTextColumn('upload_name', $tableName, true,
        minTextLength: 1, maxTextLength: 64);
  }

  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  GeneratedTextColumn _serverID;
  @override
  GeneratedTextColumn get serverID => _serverID ??= _constructServerID();
  GeneratedTextColumn _constructServerID() {
    return GeneratedTextColumn('server_i_d', $tableName, true,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        plant,
        ssid,
        password,
        controllerID,
        rotate,
        name,
        strain,
        dropboxToken,
        uploadName,
        serverID,
        synced
      ];
  @override
  $TimelapsesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'timelapses';
  @override
  final String actualTableName = 'timelapses';
  @override
  VerificationContext validateIntegrity(Insertable<Timelapse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('plant')) {
      context.handle(
          _plantMeta, plant.isAcceptableOrUnknown(data['plant'], _plantMeta));
    } else if (isInserting) {
      context.missing(_plantMeta);
    }
    if (data.containsKey('ssid')) {
      context.handle(
          _ssidMeta, ssid.isAcceptableOrUnknown(data['ssid'], _ssidMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password'], _passwordMeta));
    }
    if (data.containsKey('controller_i_d')) {
      context.handle(
          _controllerIDMeta,
          controllerID.isAcceptableOrUnknown(
              data['controller_i_d'], _controllerIDMeta));
    }
    if (data.containsKey('rotate')) {
      context.handle(_rotateMeta,
          rotate.isAcceptableOrUnknown(data['rotate'], _rotateMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    }
    if (data.containsKey('strain')) {
      context.handle(_strainMeta,
          strain.isAcceptableOrUnknown(data['strain'], _strainMeta));
    }
    if (data.containsKey('dropbox_token')) {
      context.handle(
          _dropboxTokenMeta,
          dropboxToken.isAcceptableOrUnknown(
              data['dropbox_token'], _dropboxTokenMeta));
    }
    if (data.containsKey('upload_name')) {
      context.handle(
          _uploadNameMeta,
          uploadName.isAcceptableOrUnknown(
              data['upload_name'], _uploadNameMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d'], _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Timelapse map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Timelapse.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TimelapsesTable createAlias(String alias) {
    return $TimelapsesTable(_db, alias);
  }
}

class Feed extends DataClass implements Insertable<Feed> {
  final int id;
  final String name;
  final bool isNewsFeed;
  final String serverID;
  final bool synced;
  Feed(
      {@required this.id,
      @required this.name,
      @required this.isNewsFeed,
      this.serverID,
      @required this.synced});
  factory Feed.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Feed(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      isNewsFeed: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_news_feed']),
      serverID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || isNewsFeed != null) {
      map['is_news_feed'] = Variable<bool>(isNewsFeed);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String>(serverID);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  FeedsCompanion toCompanion(bool nullToAbsent) {
    return FeedsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isNewsFeed: isNewsFeed == null && nullToAbsent
          ? const Value.absent()
          : Value(isNewsFeed),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory Feed.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Feed(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isNewsFeed: serializer.fromJson<bool>(json['isNewsFeed']),
      serverID: serializer.fromJson<String>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isNewsFeed': serializer.toJson<bool>(isNewsFeed),
      'serverID': serializer.toJson<String>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Feed copyWith(
          {int id,
          String name,
          bool isNewsFeed,
          String serverID,
          bool synced}) =>
      Feed(
        id: id ?? this.id,
        name: name ?? this.name,
        isNewsFeed: isNewsFeed ?? this.isNewsFeed,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Feed(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isNewsFeed: $isNewsFeed, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(isNewsFeed.hashCode,
              $mrjc(serverID.hashCode, synced.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Feed &&
          other.id == this.id &&
          other.name == this.name &&
          other.isNewsFeed == this.isNewsFeed &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class FeedsCompanion extends UpdateCompanion<Feed> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isNewsFeed;
  final Value<String> serverID;
  final Value<bool> synced;
  const FeedsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isNewsFeed = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  FeedsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.isNewsFeed = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Feed> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<bool> isNewsFeed,
    Expression<String> serverID,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isNewsFeed != null) 'is_news_feed': isNewsFeed,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  FeedsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<bool> isNewsFeed,
      Value<String> serverID,
      Value<bool> synced}) {
    return FeedsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isNewsFeed: isNewsFeed ?? this.isNewsFeed,
      serverID: serverID ?? this.serverID,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isNewsFeed.present) {
      map['is_news_feed'] = Variable<bool>(isNewsFeed.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
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

  final VerificationMeta _isNewsFeedMeta = const VerificationMeta('isNewsFeed');
  GeneratedBoolColumn _isNewsFeed;
  @override
  GeneratedBoolColumn get isNewsFeed => _isNewsFeed ??= _constructIsNewsFeed();
  GeneratedBoolColumn _constructIsNewsFeed() {
    return GeneratedBoolColumn('is_news_feed', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  GeneratedTextColumn _serverID;
  @override
  GeneratedTextColumn get serverID => _serverID ??= _constructServerID();
  GeneratedTextColumn _constructServerID() {
    return GeneratedTextColumn('server_i_d', $tableName, true,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, isNewsFeed, serverID, synced];
  @override
  $FeedsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feeds';
  @override
  final String actualTableName = 'feeds';
  @override
  VerificationContext validateIntegrity(Insertable<Feed> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_news_feed')) {
      context.handle(
          _isNewsFeedMeta,
          isNewsFeed.isAcceptableOrUnknown(
              data['is_news_feed'], _isNewsFeedMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d'], _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
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
  final String serverID;
  final bool synced;
  FeedEntry(
      {@required this.id,
      @required this.feed,
      @required this.date,
      @required this.type,
      @required this.isNew,
      @required this.params,
      this.serverID,
      @required this.synced});
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
      serverID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || feed != null) {
      map['feed'] = Variable<int>(feed);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || isNew != null) {
      map['is_new'] = Variable<bool>(isNew);
    }
    if (!nullToAbsent || params != null) {
      map['params'] = Variable<String>(params);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String>(serverID);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  FeedEntriesCompanion toCompanion(bool nullToAbsent) {
    return FeedEntriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feed: feed == null && nullToAbsent ? const Value.absent() : Value(feed),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      isNew:
          isNew == null && nullToAbsent ? const Value.absent() : Value(isNew),
      params:
          params == null && nullToAbsent ? const Value.absent() : Value(params),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
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
      serverID: serializer.fromJson<String>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
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
      'serverID': serializer.toJson<String>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FeedEntry copyWith(
          {int id,
          int feed,
          DateTime date,
          String type,
          bool isNew,
          String params,
          String serverID,
          bool synced}) =>
      FeedEntry(
        id: id ?? this.id,
        feed: feed ?? this.feed,
        date: date ?? this.date,
        type: type ?? this.type,
        isNew: isNew ?? this.isNew,
        params: params ?? this.params,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('FeedEntry(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('isNew: $isNew, ')
          ..write('params: $params, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feed.hashCode,
          $mrjc(
              date.hashCode,
              $mrjc(
                  type.hashCode,
                  $mrjc(
                      isNew.hashCode,
                      $mrjc(params.hashCode,
                          $mrjc(serverID.hashCode, synced.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FeedEntry &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.date == this.date &&
          other.type == this.type &&
          other.isNew == this.isNew &&
          other.params == this.params &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class FeedEntriesCompanion extends UpdateCompanion<FeedEntry> {
  final Value<int> id;
  final Value<int> feed;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<bool> isNew;
  final Value<String> params;
  final Value<String> serverID;
  final Value<bool> synced;
  const FeedEntriesCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.isNew = const Value.absent(),
    this.params = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  FeedEntriesCompanion.insert({
    this.id = const Value.absent(),
    @required int feed,
    @required DateTime date,
    @required String type,
    this.isNew = const Value.absent(),
    this.params = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : feed = Value(feed),
        date = Value(date),
        type = Value(type);
  static Insertable<FeedEntry> custom({
    Expression<int> id,
    Expression<int> feed,
    Expression<DateTime> date,
    Expression<String> type,
    Expression<bool> isNew,
    Expression<String> params,
    Expression<String> serverID,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feed != null) 'feed': feed,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (isNew != null) 'is_new': isNew,
      if (params != null) 'params': params,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  FeedEntriesCompanion copyWith(
      {Value<int> id,
      Value<int> feed,
      Value<DateTime> date,
      Value<String> type,
      Value<bool> isNew,
      Value<String> params,
      Value<String> serverID,
      Value<bool> synced}) {
    return FeedEntriesCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
      date: date ?? this.date,
      type: type ?? this.type,
      isNew: isNew ?? this.isNew,
      params: params ?? this.params,
      serverID: serverID ?? this.serverID,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feed.present) {
      map['feed'] = Variable<int>(feed.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    if (params.present) {
      map['params'] = Variable<String>(params.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
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

  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  GeneratedTextColumn _serverID;
  @override
  GeneratedTextColumn get serverID => _serverID ??= _constructServerID();
  GeneratedTextColumn _constructServerID() {
    return GeneratedTextColumn('server_i_d', $tableName, true,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, date, type, isNew, params, serverID, synced];
  @override
  $FeedEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feed_entries';
  @override
  final String actualTableName = 'feed_entries';
  @override
  VerificationContext validateIntegrity(Insertable<FeedEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed'], _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new'], _isNewMeta));
    }
    if (data.containsKey('params')) {
      context.handle(_paramsMeta,
          params.isAcceptableOrUnknown(data['params'], _paramsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d'], _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
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
  $FeedEntriesTable createAlias(String alias) {
    return $FeedEntriesTable(_db, alias);
  }
}

class FeedMedia extends DataClass implements Insertable<FeedMedia> {
  final int id;
  final int feed;
  final int feedEntry;
  final String filePath;
  final String thumbnailPath;
  final String params;
  final String serverID;
  final bool synced;
  FeedMedia(
      {@required this.id,
      @required this.feed,
      @required this.feedEntry,
      @required this.filePath,
      @required this.thumbnailPath,
      @required this.params,
      this.serverID,
      @required this.synced});
  factory FeedMedia.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return FeedMedia(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feed: intType.mapFromDatabaseResponse(data['${effectivePrefix}feed']),
      feedEntry:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}feed_entry']),
      filePath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}file_path']),
      thumbnailPath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_path']),
      params:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}params']),
      serverID: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || feed != null) {
      map['feed'] = Variable<int>(feed);
    }
    if (!nullToAbsent || feedEntry != null) {
      map['feed_entry'] = Variable<int>(feedEntry);
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || params != null) {
      map['params'] = Variable<String>(params);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String>(serverID);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  FeedMediasCompanion toCompanion(bool nullToAbsent) {
    return FeedMediasCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feed: feed == null && nullToAbsent ? const Value.absent() : Value(feed),
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
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory FeedMedia.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FeedMedia(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      feedEntry: serializer.fromJson<int>(json['feedEntry']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      params: serializer.fromJson<String>(json['params']),
      serverID: serializer.fromJson<String>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'feedEntry': serializer.toJson<int>(feedEntry),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'params': serializer.toJson<String>(params),
      'serverID': serializer.toJson<String>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FeedMedia copyWith(
          {int id,
          int feed,
          int feedEntry,
          String filePath,
          String thumbnailPath,
          String params,
          String serverID,
          bool synced}) =>
      FeedMedia(
        id: id ?? this.id,
        feed: feed ?? this.feed,
        feedEntry: feedEntry ?? this.feedEntry,
        filePath: filePath ?? this.filePath,
        thumbnailPath: thumbnailPath ?? this.thumbnailPath,
        params: params ?? this.params,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('FeedMedia(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('feedEntry: $feedEntry, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('params: $params, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feed.hashCode,
          $mrjc(
              feedEntry.hashCode,
              $mrjc(
                  filePath.hashCode,
                  $mrjc(
                      thumbnailPath.hashCode,
                      $mrjc(params.hashCode,
                          $mrjc(serverID.hashCode, synced.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FeedMedia &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.feedEntry == this.feedEntry &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.params == this.params &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class FeedMediasCompanion extends UpdateCompanion<FeedMedia> {
  final Value<int> id;
  final Value<int> feed;
  final Value<int> feedEntry;
  final Value<String> filePath;
  final Value<String> thumbnailPath;
  final Value<String> params;
  final Value<String> serverID;
  final Value<bool> synced;
  const FeedMediasCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.feedEntry = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.params = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  FeedMediasCompanion.insert({
    this.id = const Value.absent(),
    @required int feed,
    @required int feedEntry,
    @required String filePath,
    @required String thumbnailPath,
    this.params = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : feed = Value(feed),
        feedEntry = Value(feedEntry),
        filePath = Value(filePath),
        thumbnailPath = Value(thumbnailPath);
  static Insertable<FeedMedia> custom({
    Expression<int> id,
    Expression<int> feed,
    Expression<int> feedEntry,
    Expression<String> filePath,
    Expression<String> thumbnailPath,
    Expression<String> params,
    Expression<String> serverID,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feed != null) 'feed': feed,
      if (feedEntry != null) 'feed_entry': feedEntry,
      if (filePath != null) 'file_path': filePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (params != null) 'params': params,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  FeedMediasCompanion copyWith(
      {Value<int> id,
      Value<int> feed,
      Value<int> feedEntry,
      Value<String> filePath,
      Value<String> thumbnailPath,
      Value<String> params,
      Value<String> serverID,
      Value<bool> synced}) {
    return FeedMediasCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
      feedEntry: feedEntry ?? this.feedEntry,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      params: params ?? this.params,
      serverID: serverID ?? this.serverID,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feed.present) {
      map['feed'] = Variable<int>(feed.value);
    }
    if (feedEntry.present) {
      map['feed_entry'] = Variable<int>(feedEntry.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (params.present) {
      map['params'] = Variable<String>(params.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
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

  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  GeneratedTextColumn _serverID;
  @override
  GeneratedTextColumn get serverID => _serverID ??= _constructServerID();
  GeneratedTextColumn _constructServerID() {
    return GeneratedTextColumn('server_i_d', $tableName, true,
        minTextLength: 36, maxTextLength: 36);
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, feedEntry, filePath, thumbnailPath, params, serverID, synced];
  @override
  $FeedMediasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feed_medias';
  @override
  final String actualTableName = 'feed_medias';
  @override
  VerificationContext validateIntegrity(Insertable<FeedMedia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed'], _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('feed_entry')) {
      context.handle(_feedEntryMeta,
          feedEntry.isAcceptableOrUnknown(data['feed_entry'], _feedEntryMeta));
    } else if (isInserting) {
      context.missing(_feedEntryMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path'], _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
          _thumbnailPathMeta,
          thumbnailPath.isAcceptableOrUnknown(
              data['thumbnail_path'], _thumbnailPathMeta));
    } else if (isInserting) {
      context.missing(_thumbnailPathMeta);
    }
    if (data.containsKey('params')) {
      context.handle(_paramsMeta,
          params.isAcceptableOrUnknown(data['params'], _paramsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d'], _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
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
  $PlantsTable _plants;
  $PlantsTable get plants => _plants ??= $PlantsTable(this);
  $BoxesTable _boxes;
  $BoxesTable get boxes => _boxes ??= $BoxesTable(this);
  $ChartCachesTable _chartCaches;
  $ChartCachesTable get chartCaches => _chartCaches ??= $ChartCachesTable(this);
  $TimelapsesTable _timelapses;
  $TimelapsesTable get timelapses => _timelapses ??= $TimelapsesTable(this);
  $FeedsTable _feeds;
  $FeedsTable get feeds => _feeds ??= $FeedsTable(this);
  $FeedEntriesTable _feedEntries;
  $FeedEntriesTable get feedEntries => _feedEntries ??= $FeedEntriesTable(this);
  $FeedMediasTable _feedMedias;
  $FeedMediasTable get feedMedias => _feedMedias ??= $FeedMediasTable(this);
  DevicesDAO _devicesDAO;
  DevicesDAO get devicesDAO => _devicesDAO ??= DevicesDAO(this as RelDB);
  PlantsDAO _plantsDAO;
  PlantsDAO get plantsDAO => _plantsDAO ??= PlantsDAO(this as RelDB);
  FeedsDAO _feedsDAO;
  FeedsDAO get feedsDAO => _feedsDAO ??= FeedsDAO(this as RelDB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        devices,
        modules,
        params,
        plants,
        boxes,
        chartCaches,
        timelapses,
        feeds,
        feedEntries,
        feedMedias
      ];
}
