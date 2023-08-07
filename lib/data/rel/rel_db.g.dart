// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rel_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Device extends DataClass implements Insertable<Device> {
  final int id;
  final String identifier;
  final String name;
  final String ip;
  final String mdns;
  final bool isReachable;
  final bool isRemote;
  final bool isSetup;
  final String? config;
  final String? serverID;
  final bool synced;
  Device(
      {required this.id,
      required this.identifier,
      required this.name,
      required this.ip,
      required this.mdns,
      required this.isReachable,
      required this.isRemote,
      required this.isSetup,
      this.config,
      this.serverID,
      required this.synced});
  factory Device.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Device(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      identifier: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}identifier'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      ip: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ip'])!,
      mdns: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mdns'])!,
      isReachable: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_reachable'])!,
      isRemote: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_remote'])!,
      isSetup: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_setup'])!,
      config: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}config']),
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['identifier'] = Variable<String>(identifier);
    map['name'] = Variable<String>(name);
    map['ip'] = Variable<String>(ip);
    map['mdns'] = Variable<String>(mdns);
    map['is_reachable'] = Variable<bool>(isReachable);
    map['is_remote'] = Variable<bool>(isRemote);
    map['is_setup'] = Variable<bool>(isSetup);
    if (!nullToAbsent || config != null) {
      map['config'] = Variable<String?>(config);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      identifier: Value(identifier),
      name: Value(name),
      ip: Value(ip),
      mdns: Value(mdns),
      isReachable: Value(isReachable),
      isRemote: Value(isRemote),
      isSetup: Value(isSetup),
      config:
          config == null && nullToAbsent ? const Value.absent() : Value(config),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<int>(json['id']),
      identifier: serializer.fromJson<String>(json['identifier']),
      name: serializer.fromJson<String>(json['name']),
      ip: serializer.fromJson<String>(json['ip']),
      mdns: serializer.fromJson<String>(json['mdns']),
      isReachable: serializer.fromJson<bool>(json['isReachable']),
      isRemote: serializer.fromJson<bool>(json['isRemote']),
      isSetup: serializer.fromJson<bool>(json['isSetup']),
      config: serializer.fromJson<String?>(json['config']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'identifier': serializer.toJson<String>(identifier),
      'name': serializer.toJson<String>(name),
      'ip': serializer.toJson<String>(ip),
      'mdns': serializer.toJson<String>(mdns),
      'isReachable': serializer.toJson<bool>(isReachable),
      'isRemote': serializer.toJson<bool>(isRemote),
      'isSetup': serializer.toJson<bool>(isSetup),
      'config': serializer.toJson<String?>(config),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Device copyWith(
          {int? id,
          String? identifier,
          String? name,
          String? ip,
          String? mdns,
          bool? isReachable,
          bool? isRemote,
          bool? isSetup,
          String? config,
          String? serverID,
          bool? synced}) =>
      Device(
        id: id ?? this.id,
        identifier: identifier ?? this.identifier,
        name: name ?? this.name,
        ip: ip ?? this.ip,
        mdns: mdns ?? this.mdns,
        isReachable: isReachable ?? this.isReachable,
        isRemote: isRemote ?? this.isRemote,
        isSetup: isSetup ?? this.isSetup,
        config: config ?? this.config,
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
          ..write('isRemote: $isRemote, ')
          ..write('isSetup: $isSetup, ')
          ..write('config: $config, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, identifier, name, ip, mdns, isReachable,
      isRemote, isSetup, config, serverID, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.identifier == this.identifier &&
          other.name == this.name &&
          other.ip == this.ip &&
          other.mdns == this.mdns &&
          other.isReachable == this.isReachable &&
          other.isRemote == this.isRemote &&
          other.isSetup == this.isSetup &&
          other.config == this.config &&
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
  final Value<bool> isRemote;
  final Value<bool> isSetup;
  final Value<String?> config;
  final Value<String?> serverID;
  final Value<bool> synced;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.identifier = const Value.absent(),
    this.name = const Value.absent(),
    this.ip = const Value.absent(),
    this.mdns = const Value.absent(),
    this.isReachable = const Value.absent(),
    this.isRemote = const Value.absent(),
    this.isSetup = const Value.absent(),
    this.config = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    required String identifier,
    required String name,
    required String ip,
    required String mdns,
    this.isReachable = const Value.absent(),
    this.isRemote = const Value.absent(),
    this.isSetup = const Value.absent(),
    this.config = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : identifier = Value(identifier),
        name = Value(name),
        ip = Value(ip),
        mdns = Value(mdns);
  static Insertable<Device> custom({
    Expression<int>? id,
    Expression<String>? identifier,
    Expression<String>? name,
    Expression<String>? ip,
    Expression<String>? mdns,
    Expression<bool>? isReachable,
    Expression<bool>? isRemote,
    Expression<bool>? isSetup,
    Expression<String?>? config,
    Expression<String?>? serverID,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (identifier != null) 'identifier': identifier,
      if (name != null) 'name': name,
      if (ip != null) 'ip': ip,
      if (mdns != null) 'mdns': mdns,
      if (isReachable != null) 'is_reachable': isReachable,
      if (isRemote != null) 'is_remote': isRemote,
      if (isSetup != null) 'is_setup': isSetup,
      if (config != null) 'config': config,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  DevicesCompanion copyWith(
      {Value<int>? id,
      Value<String>? identifier,
      Value<String>? name,
      Value<String>? ip,
      Value<String>? mdns,
      Value<bool>? isReachable,
      Value<bool>? isRemote,
      Value<bool>? isSetup,
      Value<String?>? config,
      Value<String?>? serverID,
      Value<bool>? synced}) {
    return DevicesCompanion(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      mdns: mdns ?? this.mdns,
      isReachable: isReachable ?? this.isReachable,
      isRemote: isRemote ?? this.isRemote,
      isSetup: isSetup ?? this.isSetup,
      config: config ?? this.config,
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
    if (isRemote.present) {
      map['is_remote'] = Variable<bool>(isRemote.value);
    }
    if (isSetup.present) {
      map['is_setup'] = Variable<bool>(isSetup.value);
    }
    if (config.present) {
      map['config'] = Variable<String?>(config.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('ip: $ip, ')
          ..write('mdns: $mdns, ')
          ..write('isReachable: $isReachable, ')
          ..write('isRemote: $isRemote, ')
          ..write('isSetup: $isSetup, ')
          ..write('config: $config, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _identifierMeta = const VerificationMeta('identifier');
  @override
  late final GeneratedColumn<String?> identifier = GeneratedColumn<String?>(
      'identifier', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 24),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _ipMeta = const VerificationMeta('ip');
  @override
  late final GeneratedColumn<String?> ip = GeneratedColumn<String?>(
      'ip', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 7, maxTextLength: 15),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _mdnsMeta = const VerificationMeta('mdns');
  @override
  late final GeneratedColumn<String?> mdns = GeneratedColumn<String?>(
      'mdns', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _isReachableMeta =
      const VerificationMeta('isReachable');
  @override
  late final GeneratedColumn<bool?> isReachable = GeneratedColumn<bool?>(
      'is_reachable', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_reachable IN (0, 1))',
      defaultValue: Constant(true));
  final VerificationMeta _isRemoteMeta = const VerificationMeta('isRemote');
  @override
  late final GeneratedColumn<bool?> isRemote = GeneratedColumn<bool?>(
      'is_remote', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_remote IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _isSetupMeta = const VerificationMeta('isSetup');
  @override
  late final GeneratedColumn<bool?> isSetup = GeneratedColumn<bool?>(
      'is_setup', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_setup IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumn<String?> config = GeneratedColumn<String?>(
      'config', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        identifier,
        name,
        ip,
        mdns,
        isReachable,
        isRemote,
        isSetup,
        config,
        serverID,
        synced
      ];
  @override
  String get aliasedName => _alias ?? 'devices';
  @override
  String get actualTableName => 'devices';
  @override
  VerificationContext validateIntegrity(Insertable<Device> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('identifier')) {
      context.handle(
          _identifierMeta,
          identifier.isAcceptableOrUnknown(
              data['identifier']!, _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip']!, _ipMeta));
    } else if (isInserting) {
      context.missing(_ipMeta);
    }
    if (data.containsKey('mdns')) {
      context.handle(
          _mdnsMeta, mdns.isAcceptableOrUnknown(data['mdns']!, _mdnsMeta));
    } else if (isInserting) {
      context.missing(_mdnsMeta);
    }
    if (data.containsKey('is_reachable')) {
      context.handle(
          _isReachableMeta,
          isReachable.isAcceptableOrUnknown(
              data['is_reachable']!, _isReachableMeta));
    }
    if (data.containsKey('is_remote')) {
      context.handle(_isRemoteMeta,
          isRemote.isAcceptableOrUnknown(data['is_remote']!, _isRemoteMeta));
    }
    if (data.containsKey('is_setup')) {
      context.handle(_isSetupMeta,
          isSetup.isAcceptableOrUnknown(data['is_setup']!, _isSetupMeta));
    }
    if (data.containsKey('config')) {
      context.handle(_configMeta,
          config.isAcceptableOrUnknown(data['config']!, _configMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Device.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Module extends DataClass implements Insertable<Module> {
  final int id;
  final int device;
  final String name;
  final bool isArray;
  final int arrayLen;
  Module(
      {required this.id,
      required this.device,
      required this.name,
      required this.isArray,
      required this.arrayLen});
  factory Module.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Module(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      device: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}device'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      isArray: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_array'])!,
      arrayLen: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}array_len'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device'] = Variable<int>(device);
    map['name'] = Variable<String>(name);
    map['is_array'] = Variable<bool>(isArray);
    map['array_len'] = Variable<int>(arrayLen);
    return map;
  }

  ModulesCompanion toCompanion(bool nullToAbsent) {
    return ModulesCompanion(
      id: Value(id),
      device: Value(device),
      name: Value(name),
      isArray: Value(isArray),
      arrayLen: Value(arrayLen),
    );
  }

  factory Module.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Module(
      id: serializer.fromJson<int>(json['id']),
      device: serializer.fromJson<int>(json['device']),
      name: serializer.fromJson<String>(json['name']),
      isArray: serializer.fromJson<bool>(json['isArray']),
      arrayLen: serializer.fromJson<int>(json['arrayLen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'device': serializer.toJson<int>(device),
      'name': serializer.toJson<String>(name),
      'isArray': serializer.toJson<bool>(isArray),
      'arrayLen': serializer.toJson<int>(arrayLen),
    };
  }

  Module copyWith(
          {int? id, int? device, String? name, bool? isArray, int? arrayLen}) =>
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
  int get hashCode => Object.hash(id, device, name, isArray, arrayLen);
  @override
  bool operator ==(Object other) =>
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
    required int device,
    required String name,
    required bool isArray,
    required int arrayLen,
  })  : device = Value(device),
        name = Value(name),
        isArray = Value(isArray),
        arrayLen = Value(arrayLen);
  static Insertable<Module> custom({
    Expression<int>? id,
    Expression<int>? device,
    Expression<String>? name,
    Expression<bool>? isArray,
    Expression<int>? arrayLen,
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
      {Value<int>? id,
      Value<int>? device,
      Value<String>? name,
      Value<bool>? isArray,
      Value<int>? arrayLen}) {
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

  @override
  String toString() {
    return (StringBuffer('ModulesCompanion(')
          ..write('id: $id, ')
          ..write('device: $device, ')
          ..write('name: $name, ')
          ..write('isArray: $isArray, ')
          ..write('arrayLen: $arrayLen')
          ..write(')'))
        .toString();
  }
}

class $ModulesTable extends Modules with TableInfo<$ModulesTable, Module> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModulesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<int?> device = GeneratedColumn<int?>(
      'device', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 24),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _isArrayMeta = const VerificationMeta('isArray');
  @override
  late final GeneratedColumn<bool?> isArray = GeneratedColumn<bool?>(
      'is_array', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_array IN (0, 1))');
  final VerificationMeta _arrayLenMeta = const VerificationMeta('arrayLen');
  @override
  late final GeneratedColumn<int?> arrayLen = GeneratedColumn<int?>(
      'array_len', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, device, name, isArray, arrayLen];
  @override
  String get aliasedName => _alias ?? 'modules';
  @override
  String get actualTableName => 'modules';
  @override
  VerificationContext validateIntegrity(Insertable<Module> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device']!, _deviceMeta));
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_array')) {
      context.handle(_isArrayMeta,
          isArray.isAcceptableOrUnknown(data['is_array']!, _isArrayMeta));
    } else if (isInserting) {
      context.missing(_isArrayMeta);
    }
    if (data.containsKey('array_len')) {
      context.handle(_arrayLenMeta,
          arrayLen.isAcceptableOrUnknown(data['array_len']!, _arrayLenMeta));
    } else if (isInserting) {
      context.missing(_arrayLenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Module map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Module.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ModulesTable createAlias(String alias) {
    return $ModulesTable(attachedDatabase, alias);
  }
}

class Param extends DataClass implements Insertable<Param> {
  final int id;
  final int device;
  final int module;
  final String key;
  final int type;
  final String? svalue;
  final int? ivalue;
  Param(
      {required this.id,
      required this.device,
      required this.module,
      required this.key,
      required this.type,
      this.svalue,
      this.ivalue});
  factory Param.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Param(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      device: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}device'])!,
      module: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}module'])!,
      key: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      svalue: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}svalue']),
      ivalue: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ivalue']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device'] = Variable<int>(device);
    map['module'] = Variable<int>(module);
    map['key'] = Variable<String>(key);
    map['type'] = Variable<int>(type);
    if (!nullToAbsent || svalue != null) {
      map['svalue'] = Variable<String?>(svalue);
    }
    if (!nullToAbsent || ivalue != null) {
      map['ivalue'] = Variable<int?>(ivalue);
    }
    return map;
  }

  ParamsCompanion toCompanion(bool nullToAbsent) {
    return ParamsCompanion(
      id: Value(id),
      device: Value(device),
      module: Value(module),
      key: Value(key),
      type: Value(type),
      svalue:
          svalue == null && nullToAbsent ? const Value.absent() : Value(svalue),
      ivalue:
          ivalue == null && nullToAbsent ? const Value.absent() : Value(ivalue),
    );
  }

  factory Param.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Param(
      id: serializer.fromJson<int>(json['id']),
      device: serializer.fromJson<int>(json['device']),
      module: serializer.fromJson<int>(json['module']),
      key: serializer.fromJson<String>(json['key']),
      type: serializer.fromJson<int>(json['type']),
      svalue: serializer.fromJson<String?>(json['svalue']),
      ivalue: serializer.fromJson<int?>(json['ivalue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'device': serializer.toJson<int>(device),
      'module': serializer.toJson<int>(module),
      'key': serializer.toJson<String>(key),
      'type': serializer.toJson<int>(type),
      'svalue': serializer.toJson<String?>(svalue),
      'ivalue': serializer.toJson<int?>(ivalue),
    };
  }

  Param copyWith(
          {int? id,
          int? device,
          int? module,
          String? key,
          int? type,
          String? svalue,
          int? ivalue}) =>
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
  int get hashCode =>
      Object.hash(id, device, module, key, type, svalue, ivalue);
  @override
  bool operator ==(Object other) =>
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
  final Value<String?> svalue;
  final Value<int?> ivalue;
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
    required int device,
    required int module,
    required String key,
    required int type,
    this.svalue = const Value.absent(),
    this.ivalue = const Value.absent(),
  })  : device = Value(device),
        module = Value(module),
        key = Value(key),
        type = Value(type);
  static Insertable<Param> custom({
    Expression<int>? id,
    Expression<int>? device,
    Expression<int>? module,
    Expression<String>? key,
    Expression<int>? type,
    Expression<String?>? svalue,
    Expression<int?>? ivalue,
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
      {Value<int>? id,
      Value<int>? device,
      Value<int>? module,
      Value<String>? key,
      Value<int>? type,
      Value<String?>? svalue,
      Value<int?>? ivalue}) {
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
      map['svalue'] = Variable<String?>(svalue.value);
    }
    if (ivalue.present) {
      map['ivalue'] = Variable<int?>(ivalue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParamsCompanion(')
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
}

class $ParamsTable extends Params with TableInfo<$ParamsTable, Param> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParamsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<int?> device = GeneratedColumn<int?>(
      'device', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<int?> module = GeneratedColumn<int?>(
      'module', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String?> key = GeneratedColumn<String?>(
      'key', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _svalueMeta = const VerificationMeta('svalue');
  @override
  late final GeneratedColumn<String?> svalue = GeneratedColumn<String?>(
      'svalue', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _ivalueMeta = const VerificationMeta('ivalue');
  @override
  late final GeneratedColumn<int?> ivalue = GeneratedColumn<int?>(
      'ivalue', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, device, module, key, type, svalue, ivalue];
  @override
  String get aliasedName => _alias ?? 'params';
  @override
  String get actualTableName => 'params';
  @override
  VerificationContext validateIntegrity(Insertable<Param> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device']!, _deviceMeta));
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (data.containsKey('module')) {
      context.handle(_moduleMeta,
          module.isAcceptableOrUnknown(data['module']!, _moduleMeta));
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('svalue')) {
      context.handle(_svalueMeta,
          svalue.isAcceptableOrUnknown(data['svalue']!, _svalueMeta));
    }
    if (data.containsKey('ivalue')) {
      context.handle(_ivalueMeta,
          ivalue.isAcceptableOrUnknown(data['ivalue']!, _ivalueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Param map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Param.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ParamsTable createAlias(String alias) {
    return $ParamsTable(attachedDatabase, alias);
  }
}

class Plant extends DataClass implements Insertable<Plant> {
  final int id;
  final int feed;
  final int box;
  final String name;
  final bool single;
  final bool public;
  final bool alerts;
  final String settings;
  final String? serverID;
  final bool synced;
  Plant(
      {required this.id,
      required this.feed,
      required this.box,
      required this.name,
      required this.single,
      required this.public,
      required this.alerts,
      required this.settings,
      this.serverID,
      required this.synced});
  factory Plant.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Plant(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      feed: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}feed'])!,
      box: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}box'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      single: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}single'])!,
      public: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}public'])!,
      alerts: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}alerts'])!,
      settings: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}settings'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feed'] = Variable<int>(feed);
    map['box'] = Variable<int>(box);
    map['name'] = Variable<String>(name);
    map['single'] = Variable<bool>(single);
    map['public'] = Variable<bool>(public);
    map['alerts'] = Variable<bool>(alerts);
    map['settings'] = Variable<String>(settings);
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: Value(id),
      feed: Value(feed),
      box: Value(box),
      name: Value(name),
      single: Value(single),
      public: Value(public),
      alerts: Value(alerts),
      settings: Value(settings),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory Plant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plant(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      box: serializer.fromJson<int>(json['box']),
      name: serializer.fromJson<String>(json['name']),
      single: serializer.fromJson<bool>(json['single']),
      public: serializer.fromJson<bool>(json['public']),
      alerts: serializer.fromJson<bool>(json['alerts']),
      settings: serializer.fromJson<String>(json['settings']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'box': serializer.toJson<int>(box),
      'name': serializer.toJson<String>(name),
      'single': serializer.toJson<bool>(single),
      'public': serializer.toJson<bool>(public),
      'alerts': serializer.toJson<bool>(alerts),
      'settings': serializer.toJson<String>(settings),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Plant copyWith(
          {int? id,
          int? feed,
          int? box,
          String? name,
          bool? single,
          bool? public,
          bool? alerts,
          String? settings,
          String? serverID,
          bool? synced}) =>
      Plant(
        id: id ?? this.id,
        feed: feed ?? this.feed,
        box: box ?? this.box,
        name: name ?? this.name,
        single: single ?? this.single,
        public: public ?? this.public,
        alerts: alerts ?? this.alerts,
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
          ..write('public: $public, ')
          ..write('alerts: $alerts, ')
          ..write('settings: $settings, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, feed, box, name, single, public, alerts, settings, serverID, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.box == this.box &&
          other.name == this.name &&
          other.single == this.single &&
          other.public == this.public &&
          other.alerts == this.alerts &&
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
  final Value<bool> public;
  final Value<bool> alerts;
  final Value<String> settings;
  final Value<String?> serverID;
  final Value<bool> synced;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.box = const Value.absent(),
    this.name = const Value.absent(),
    this.single = const Value.absent(),
    this.public = const Value.absent(),
    this.alerts = const Value.absent(),
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  PlantsCompanion.insert({
    this.id = const Value.absent(),
    required int feed,
    required int box,
    required String name,
    this.single = const Value.absent(),
    this.public = const Value.absent(),
    this.alerts = const Value.absent(),
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : feed = Value(feed),
        box = Value(box),
        name = Value(name);
  static Insertable<Plant> custom({
    Expression<int>? id,
    Expression<int>? feed,
    Expression<int>? box,
    Expression<String>? name,
    Expression<bool>? single,
    Expression<bool>? public,
    Expression<bool>? alerts,
    Expression<String>? settings,
    Expression<String?>? serverID,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feed != null) 'feed': feed,
      if (box != null) 'box': box,
      if (name != null) 'name': name,
      if (single != null) 'single': single,
      if (public != null) 'public': public,
      if (alerts != null) 'alerts': alerts,
      if (settings != null) 'settings': settings,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  PlantsCompanion copyWith(
      {Value<int>? id,
      Value<int>? feed,
      Value<int>? box,
      Value<String>? name,
      Value<bool>? single,
      Value<bool>? public,
      Value<bool>? alerts,
      Value<String>? settings,
      Value<String?>? serverID,
      Value<bool>? synced}) {
    return PlantsCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
      box: box ?? this.box,
      name: name ?? this.name,
      single: single ?? this.single,
      public: public ?? this.public,
      alerts: alerts ?? this.alerts,
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
    if (public.present) {
      map['public'] = Variable<bool>(public.value);
    }
    if (alerts.present) {
      map['alerts'] = Variable<bool>(alerts.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsCompanion(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('box: $box, ')
          ..write('name: $name, ')
          ..write('single: $single, ')
          ..write('public: $public, ')
          ..write('alerts: $alerts, ')
          ..write('settings: $settings, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $PlantsTable extends Plants with TableInfo<$PlantsTable, Plant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _feedMeta = const VerificationMeta('feed');
  @override
  late final GeneratedColumn<int?> feed = GeneratedColumn<int?>(
      'feed', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _boxMeta = const VerificationMeta('box');
  @override
  late final GeneratedColumn<int?> box = GeneratedColumn<int?>(
      'box', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _singleMeta = const VerificationMeta('single');
  @override
  late final GeneratedColumn<bool?> single = GeneratedColumn<bool?>(
      'single', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (single IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _publicMeta = const VerificationMeta('public');
  @override
  late final GeneratedColumn<bool?> public = GeneratedColumn<bool?>(
      'public', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (public IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _alertsMeta = const VerificationMeta('alerts');
  @override
  late final GeneratedColumn<bool?> alerts = GeneratedColumn<bool?>(
      'alerts', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (alerts IN (0, 1))',
      defaultValue: Constant(true));
  final VerificationMeta _settingsMeta = const VerificationMeta('settings');
  @override
  late final GeneratedColumn<String?> settings = GeneratedColumn<String?>(
      'settings', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('{}'));
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, box, name, single, public, alerts, settings, serverID, synced];
  @override
  String get aliasedName => _alias ?? 'plants';
  @override
  String get actualTableName => 'plants';
  @override
  VerificationContext validateIntegrity(Insertable<Plant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed']!, _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('box')) {
      context.handle(
          _boxMeta, box.isAcceptableOrUnknown(data['box']!, _boxMeta));
    } else if (isInserting) {
      context.missing(_boxMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('single')) {
      context.handle(_singleMeta,
          single.isAcceptableOrUnknown(data['single']!, _singleMeta));
    }
    if (data.containsKey('public')) {
      context.handle(_publicMeta,
          public.isAcceptableOrUnknown(data['public']!, _publicMeta));
    }
    if (data.containsKey('alerts')) {
      context.handle(_alertsMeta,
          alerts.isAcceptableOrUnknown(data['alerts']!, _alertsMeta));
    }
    if (data.containsKey('settings')) {
      context.handle(_settingsMeta,
          settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plant map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Plant.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(attachedDatabase, alias);
  }
}

class Box extends DataClass implements Insertable<Box> {
  final int id;
  final int? feed;
  final int? device;
  final int? deviceBox;
  final String name;
  final String settings;
  final String? serverID;
  final bool synced;
  Box(
      {required this.id,
      this.feed,
      this.device,
      this.deviceBox,
      required this.name,
      required this.settings,
      this.serverID,
      required this.synced});
  factory Box.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Box(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      feed: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}feed']),
      device: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}device']),
      deviceBox: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}device_box']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      settings: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}settings'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || feed != null) {
      map['feed'] = Variable<int?>(feed);
    }
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<int?>(device);
    }
    if (!nullToAbsent || deviceBox != null) {
      map['device_box'] = Variable<int?>(deviceBox);
    }
    map['name'] = Variable<String>(name);
    map['settings'] = Variable<String>(settings);
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  BoxesCompanion toCompanion(bool nullToAbsent) {
    return BoxesCompanion(
      id: Value(id),
      feed: feed == null && nullToAbsent ? const Value.absent() : Value(feed),
      device:
          device == null && nullToAbsent ? const Value.absent() : Value(device),
      deviceBox: deviceBox == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceBox),
      name: Value(name),
      settings: Value(settings),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory Box.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Box(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int?>(json['feed']),
      device: serializer.fromJson<int?>(json['device']),
      deviceBox: serializer.fromJson<int?>(json['deviceBox']),
      name: serializer.fromJson<String>(json['name']),
      settings: serializer.fromJson<String>(json['settings']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int?>(feed),
      'device': serializer.toJson<int?>(device),
      'deviceBox': serializer.toJson<int?>(deviceBox),
      'name': serializer.toJson<String>(name),
      'settings': serializer.toJson<String>(settings),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Box copyWith(
          {int? id,
          int? feed,
          int? device,
          int? deviceBox,
          String? name,
          String? settings,
          String? serverID,
          bool? synced}) =>
      Box(
        id: id ?? this.id,
        feed: feed ?? this.feed,
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
          ..write('feed: $feed, ')
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
  int get hashCode => Object.hash(
      id, feed, device, deviceBox, name, settings, serverID, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Box &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.device == this.device &&
          other.deviceBox == this.deviceBox &&
          other.name == this.name &&
          other.settings == this.settings &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class BoxesCompanion extends UpdateCompanion<Box> {
  final Value<int> id;
  final Value<int?> feed;
  final Value<int?> device;
  final Value<int?> deviceBox;
  final Value<String> name;
  final Value<String> settings;
  final Value<String?> serverID;
  final Value<bool> synced;
  const BoxesCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.device = const Value.absent(),
    this.deviceBox = const Value.absent(),
    this.name = const Value.absent(),
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  BoxesCompanion.insert({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.device = const Value.absent(),
    this.deviceBox = const Value.absent(),
    required String name,
    this.settings = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Box> custom({
    Expression<int>? id,
    Expression<int?>? feed,
    Expression<int?>? device,
    Expression<int?>? deviceBox,
    Expression<String>? name,
    Expression<String>? settings,
    Expression<String?>? serverID,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feed != null) 'feed': feed,
      if (device != null) 'device': device,
      if (deviceBox != null) 'device_box': deviceBox,
      if (name != null) 'name': name,
      if (settings != null) 'settings': settings,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  BoxesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? feed,
      Value<int?>? device,
      Value<int?>? deviceBox,
      Value<String>? name,
      Value<String>? settings,
      Value<String?>? serverID,
      Value<bool>? synced}) {
    return BoxesCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
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
    if (feed.present) {
      map['feed'] = Variable<int?>(feed.value);
    }
    if (device.present) {
      map['device'] = Variable<int?>(device.value);
    }
    if (deviceBox.present) {
      map['device_box'] = Variable<int?>(deviceBox.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoxesCompanion(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('device: $device, ')
          ..write('deviceBox: $deviceBox, ')
          ..write('name: $name, ')
          ..write('settings: $settings, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $BoxesTable extends Boxes with TableInfo<$BoxesTable, Box> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoxesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _feedMeta = const VerificationMeta('feed');
  @override
  late final GeneratedColumn<int?> feed = GeneratedColumn<int?>(
      'feed', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<int?> device = GeneratedColumn<int?>(
      'device', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _deviceBoxMeta = const VerificationMeta('deviceBox');
  @override
  late final GeneratedColumn<int?> deviceBox = GeneratedColumn<int?>(
      'device_box', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _settingsMeta = const VerificationMeta('settings');
  @override
  late final GeneratedColumn<String?> settings = GeneratedColumn<String?>(
      'settings', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('{}'));
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, device, deviceBox, name, settings, serverID, synced];
  @override
  String get aliasedName => _alias ?? 'boxes';
  @override
  String get actualTableName => 'boxes';
  @override
  VerificationContext validateIntegrity(Insertable<Box> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed']!, _feedMeta));
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device']!, _deviceMeta));
    }
    if (data.containsKey('device_box')) {
      context.handle(_deviceBoxMeta,
          deviceBox.isAcceptableOrUnknown(data['device_box']!, _deviceBoxMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('settings')) {
      context.handle(_settingsMeta,
          settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Box map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Box.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BoxesTable createAlias(String alias) {
    return $BoxesTable(attachedDatabase, alias);
  }
}

class ChartCache extends DataClass implements Insertable<ChartCache> {
  final int id;
  final int box;
  final String name;
  final DateTime date;
  final String values;
  ChartCache(
      {required this.id,
      required this.box,
      required this.name,
      required this.date,
      required this.values});
  factory ChartCache.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChartCache(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      box: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}box'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      values: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}values'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['box'] = Variable<int>(box);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<DateTime>(date);
    map['values'] = Variable<String>(values);
    return map;
  }

  ChartCachesCompanion toCompanion(bool nullToAbsent) {
    return ChartCachesCompanion(
      id: Value(id),
      box: Value(box),
      name: Value(name),
      date: Value(date),
      values: Value(values),
    );
  }

  factory ChartCache.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChartCache(
      id: serializer.fromJson<int>(json['id']),
      box: serializer.fromJson<int>(json['box']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      values: serializer.fromJson<String>(json['values']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'box': serializer.toJson<int>(box),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'values': serializer.toJson<String>(values),
    };
  }

  ChartCache copyWith(
          {int? id, int? box, String? name, DateTime? date, String? values}) =>
      ChartCache(
        id: id ?? this.id,
        box: box ?? this.box,
        name: name ?? this.name,
        date: date ?? this.date,
        values: values ?? this.values,
      );
  @override
  String toString() {
    return (StringBuffer('ChartCache(')
          ..write('id: $id, ')
          ..write('box: $box, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('values: $values')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, box, name, date, values);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartCache &&
          other.id == this.id &&
          other.box == this.box &&
          other.name == this.name &&
          other.date == this.date &&
          other.values == this.values);
}

class ChartCachesCompanion extends UpdateCompanion<ChartCache> {
  final Value<int> id;
  final Value<int> box;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<String> values;
  const ChartCachesCompanion({
    this.id = const Value.absent(),
    this.box = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.values = const Value.absent(),
  });
  ChartCachesCompanion.insert({
    this.id = const Value.absent(),
    required int box,
    required String name,
    required DateTime date,
    this.values = const Value.absent(),
  })  : box = Value(box),
        name = Value(name),
        date = Value(date);
  static Insertable<ChartCache> custom({
    Expression<int>? id,
    Expression<int>? box,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<String>? values,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (box != null) 'box': box,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (values != null) 'values': values,
    });
  }

  ChartCachesCompanion copyWith(
      {Value<int>? id,
      Value<int>? box,
      Value<String>? name,
      Value<DateTime>? date,
      Value<String>? values}) {
    return ChartCachesCompanion(
      id: id ?? this.id,
      box: box ?? this.box,
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
    if (box.present) {
      map['box'] = Variable<int>(box.value);
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

  @override
  String toString() {
    return (StringBuffer('ChartCachesCompanion(')
          ..write('id: $id, ')
          ..write('box: $box, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('values: $values')
          ..write(')'))
        .toString();
  }
}

class $ChartCachesTable extends ChartCaches
    with TableInfo<$ChartCachesTable, ChartCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartCachesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _boxMeta = const VerificationMeta('box');
  @override
  late final GeneratedColumn<int?> box = GeneratedColumn<int?>(
      'box', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _valuesMeta = const VerificationMeta('values');
  @override
  late final GeneratedColumn<String?> values = GeneratedColumn<String?>(
      'values', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [id, box, name, date, values];
  @override
  String get aliasedName => _alias ?? 'chart_caches';
  @override
  String get actualTableName => 'chart_caches';
  @override
  VerificationContext validateIntegrity(Insertable<ChartCache> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('box')) {
      context.handle(
          _boxMeta, box.isAcceptableOrUnknown(data['box']!, _boxMeta));
    } else if (isInserting) {
      context.missing(_boxMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('values')) {
      context.handle(_valuesMeta,
          values.isAcceptableOrUnknown(data['values']!, _valuesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ChartCache.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChartCachesTable createAlias(String alias) {
    return $ChartCachesTable(attachedDatabase, alias);
  }
}

class Timelapse extends DataClass implements Insertable<Timelapse> {
  final int id;
  final int plant;
  final String type;
  final String settings;
  final String? ssid;
  final String? password;
  final String? controllerID;
  final String? rotate;
  final String? name;
  final String? strain;
  final String? dropboxToken;
  final String? uploadName;
  final String? serverID;
  final bool synced;
  Timelapse(
      {required this.id,
      required this.plant,
      required this.type,
      required this.settings,
      this.ssid,
      this.password,
      this.controllerID,
      this.rotate,
      this.name,
      this.strain,
      this.dropboxToken,
      this.uploadName,
      this.serverID,
      required this.synced});
  factory Timelapse.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Timelapse(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      plant: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}plant'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      settings: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}settings'])!,
      ssid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ssid']),
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      controllerID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}controller_i_d']),
      rotate: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rotate']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      strain: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}strain']),
      dropboxToken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dropbox_token']),
      uploadName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}upload_name']),
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant'] = Variable<int>(plant);
    map['type'] = Variable<String>(type);
    map['settings'] = Variable<String>(settings);
    if (!nullToAbsent || ssid != null) {
      map['ssid'] = Variable<String?>(ssid);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String?>(password);
    }
    if (!nullToAbsent || controllerID != null) {
      map['controller_i_d'] = Variable<String?>(controllerID);
    }
    if (!nullToAbsent || rotate != null) {
      map['rotate'] = Variable<String?>(rotate);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || strain != null) {
      map['strain'] = Variable<String?>(strain);
    }
    if (!nullToAbsent || dropboxToken != null) {
      map['dropbox_token'] = Variable<String?>(dropboxToken);
    }
    if (!nullToAbsent || uploadName != null) {
      map['upload_name'] = Variable<String?>(uploadName);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  TimelapsesCompanion toCompanion(bool nullToAbsent) {
    return TimelapsesCompanion(
      id: Value(id),
      plant: Value(plant),
      type: Value(type),
      settings: Value(settings),
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
      synced: Value(synced),
    );
  }

  factory Timelapse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Timelapse(
      id: serializer.fromJson<int>(json['id']),
      plant: serializer.fromJson<int>(json['plant']),
      type: serializer.fromJson<String>(json['type']),
      settings: serializer.fromJson<String>(json['settings']),
      ssid: serializer.fromJson<String?>(json['ssid']),
      password: serializer.fromJson<String?>(json['password']),
      controllerID: serializer.fromJson<String?>(json['controllerID']),
      rotate: serializer.fromJson<String?>(json['rotate']),
      name: serializer.fromJson<String?>(json['name']),
      strain: serializer.fromJson<String?>(json['strain']),
      dropboxToken: serializer.fromJson<String?>(json['dropboxToken']),
      uploadName: serializer.fromJson<String?>(json['uploadName']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plant': serializer.toJson<int>(plant),
      'type': serializer.toJson<String>(type),
      'settings': serializer.toJson<String>(settings),
      'ssid': serializer.toJson<String?>(ssid),
      'password': serializer.toJson<String?>(password),
      'controllerID': serializer.toJson<String?>(controllerID),
      'rotate': serializer.toJson<String?>(rotate),
      'name': serializer.toJson<String?>(name),
      'strain': serializer.toJson<String?>(strain),
      'dropboxToken': serializer.toJson<String?>(dropboxToken),
      'uploadName': serializer.toJson<String?>(uploadName),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Timelapse copyWith(
          {int? id,
          int? plant,
          String? type,
          String? settings,
          String? ssid,
          String? password,
          String? controllerID,
          String? rotate,
          String? name,
          String? strain,
          String? dropboxToken,
          String? uploadName,
          String? serverID,
          bool? synced}) =>
      Timelapse(
        id: id ?? this.id,
        plant: plant ?? this.plant,
        type: type ?? this.type,
        settings: settings ?? this.settings,
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
          ..write('type: $type, ')
          ..write('settings: $settings, ')
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
  int get hashCode => Object.hash(
      id,
      plant,
      type,
      settings,
      ssid,
      password,
      controllerID,
      rotate,
      name,
      strain,
      dropboxToken,
      uploadName,
      serverID,
      synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Timelapse &&
          other.id == this.id &&
          other.plant == this.plant &&
          other.type == this.type &&
          other.settings == this.settings &&
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
  final Value<String> type;
  final Value<String> settings;
  final Value<String?> ssid;
  final Value<String?> password;
  final Value<String?> controllerID;
  final Value<String?> rotate;
  final Value<String?> name;
  final Value<String?> strain;
  final Value<String?> dropboxToken;
  final Value<String?> uploadName;
  final Value<String?> serverID;
  final Value<bool> synced;
  const TimelapsesCompanion({
    this.id = const Value.absent(),
    this.plant = const Value.absent(),
    this.type = const Value.absent(),
    this.settings = const Value.absent(),
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
    required int plant,
    this.type = const Value.absent(),
    this.settings = const Value.absent(),
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
    Expression<int>? id,
    Expression<int>? plant,
    Expression<String>? type,
    Expression<String>? settings,
    Expression<String?>? ssid,
    Expression<String?>? password,
    Expression<String?>? controllerID,
    Expression<String?>? rotate,
    Expression<String?>? name,
    Expression<String?>? strain,
    Expression<String?>? dropboxToken,
    Expression<String?>? uploadName,
    Expression<String?>? serverID,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plant != null) 'plant': plant,
      if (type != null) 'type': type,
      if (settings != null) 'settings': settings,
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
      {Value<int>? id,
      Value<int>? plant,
      Value<String>? type,
      Value<String>? settings,
      Value<String?>? ssid,
      Value<String?>? password,
      Value<String?>? controllerID,
      Value<String?>? rotate,
      Value<String?>? name,
      Value<String?>? strain,
      Value<String?>? dropboxToken,
      Value<String?>? uploadName,
      Value<String?>? serverID,
      Value<bool>? synced}) {
    return TimelapsesCompanion(
      id: id ?? this.id,
      plant: plant ?? this.plant,
      type: type ?? this.type,
      settings: settings ?? this.settings,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (ssid.present) {
      map['ssid'] = Variable<String?>(ssid.value);
    }
    if (password.present) {
      map['password'] = Variable<String?>(password.value);
    }
    if (controllerID.present) {
      map['controller_i_d'] = Variable<String?>(controllerID.value);
    }
    if (rotate.present) {
      map['rotate'] = Variable<String?>(rotate.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (strain.present) {
      map['strain'] = Variable<String?>(strain.value);
    }
    if (dropboxToken.present) {
      map['dropbox_token'] = Variable<String?>(dropboxToken.value);
    }
    if (uploadName.present) {
      map['upload_name'] = Variable<String?>(uploadName.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimelapsesCompanion(')
          ..write('id: $id, ')
          ..write('plant: $plant, ')
          ..write('type: $type, ')
          ..write('settings: $settings, ')
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
}

class $TimelapsesTable extends Timelapses
    with TableInfo<$TimelapsesTable, Timelapse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimelapsesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _plantMeta = const VerificationMeta('plant');
  @override
  late final GeneratedColumn<int?> plant = GeneratedColumn<int?>(
      'plant', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('dropbox'));
  final VerificationMeta _settingsMeta = const VerificationMeta('settings');
  @override
  late final GeneratedColumn<String?> settings = GeneratedColumn<String?>(
      'settings', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('{}'));
  final VerificationMeta _ssidMeta = const VerificationMeta('ssid');
  @override
  late final GeneratedColumn<String?> ssid = GeneratedColumn<String?>(
      'ssid', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedColumn<String?> password = GeneratedColumn<String?>(
      'password', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _controllerIDMeta =
      const VerificationMeta('controllerID');
  @override
  late final GeneratedColumn<String?> controllerID = GeneratedColumn<String?>(
      'controller_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _rotateMeta = const VerificationMeta('rotate');
  @override
  late final GeneratedColumn<String?> rotate = GeneratedColumn<String?>(
      'rotate', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _strainMeta = const VerificationMeta('strain');
  @override
  late final GeneratedColumn<String?> strain = GeneratedColumn<String?>(
      'strain', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _dropboxTokenMeta =
      const VerificationMeta('dropboxToken');
  @override
  late final GeneratedColumn<String?> dropboxToken = GeneratedColumn<String?>(
      'dropbox_token', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _uploadNameMeta = const VerificationMeta('uploadName');
  @override
  late final GeneratedColumn<String?> uploadName = GeneratedColumn<String?>(
      'upload_name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        plant,
        type,
        settings,
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
  String get aliasedName => _alias ?? 'timelapses';
  @override
  String get actualTableName => 'timelapses';
  @override
  VerificationContext validateIntegrity(Insertable<Timelapse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant')) {
      context.handle(
          _plantMeta, plant.isAcceptableOrUnknown(data['plant']!, _plantMeta));
    } else if (isInserting) {
      context.missing(_plantMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('settings')) {
      context.handle(_settingsMeta,
          settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta));
    }
    if (data.containsKey('ssid')) {
      context.handle(
          _ssidMeta, ssid.isAcceptableOrUnknown(data['ssid']!, _ssidMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('controller_i_d')) {
      context.handle(
          _controllerIDMeta,
          controllerID.isAcceptableOrUnknown(
              data['controller_i_d']!, _controllerIDMeta));
    }
    if (data.containsKey('rotate')) {
      context.handle(_rotateMeta,
          rotate.isAcceptableOrUnknown(data['rotate']!, _rotateMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('strain')) {
      context.handle(_strainMeta,
          strain.isAcceptableOrUnknown(data['strain']!, _strainMeta));
    }
    if (data.containsKey('dropbox_token')) {
      context.handle(
          _dropboxTokenMeta,
          dropboxToken.isAcceptableOrUnknown(
              data['dropbox_token']!, _dropboxTokenMeta));
    }
    if (data.containsKey('upload_name')) {
      context.handle(
          _uploadNameMeta,
          uploadName.isAcceptableOrUnknown(
              data['upload_name']!, _uploadNameMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Timelapse map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Timelapse.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TimelapsesTable createAlias(String alias) {
    return $TimelapsesTable(attachedDatabase, alias);
  }
}

class Feed extends DataClass implements Insertable<Feed> {
  final int id;
  final String name;
  final bool isNewsFeed;
  final String? serverID;
  final bool synced;
  Feed(
      {required this.id,
      required this.name,
      required this.isNewsFeed,
      this.serverID,
      required this.synced});
  factory Feed.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Feed(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      isNewsFeed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_news_feed'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_news_feed'] = Variable<bool>(isNewsFeed);
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  FeedsCompanion toCompanion(bool nullToAbsent) {
    return FeedsCompanion(
      id: Value(id),
      name: Value(name),
      isNewsFeed: Value(isNewsFeed),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory Feed.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Feed(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isNewsFeed: serializer.fromJson<bool>(json['isNewsFeed']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isNewsFeed': serializer.toJson<bool>(isNewsFeed),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Feed copyWith(
          {int? id,
          String? name,
          bool? isNewsFeed,
          String? serverID,
          bool? synced}) =>
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
  int get hashCode => Object.hash(id, name, isNewsFeed, serverID, synced);
  @override
  bool operator ==(Object other) =>
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
  final Value<String?> serverID;
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
    required String name,
    this.isNewsFeed = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Feed> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isNewsFeed,
    Expression<String?>? serverID,
    Expression<bool>? synced,
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
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? isNewsFeed,
      Value<String?>? serverID,
      Value<bool>? synced}) {
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
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isNewsFeed: $isNewsFeed, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $FeedsTable extends Feeds with TableInfo<$FeedsTable, Feed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 24),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _isNewsFeedMeta = const VerificationMeta('isNewsFeed');
  @override
  late final GeneratedColumn<bool?> isNewsFeed = GeneratedColumn<bool?>(
      'is_news_feed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_news_feed IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, isNewsFeed, serverID, synced];
  @override
  String get aliasedName => _alias ?? 'feeds';
  @override
  String get actualTableName => 'feeds';
  @override
  VerificationContext validateIntegrity(Insertable<Feed> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_news_feed')) {
      context.handle(
          _isNewsFeedMeta,
          isNewsFeed.isAcceptableOrUnknown(
              data['is_news_feed']!, _isNewsFeedMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Feed map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Feed.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FeedsTable createAlias(String alias) {
    return $FeedsTable(attachedDatabase, alias);
  }
}

class FeedEntry extends DataClass implements Insertable<FeedEntry> {
  final int id;
  final int feed;
  final DateTime date;
  final String type;
  final bool isNew;
  final String params;
  final String? serverID;
  final bool synced;
  FeedEntry(
      {required this.id,
      required this.feed,
      required this.date,
      required this.type,
      required this.isNew,
      required this.params,
      this.serverID,
      required this.synced});
  factory FeedEntry.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FeedEntry(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      feed: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}feed'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      isNew: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_new'])!,
      params: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}params'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feed'] = Variable<int>(feed);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['is_new'] = Variable<bool>(isNew);
    map['params'] = Variable<String>(params);
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  FeedEntriesCompanion toCompanion(bool nullToAbsent) {
    return FeedEntriesCompanion(
      id: Value(id),
      feed: Value(feed),
      date: Value(date),
      type: Value(type),
      isNew: Value(isNew),
      params: Value(params),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory FeedEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedEntry(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      params: serializer.fromJson<String>(json['params']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'isNew': serializer.toJson<bool>(isNew),
      'params': serializer.toJson<String>(params),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FeedEntry copyWith(
          {int? id,
          int? feed,
          DateTime? date,
          String? type,
          bool? isNew,
          String? params,
          String? serverID,
          bool? synced}) =>
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
  int get hashCode =>
      Object.hash(id, feed, date, type, isNew, params, serverID, synced);
  @override
  bool operator ==(Object other) =>
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
  final Value<String?> serverID;
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
    required int feed,
    required DateTime date,
    required String type,
    this.isNew = const Value.absent(),
    this.params = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : feed = Value(feed),
        date = Value(date),
        type = Value(type);
  static Insertable<FeedEntry> custom({
    Expression<int>? id,
    Expression<int>? feed,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<bool>? isNew,
    Expression<String>? params,
    Expression<String?>? serverID,
    Expression<bool>? synced,
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
      {Value<int>? id,
      Value<int>? feed,
      Value<DateTime>? date,
      Value<String>? type,
      Value<bool>? isNew,
      Value<String>? params,
      Value<String?>? serverID,
      Value<bool>? synced}) {
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
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedEntriesCompanion(')
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
}

class $FeedEntriesTable extends FeedEntries
    with TableInfo<$FeedEntriesTable, FeedEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedEntriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _feedMeta = const VerificationMeta('feed');
  @override
  late final GeneratedColumn<int?> feed = GeneratedColumn<int?>(
      'feed', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 24),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _paramsMeta = const VerificationMeta('params');
  @override
  late final GeneratedColumn<String?> params = GeneratedColumn<String?>(
      'params', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('{}'));
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, date, type, isNew, params, serverID, synced];
  @override
  String get aliasedName => _alias ?? 'feed_entries';
  @override
  String get actualTableName => 'feed_entries';
  @override
  VerificationContext validateIntegrity(Insertable<FeedEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed']!, _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('params')) {
      context.handle(_paramsMeta,
          params.isAcceptableOrUnknown(data['params']!, _paramsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FeedEntry.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FeedEntriesTable createAlias(String alias) {
    return $FeedEntriesTable(attachedDatabase, alias);
  }
}

class FeedEntryDraft extends DataClass implements Insertable<FeedEntryDraft> {
  final int id;
  final int feed;
  final String type;
  final String params;
  FeedEntryDraft(
      {required this.id,
      required this.feed,
      required this.type,
      required this.params});
  factory FeedEntryDraft.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FeedEntryDraft(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      feed: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}feed'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      params: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}params'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feed'] = Variable<int>(feed);
    map['type'] = Variable<String>(type);
    map['params'] = Variable<String>(params);
    return map;
  }

  FeedEntryDraftsCompanion toCompanion(bool nullToAbsent) {
    return FeedEntryDraftsCompanion(
      id: Value(id),
      feed: Value(feed),
      type: Value(type),
      params: Value(params),
    );
  }

  factory FeedEntryDraft.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedEntryDraft(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      type: serializer.fromJson<String>(json['type']),
      params: serializer.fromJson<String>(json['params']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'type': serializer.toJson<String>(type),
      'params': serializer.toJson<String>(params),
    };
  }

  FeedEntryDraft copyWith({int? id, int? feed, String? type, String? params}) =>
      FeedEntryDraft(
        id: id ?? this.id,
        feed: feed ?? this.feed,
        type: type ?? this.type,
        params: params ?? this.params,
      );
  @override
  String toString() {
    return (StringBuffer('FeedEntryDraft(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('type: $type, ')
          ..write('params: $params')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, feed, type, params);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedEntryDraft &&
          other.id == this.id &&
          other.feed == this.feed &&
          other.type == this.type &&
          other.params == this.params);
}

class FeedEntryDraftsCompanion extends UpdateCompanion<FeedEntryDraft> {
  final Value<int> id;
  final Value<int> feed;
  final Value<String> type;
  final Value<String> params;
  const FeedEntryDraftsCompanion({
    this.id = const Value.absent(),
    this.feed = const Value.absent(),
    this.type = const Value.absent(),
    this.params = const Value.absent(),
  });
  FeedEntryDraftsCompanion.insert({
    this.id = const Value.absent(),
    required int feed,
    required String type,
    this.params = const Value.absent(),
  })  : feed = Value(feed),
        type = Value(type);
  static Insertable<FeedEntryDraft> custom({
    Expression<int>? id,
    Expression<int>? feed,
    Expression<String>? type,
    Expression<String>? params,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feed != null) 'feed': feed,
      if (type != null) 'type': type,
      if (params != null) 'params': params,
    });
  }

  FeedEntryDraftsCompanion copyWith(
      {Value<int>? id,
      Value<int>? feed,
      Value<String>? type,
      Value<String>? params}) {
    return FeedEntryDraftsCompanion(
      id: id ?? this.id,
      feed: feed ?? this.feed,
      type: type ?? this.type,
      params: params ?? this.params,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (params.present) {
      map['params'] = Variable<String>(params.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedEntryDraftsCompanion(')
          ..write('id: $id, ')
          ..write('feed: $feed, ')
          ..write('type: $type, ')
          ..write('params: $params')
          ..write(')'))
        .toString();
  }
}

class $FeedEntryDraftsTable extends FeedEntryDrafts
    with TableInfo<$FeedEntryDraftsTable, FeedEntryDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedEntryDraftsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _feedMeta = const VerificationMeta('feed');
  @override
  late final GeneratedColumn<int?> feed = GeneratedColumn<int?>(
      'feed', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 24),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _paramsMeta = const VerificationMeta('params');
  @override
  late final GeneratedColumn<String?> params = GeneratedColumn<String?>(
      'params', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [id, feed, type, params];
  @override
  String get aliasedName => _alias ?? 'feed_entry_drafts';
  @override
  String get actualTableName => 'feed_entry_drafts';
  @override
  VerificationContext validateIntegrity(Insertable<FeedEntryDraft> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed']!, _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('params')) {
      context.handle(_paramsMeta,
          params.isAcceptableOrUnknown(data['params']!, _paramsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedEntryDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FeedEntryDraft.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FeedEntryDraftsTable createAlias(String alias) {
    return $FeedEntryDraftsTable(attachedDatabase, alias);
  }
}

class FeedMedia extends DataClass implements Insertable<FeedMedia> {
  final int id;
  final int feed;
  final int feedEntry;
  final String filePath;
  final String thumbnailPath;
  final String params;
  final String? serverID;
  final bool synced;
  FeedMedia(
      {required this.id,
      required this.feed,
      required this.feedEntry,
      required this.filePath,
      required this.thumbnailPath,
      required this.params,
      this.serverID,
      required this.synced});
  factory FeedMedia.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FeedMedia(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      feed: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}feed'])!,
      feedEntry: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}feed_entry'])!,
      filePath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}file_path'])!,
      thumbnailPath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_path'])!,
      params: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}params'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feed'] = Variable<int>(feed);
    map['feed_entry'] = Variable<int>(feedEntry);
    map['file_path'] = Variable<String>(filePath);
    map['thumbnail_path'] = Variable<String>(thumbnailPath);
    map['params'] = Variable<String>(params);
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  FeedMediasCompanion toCompanion(bool nullToAbsent) {
    return FeedMediasCompanion(
      id: Value(id),
      feed: Value(feed),
      feedEntry: Value(feedEntry),
      filePath: Value(filePath),
      thumbnailPath: Value(thumbnailPath),
      params: Value(params),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory FeedMedia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedMedia(
      id: serializer.fromJson<int>(json['id']),
      feed: serializer.fromJson<int>(json['feed']),
      feedEntry: serializer.fromJson<int>(json['feedEntry']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      params: serializer.fromJson<String>(json['params']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feed': serializer.toJson<int>(feed),
      'feedEntry': serializer.toJson<int>(feedEntry),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'params': serializer.toJson<String>(params),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FeedMedia copyWith(
          {int? id,
          int? feed,
          int? feedEntry,
          String? filePath,
          String? thumbnailPath,
          String? params,
          String? serverID,
          bool? synced}) =>
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
  int get hashCode => Object.hash(
      id, feed, feedEntry, filePath, thumbnailPath, params, serverID, synced);
  @override
  bool operator ==(Object other) =>
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
  final Value<String?> serverID;
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
    required int feed,
    required int feedEntry,
    required String filePath,
    required String thumbnailPath,
    this.params = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : feed = Value(feed),
        feedEntry = Value(feedEntry),
        filePath = Value(filePath),
        thumbnailPath = Value(thumbnailPath);
  static Insertable<FeedMedia> custom({
    Expression<int>? id,
    Expression<int>? feed,
    Expression<int>? feedEntry,
    Expression<String>? filePath,
    Expression<String>? thumbnailPath,
    Expression<String>? params,
    Expression<String?>? serverID,
    Expression<bool>? synced,
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
      {Value<int>? id,
      Value<int>? feed,
      Value<int>? feedEntry,
      Value<String>? filePath,
      Value<String>? thumbnailPath,
      Value<String>? params,
      Value<String?>? serverID,
      Value<bool>? synced}) {
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
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedMediasCompanion(')
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
}

class $FeedMediasTable extends FeedMedias
    with TableInfo<$FeedMediasTable, FeedMedia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedMediasTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _feedMeta = const VerificationMeta('feed');
  @override
  late final GeneratedColumn<int?> feed = GeneratedColumn<int?>(
      'feed', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _feedEntryMeta = const VerificationMeta('feedEntry');
  @override
  late final GeneratedColumn<int?> feedEntry = GeneratedColumn<int?>(
      'feed_entry', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _filePathMeta = const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String?> filePath = GeneratedColumn<String?>(
      'file_path', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _thumbnailPathMeta =
      const VerificationMeta('thumbnailPath');
  @override
  late final GeneratedColumn<String?> thumbnailPath = GeneratedColumn<String?>(
      'thumbnail_path', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _paramsMeta = const VerificationMeta('params');
  @override
  late final GeneratedColumn<String?> params = GeneratedColumn<String?>(
      'params', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('{}'));
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, feed, feedEntry, filePath, thumbnailPath, params, serverID, synced];
  @override
  String get aliasedName => _alias ?? 'feed_medias';
  @override
  String get actualTableName => 'feed_medias';
  @override
  VerificationContext validateIntegrity(Insertable<FeedMedia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feed')) {
      context.handle(
          _feedMeta, feed.isAcceptableOrUnknown(data['feed']!, _feedMeta));
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('feed_entry')) {
      context.handle(_feedEntryMeta,
          feedEntry.isAcceptableOrUnknown(data['feed_entry']!, _feedEntryMeta));
    } else if (isInserting) {
      context.missing(_feedEntryMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
          _thumbnailPathMeta,
          thumbnailPath.isAcceptableOrUnknown(
              data['thumbnail_path']!, _thumbnailPathMeta));
    } else if (isInserting) {
      context.missing(_thumbnailPathMeta);
    }
    if (data.containsKey('params')) {
      context.handle(_paramsMeta,
          params.isAcceptableOrUnknown(data['params']!, _paramsMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedMedia map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FeedMedia.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FeedMediasTable createAlias(String alias) {
    return $FeedMediasTable(attachedDatabase, alias);
  }
}

class Delete extends DataClass implements Insertable<Delete> {
  final int id;
  final String serverID;
  final String type;
  Delete({required this.id, required this.serverID, required this.type});
  factory Delete.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Delete(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_i_d'] = Variable<String>(serverID);
    map['type'] = Variable<String>(type);
    return map;
  }

  DeletesCompanion toCompanion(bool nullToAbsent) {
    return DeletesCompanion(
      id: Value(id),
      serverID: Value(serverID),
      type: Value(type),
    );
  }

  factory Delete.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Delete(
      id: serializer.fromJson<int>(json['id']),
      serverID: serializer.fromJson<String>(json['serverID']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverID': serializer.toJson<String>(serverID),
      'type': serializer.toJson<String>(type),
    };
  }

  Delete copyWith({int? id, String? serverID, String? type}) => Delete(
        id: id ?? this.id,
        serverID: serverID ?? this.serverID,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('Delete(')
          ..write('id: $id, ')
          ..write('serverID: $serverID, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverID, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Delete &&
          other.id == this.id &&
          other.serverID == this.serverID &&
          other.type == this.type);
}

class DeletesCompanion extends UpdateCompanion<Delete> {
  final Value<int> id;
  final Value<String> serverID;
  final Value<String> type;
  const DeletesCompanion({
    this.id = const Value.absent(),
    this.serverID = const Value.absent(),
    this.type = const Value.absent(),
  });
  DeletesCompanion.insert({
    this.id = const Value.absent(),
    required String serverID,
    required String type,
  })  : serverID = Value(serverID),
        type = Value(type);
  static Insertable<Delete> custom({
    Expression<int>? id,
    Expression<String>? serverID,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverID != null) 'server_i_d': serverID,
      if (type != null) 'type': type,
    });
  }

  DeletesCompanion copyWith(
      {Value<int>? id, Value<String>? serverID, Value<String>? type}) {
    return DeletesCompanion(
      id: id ?? this.id,
      serverID: serverID ?? this.serverID,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String>(serverID.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeletesCompanion(')
          ..write('id: $id, ')
          ..write('serverID: $serverID, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $DeletesTable extends Deletes with TableInfo<$DeletesTable, Delete> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeletesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: const StringType(),
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, serverID, type];
  @override
  String get aliasedName => _alias ?? 'deletes';
  @override
  String get actualTableName => 'deletes';
  @override
  VerificationContext validateIntegrity(Insertable<Delete> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    } else if (isInserting) {
      context.missing(_serverIDMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Delete map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Delete.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DeletesTable createAlias(String alias) {
    return $DeletesTable(attachedDatabase, alias);
  }
}

class Checklist extends DataClass implements Insertable<Checklist> {
  final int id;
  final int plant;
  final String? serverID;
  final bool synced;
  Checklist(
      {required this.id,
      required this.plant,
      this.serverID,
      required this.synced});
  factory Checklist.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Checklist(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      plant: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}plant'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant'] = Variable<int>(plant);
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ChecklistsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistsCompanion(
      id: Value(id),
      plant: Value(plant),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory Checklist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checklist(
      id: serializer.fromJson<int>(json['id']),
      plant: serializer.fromJson<int>(json['plant']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plant': serializer.toJson<int>(plant),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Checklist copyWith({int? id, int? plant, String? serverID, bool? synced}) =>
      Checklist(
        id: id ?? this.id,
        plant: plant ?? this.plant,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Checklist(')
          ..write('id: $id, ')
          ..write('plant: $plant, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plant, serverID, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checklist &&
          other.id == this.id &&
          other.plant == this.plant &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class ChecklistsCompanion extends UpdateCompanion<Checklist> {
  final Value<int> id;
  final Value<int> plant;
  final Value<String?> serverID;
  final Value<bool> synced;
  const ChecklistsCompanion({
    this.id = const Value.absent(),
    this.plant = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  ChecklistsCompanion.insert({
    this.id = const Value.absent(),
    required int plant,
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  }) : plant = Value(plant);
  static Insertable<Checklist> custom({
    Expression<int>? id,
    Expression<int>? plant,
    Expression<String?>? serverID,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plant != null) 'plant': plant,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  ChecklistsCompanion copyWith(
      {Value<int>? id,
      Value<int>? plant,
      Value<String?>? serverID,
      Value<bool>? synced}) {
    return ChecklistsCompanion(
      id: id ?? this.id,
      plant: plant ?? this.plant,
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
    if (serverID.present) {
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistsCompanion(')
          ..write('id: $id, ')
          ..write('plant: $plant, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $ChecklistsTable extends Checklists
    with TableInfo<$ChecklistsTable, Checklist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _plantMeta = const VerificationMeta('plant');
  @override
  late final GeneratedColumn<int?> plant = GeneratedColumn<int?>(
      'plant', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, plant, serverID, synced];
  @override
  String get aliasedName => _alias ?? 'checklists';
  @override
  String get actualTableName => 'checklists';
  @override
  VerificationContext validateIntegrity(Insertable<Checklist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant')) {
      context.handle(
          _plantMeta, plant.isAcceptableOrUnknown(data['plant']!, _plantMeta));
    } else if (isInserting) {
      context.missing(_plantMeta);
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Checklist map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Checklist.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChecklistsTable createAlias(String alias) {
    return $ChecklistsTable(attachedDatabase, alias);
  }
}

class ChecklistSeed extends DataClass implements Insertable<ChecklistSeed> {
  final int id;
  final int checklist;
  final String title;
  final String description;
  final String category;
  final bool public;
  final bool repeat;
  final String conditions;
  final String exitConditions;
  final String actions;
  final String? checklistServerID;
  final String? serverID;
  final bool synced;
  ChecklistSeed(
      {required this.id,
      required this.checklist,
      required this.title,
      required this.description,
      required this.category,
      required this.public,
      required this.repeat,
      required this.conditions,
      required this.exitConditions,
      required this.actions,
      this.checklistServerID,
      this.serverID,
      required this.synced});
  factory ChecklistSeed.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChecklistSeed(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      checklist: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}checklist'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      category: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category'])!,
      public: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}public'])!,
      repeat: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}repeat'])!,
      conditions: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}conditions'])!,
      exitConditions: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}exit_conditions'])!,
      actions: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}actions'])!,
      checklistServerID: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}checklist_server_i_d']),
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['checklist'] = Variable<int>(checklist);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['public'] = Variable<bool>(public);
    map['repeat'] = Variable<bool>(repeat);
    map['conditions'] = Variable<String>(conditions);
    map['exit_conditions'] = Variable<String>(exitConditions);
    map['actions'] = Variable<String>(actions);
    if (!nullToAbsent || checklistServerID != null) {
      map['checklist_server_i_d'] = Variable<String?>(checklistServerID);
    }
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ChecklistSeedsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistSeedsCompanion(
      id: Value(id),
      checklist: Value(checklist),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      public: Value(public),
      repeat: Value(repeat),
      conditions: Value(conditions),
      exitConditions: Value(exitConditions),
      actions: Value(actions),
      checklistServerID: checklistServerID == null && nullToAbsent
          ? const Value.absent()
          : Value(checklistServerID),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory ChecklistSeed.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistSeed(
      id: serializer.fromJson<int>(json['id']),
      checklist: serializer.fromJson<int>(json['checklist']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      public: serializer.fromJson<bool>(json['public']),
      repeat: serializer.fromJson<bool>(json['repeat']),
      conditions: serializer.fromJson<String>(json['conditions']),
      exitConditions: serializer.fromJson<String>(json['exitConditions']),
      actions: serializer.fromJson<String>(json['actions']),
      checklistServerID:
          serializer.fromJson<String?>(json['checklistServerID']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'checklist': serializer.toJson<int>(checklist),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'public': serializer.toJson<bool>(public),
      'repeat': serializer.toJson<bool>(repeat),
      'conditions': serializer.toJson<String>(conditions),
      'exitConditions': serializer.toJson<String>(exitConditions),
      'actions': serializer.toJson<String>(actions),
      'checklistServerID': serializer.toJson<String?>(checklistServerID),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ChecklistSeed copyWith(
          {int? id,
          int? checklist,
          String? title,
          String? description,
          String? category,
          bool? public,
          bool? repeat,
          String? conditions,
          String? exitConditions,
          String? actions,
          String? checklistServerID,
          String? serverID,
          bool? synced}) =>
      ChecklistSeed(
        id: id ?? this.id,
        checklist: checklist ?? this.checklist,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        public: public ?? this.public,
        repeat: repeat ?? this.repeat,
        conditions: conditions ?? this.conditions,
        exitConditions: exitConditions ?? this.exitConditions,
        actions: actions ?? this.actions,
        checklistServerID: checklistServerID ?? this.checklistServerID,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('ChecklistSeed(')
          ..write('id: $id, ')
          ..write('checklist: $checklist, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('public: $public, ')
          ..write('repeat: $repeat, ')
          ..write('conditions: $conditions, ')
          ..write('exitConditions: $exitConditions, ')
          ..write('actions: $actions, ')
          ..write('checklistServerID: $checklistServerID, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      checklist,
      title,
      description,
      category,
      public,
      repeat,
      conditions,
      exitConditions,
      actions,
      checklistServerID,
      serverID,
      synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistSeed &&
          other.id == this.id &&
          other.checklist == this.checklist &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.public == this.public &&
          other.repeat == this.repeat &&
          other.conditions == this.conditions &&
          other.exitConditions == this.exitConditions &&
          other.actions == this.actions &&
          other.checklistServerID == this.checklistServerID &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class ChecklistSeedsCompanion extends UpdateCompanion<ChecklistSeed> {
  final Value<int> id;
  final Value<int> checklist;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<bool> public;
  final Value<bool> repeat;
  final Value<String> conditions;
  final Value<String> exitConditions;
  final Value<String> actions;
  final Value<String?> checklistServerID;
  final Value<String?> serverID;
  final Value<bool> synced;
  const ChecklistSeedsCompanion({
    this.id = const Value.absent(),
    this.checklist = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.public = const Value.absent(),
    this.repeat = const Value.absent(),
    this.conditions = const Value.absent(),
    this.exitConditions = const Value.absent(),
    this.actions = const Value.absent(),
    this.checklistServerID = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  ChecklistSeedsCompanion.insert({
    this.id = const Value.absent(),
    required int checklist,
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.public = const Value.absent(),
    this.repeat = const Value.absent(),
    this.conditions = const Value.absent(),
    this.exitConditions = const Value.absent(),
    this.actions = const Value.absent(),
    this.checklistServerID = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  }) : checklist = Value(checklist);
  static Insertable<ChecklistSeed> custom({
    Expression<int>? id,
    Expression<int>? checklist,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<bool>? public,
    Expression<bool>? repeat,
    Expression<String>? conditions,
    Expression<String>? exitConditions,
    Expression<String>? actions,
    Expression<String?>? checklistServerID,
    Expression<String?>? serverID,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checklist != null) 'checklist': checklist,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (public != null) 'public': public,
      if (repeat != null) 'repeat': repeat,
      if (conditions != null) 'conditions': conditions,
      if (exitConditions != null) 'exit_conditions': exitConditions,
      if (actions != null) 'actions': actions,
      if (checklistServerID != null) 'checklist_server_i_d': checklistServerID,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  ChecklistSeedsCompanion copyWith(
      {Value<int>? id,
      Value<int>? checklist,
      Value<String>? title,
      Value<String>? description,
      Value<String>? category,
      Value<bool>? public,
      Value<bool>? repeat,
      Value<String>? conditions,
      Value<String>? exitConditions,
      Value<String>? actions,
      Value<String?>? checklistServerID,
      Value<String?>? serverID,
      Value<bool>? synced}) {
    return ChecklistSeedsCompanion(
      id: id ?? this.id,
      checklist: checklist ?? this.checklist,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      public: public ?? this.public,
      repeat: repeat ?? this.repeat,
      conditions: conditions ?? this.conditions,
      exitConditions: exitConditions ?? this.exitConditions,
      actions: actions ?? this.actions,
      checklistServerID: checklistServerID ?? this.checklistServerID,
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
    if (checklist.present) {
      map['checklist'] = Variable<int>(checklist.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (public.present) {
      map['public'] = Variable<bool>(public.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<bool>(repeat.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (exitConditions.present) {
      map['exit_conditions'] = Variable<String>(exitConditions.value);
    }
    if (actions.present) {
      map['actions'] = Variable<String>(actions.value);
    }
    if (checklistServerID.present) {
      map['checklist_server_i_d'] = Variable<String?>(checklistServerID.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistSeedsCompanion(')
          ..write('id: $id, ')
          ..write('checklist: $checklist, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('public: $public, ')
          ..write('repeat: $repeat, ')
          ..write('conditions: $conditions, ')
          ..write('exitConditions: $exitConditions, ')
          ..write('actions: $actions, ')
          ..write('checklistServerID: $checklistServerID, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $ChecklistSeedsTable extends ChecklistSeeds
    with TableInfo<$ChecklistSeedsTable, ChecklistSeed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistSeedsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _checklistMeta = const VerificationMeta('checklist');
  @override
  late final GeneratedColumn<int?> checklist = GeneratedColumn<int?>(
      'checklist', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant(''));
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant(''));
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String?> category = GeneratedColumn<String?>(
      'category', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant(''));
  final VerificationMeta _publicMeta = const VerificationMeta('public');
  @override
  late final GeneratedColumn<bool?> public = GeneratedColumn<bool?>(
      'public', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (public IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<bool?> repeat = GeneratedColumn<bool?>(
      'repeat', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (repeat IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _conditionsMeta = const VerificationMeta('conditions');
  @override
  late final GeneratedColumn<String?> conditions = GeneratedColumn<String?>(
      'conditions', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('[]'));
  final VerificationMeta _exitConditionsMeta =
      const VerificationMeta('exitConditions');
  @override
  late final GeneratedColumn<String?> exitConditions = GeneratedColumn<String?>(
      'exit_conditions', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('[]'));
  final VerificationMeta _actionsMeta = const VerificationMeta('actions');
  @override
  late final GeneratedColumn<String?> actions = GeneratedColumn<String?>(
      'actions', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('[]'));
  final VerificationMeta _checklistServerIDMeta =
      const VerificationMeta('checklistServerID');
  @override
  late final GeneratedColumn<String?> checklistServerID =
      GeneratedColumn<String?>('checklist_server_i_d', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 36, maxTextLength: 36),
          type: const StringType(),
          requiredDuringInsert: false);
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        checklist,
        title,
        description,
        category,
        public,
        repeat,
        conditions,
        exitConditions,
        actions,
        checklistServerID,
        serverID,
        synced
      ];
  @override
  String get aliasedName => _alias ?? 'checklist_seeds';
  @override
  String get actualTableName => 'checklist_seeds';
  @override
  VerificationContext validateIntegrity(Insertable<ChecklistSeed> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('checklist')) {
      context.handle(_checklistMeta,
          checklist.isAcceptableOrUnknown(data['checklist']!, _checklistMeta));
    } else if (isInserting) {
      context.missing(_checklistMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('public')) {
      context.handle(_publicMeta,
          public.isAcceptableOrUnknown(data['public']!, _publicMeta));
    }
    if (data.containsKey('repeat')) {
      context.handle(_repeatMeta,
          repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta));
    }
    if (data.containsKey('conditions')) {
      context.handle(
          _conditionsMeta,
          conditions.isAcceptableOrUnknown(
              data['conditions']!, _conditionsMeta));
    }
    if (data.containsKey('exit_conditions')) {
      context.handle(
          _exitConditionsMeta,
          exitConditions.isAcceptableOrUnknown(
              data['exit_conditions']!, _exitConditionsMeta));
    }
    if (data.containsKey('actions')) {
      context.handle(_actionsMeta,
          actions.isAcceptableOrUnknown(data['actions']!, _actionsMeta));
    }
    if (data.containsKey('checklist_server_i_d')) {
      context.handle(
          _checklistServerIDMeta,
          checklistServerID.isAcceptableOrUnknown(
              data['checklist_server_i_d']!, _checklistServerIDMeta));
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistSeed map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ChecklistSeed.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChecklistSeedsTable createAlias(String alias) {
    return $ChecklistSeedsTable(attachedDatabase, alias);
  }
}

class ChecklistLog extends DataClass implements Insertable<ChecklistLog> {
  final int id;
  final int checklistSeed;
  final int checklist;
  final String action;
  final bool checked;
  final bool skipped;
  final DateTime date;
  final String? serverID;
  final bool synced;
  ChecklistLog(
      {required this.id,
      required this.checklistSeed,
      required this.checklist,
      required this.action,
      required this.checked,
      required this.skipped,
      required this.date,
      this.serverID,
      required this.synced});
  factory ChecklistLog.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChecklistLog(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      checklistSeed: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}checklist_seed'])!,
      checklist: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}checklist'])!,
      action: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}action'])!,
      checked: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}checked'])!,
      skipped: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}skipped'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      serverID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_i_d']),
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['checklist_seed'] = Variable<int>(checklistSeed);
    map['checklist'] = Variable<int>(checklist);
    map['action'] = Variable<String>(action);
    map['checked'] = Variable<bool>(checked);
    map['skipped'] = Variable<bool>(skipped);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || serverID != null) {
      map['server_i_d'] = Variable<String?>(serverID);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ChecklistLogsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistLogsCompanion(
      id: Value(id),
      checklistSeed: Value(checklistSeed),
      checklist: Value(checklist),
      action: Value(action),
      checked: Value(checked),
      skipped: Value(skipped),
      date: Value(date),
      serverID: serverID == null && nullToAbsent
          ? const Value.absent()
          : Value(serverID),
      synced: Value(synced),
    );
  }

  factory ChecklistLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistLog(
      id: serializer.fromJson<int>(json['id']),
      checklistSeed: serializer.fromJson<int>(json['checklistSeed']),
      checklist: serializer.fromJson<int>(json['checklist']),
      action: serializer.fromJson<String>(json['action']),
      checked: serializer.fromJson<bool>(json['checked']),
      skipped: serializer.fromJson<bool>(json['skipped']),
      date: serializer.fromJson<DateTime>(json['date']),
      serverID: serializer.fromJson<String?>(json['serverID']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'checklistSeed': serializer.toJson<int>(checklistSeed),
      'checklist': serializer.toJson<int>(checklist),
      'action': serializer.toJson<String>(action),
      'checked': serializer.toJson<bool>(checked),
      'skipped': serializer.toJson<bool>(skipped),
      'date': serializer.toJson<DateTime>(date),
      'serverID': serializer.toJson<String?>(serverID),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ChecklistLog copyWith(
          {int? id,
          int? checklistSeed,
          int? checklist,
          String? action,
          bool? checked,
          bool? skipped,
          DateTime? date,
          String? serverID,
          bool? synced}) =>
      ChecklistLog(
        id: id ?? this.id,
        checklistSeed: checklistSeed ?? this.checklistSeed,
        checklist: checklist ?? this.checklist,
        action: action ?? this.action,
        checked: checked ?? this.checked,
        skipped: skipped ?? this.skipped,
        date: date ?? this.date,
        serverID: serverID ?? this.serverID,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('ChecklistLog(')
          ..write('id: $id, ')
          ..write('checklistSeed: $checklistSeed, ')
          ..write('checklist: $checklist, ')
          ..write('action: $action, ')
          ..write('checked: $checked, ')
          ..write('skipped: $skipped, ')
          ..write('date: $date, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, checklistSeed, checklist, action, checked,
      skipped, date, serverID, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistLog &&
          other.id == this.id &&
          other.checklistSeed == this.checklistSeed &&
          other.checklist == this.checklist &&
          other.action == this.action &&
          other.checked == this.checked &&
          other.skipped == this.skipped &&
          other.date == this.date &&
          other.serverID == this.serverID &&
          other.synced == this.synced);
}

class ChecklistLogsCompanion extends UpdateCompanion<ChecklistLog> {
  final Value<int> id;
  final Value<int> checklistSeed;
  final Value<int> checklist;
  final Value<String> action;
  final Value<bool> checked;
  final Value<bool> skipped;
  final Value<DateTime> date;
  final Value<String?> serverID;
  final Value<bool> synced;
  const ChecklistLogsCompanion({
    this.id = const Value.absent(),
    this.checklistSeed = const Value.absent(),
    this.checklist = const Value.absent(),
    this.action = const Value.absent(),
    this.checked = const Value.absent(),
    this.skipped = const Value.absent(),
    this.date = const Value.absent(),
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  });
  ChecklistLogsCompanion.insert({
    this.id = const Value.absent(),
    required int checklistSeed,
    required int checklist,
    this.action = const Value.absent(),
    this.checked = const Value.absent(),
    this.skipped = const Value.absent(),
    required DateTime date,
    this.serverID = const Value.absent(),
    this.synced = const Value.absent(),
  })  : checklistSeed = Value(checklistSeed),
        checklist = Value(checklist),
        date = Value(date);
  static Insertable<ChecklistLog> custom({
    Expression<int>? id,
    Expression<int>? checklistSeed,
    Expression<int>? checklist,
    Expression<String>? action,
    Expression<bool>? checked,
    Expression<bool>? skipped,
    Expression<DateTime>? date,
    Expression<String?>? serverID,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checklistSeed != null) 'checklist_seed': checklistSeed,
      if (checklist != null) 'checklist': checklist,
      if (action != null) 'action': action,
      if (checked != null) 'checked': checked,
      if (skipped != null) 'skipped': skipped,
      if (date != null) 'date': date,
      if (serverID != null) 'server_i_d': serverID,
      if (synced != null) 'synced': synced,
    });
  }

  ChecklistLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? checklistSeed,
      Value<int>? checklist,
      Value<String>? action,
      Value<bool>? checked,
      Value<bool>? skipped,
      Value<DateTime>? date,
      Value<String?>? serverID,
      Value<bool>? synced}) {
    return ChecklistLogsCompanion(
      id: id ?? this.id,
      checklistSeed: checklistSeed ?? this.checklistSeed,
      checklist: checklist ?? this.checklist,
      action: action ?? this.action,
      checked: checked ?? this.checked,
      skipped: skipped ?? this.skipped,
      date: date ?? this.date,
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
    if (checklistSeed.present) {
      map['checklist_seed'] = Variable<int>(checklistSeed.value);
    }
    if (checklist.present) {
      map['checklist'] = Variable<int>(checklist.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (serverID.present) {
      map['server_i_d'] = Variable<String?>(serverID.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistLogsCompanion(')
          ..write('id: $id, ')
          ..write('checklistSeed: $checklistSeed, ')
          ..write('checklist: $checklist, ')
          ..write('action: $action, ')
          ..write('checked: $checked, ')
          ..write('skipped: $skipped, ')
          ..write('date: $date, ')
          ..write('serverID: $serverID, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $ChecklistLogsTable extends ChecklistLogs
    with TableInfo<$ChecklistLogsTable, ChecklistLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistLogsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _checklistSeedMeta =
      const VerificationMeta('checklistSeed');
  @override
  late final GeneratedColumn<int?> checklistSeed = GeneratedColumn<int?>(
      'checklist_seed', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _checklistMeta = const VerificationMeta('checklist');
  @override
  late final GeneratedColumn<int?> checklist = GeneratedColumn<int?>(
      'checklist', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String?> action = GeneratedColumn<String?>(
      'action', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: Constant('{}'));
  final VerificationMeta _checkedMeta = const VerificationMeta('checked');
  @override
  late final GeneratedColumn<bool?> checked = GeneratedColumn<bool?>(
      'checked', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (checked IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _skippedMeta = const VerificationMeta('skipped');
  @override
  late final GeneratedColumn<bool?> skipped = GeneratedColumn<bool?>(
      'skipped', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (skipped IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _serverIDMeta = const VerificationMeta('serverID');
  @override
  late final GeneratedColumn<String?> serverID = GeneratedColumn<String?>(
      'server_i_d', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (synced IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        checklistSeed,
        checklist,
        action,
        checked,
        skipped,
        date,
        serverID,
        synced
      ];
  @override
  String get aliasedName => _alias ?? 'checklist_logs';
  @override
  String get actualTableName => 'checklist_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ChecklistLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('checklist_seed')) {
      context.handle(
          _checklistSeedMeta,
          checklistSeed.isAcceptableOrUnknown(
              data['checklist_seed']!, _checklistSeedMeta));
    } else if (isInserting) {
      context.missing(_checklistSeedMeta);
    }
    if (data.containsKey('checklist')) {
      context.handle(_checklistMeta,
          checklist.isAcceptableOrUnknown(data['checklist']!, _checklistMeta));
    } else if (isInserting) {
      context.missing(_checklistMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    }
    if (data.containsKey('checked')) {
      context.handle(_checkedMeta,
          checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta));
    }
    if (data.containsKey('skipped')) {
      context.handle(_skippedMeta,
          skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('server_i_d')) {
      context.handle(_serverIDMeta,
          serverID.isAcceptableOrUnknown(data['server_i_d']!, _serverIDMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ChecklistLog.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChecklistLogsTable createAlias(String alias) {
    return $ChecklistLogsTable(attachedDatabase, alias);
  }
}

abstract class _$RelDB extends GeneratedDatabase {
  _$RelDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $ModulesTable modules = $ModulesTable(this);
  late final $ParamsTable params = $ParamsTable(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $BoxesTable boxes = $BoxesTable(this);
  late final $ChartCachesTable chartCaches = $ChartCachesTable(this);
  late final $TimelapsesTable timelapses = $TimelapsesTable(this);
  late final $FeedsTable feeds = $FeedsTable(this);
  late final $FeedEntriesTable feedEntries = $FeedEntriesTable(this);
  late final $FeedEntryDraftsTable feedEntryDrafts =
      $FeedEntryDraftsTable(this);
  late final $FeedMediasTable feedMedias = $FeedMediasTable(this);
  late final $DeletesTable deletes = $DeletesTable(this);
  late final $ChecklistsTable checklists = $ChecklistsTable(this);
  late final $ChecklistSeedsTable checklistSeeds = $ChecklistSeedsTable(this);
  late final $ChecklistLogsTable checklistLogs = $ChecklistLogsTable(this);
  late final DevicesDAO devicesDAO = DevicesDAO(this as RelDB);
  late final PlantsDAO plantsDAO = PlantsDAO(this as RelDB);
  late final FeedsDAO feedsDAO = FeedsDAO(this as RelDB);
  late final DeletesDAO deletesDAO = DeletesDAO(this as RelDB);
  late final ChecklistsDAO checklistsDAO = ChecklistsDAO(this as RelDB);
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
        feedEntryDrafts,
        feedMedias,
        deletes,
        checklists,
        checklistSeeds,
        checklistLogs
      ];
}
