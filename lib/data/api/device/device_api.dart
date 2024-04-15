/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:drift/drift.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class DeviceAPI {
  static String mdnsDomain(String name) {
    return name.toLowerCase().replaceAllMapped(RegExp(r'[\W_]+'), (match) => "");
  }

  static Future<String?> resolveLocalName(String name) async {
    if (name.endsWith('.local')) {
      name.replaceAll('.local', '');
    }
    name = '${DeviceAPI.mdnsDomain(name)}.local';
    // Temporary workaround, mdns discovery fails on the current version of the lib
    String? ip;
    if (Platform.isAndroid) {
      ip = await DeviceAPI.resolveLocalNameMDNS(name);
    } else if (Platform.isIOS) {
      ip = await DeviceAPI.fetchStringParam(name, 'WIFI_IP', wait: 5);
    }
    return ip;
  }

  static Future<String?> resolveLocalNameMDNS(String name) async {
    final MDnsClient client =
        MDnsClient(rawDatagramSocketFactory: (dynamic host, int port, {bool? reuseAddress, bool? reusePort, int? ttl}) {
      return RawDatagramSocket.bind(host, port, reuseAddress: true, reusePort: false, ttl: ttl!);
    });
    await client.start();

    String? foundIP;
    await for (IPAddressResourceRecord record
        in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(name))) {
      foundIP = record.address.address;
      break;
    }
    client.stop();
    return foundIP;
  }

  static Future<String> fetchConfig(String controllerIP, {String? auth}) async {
    final client = new HttpClient();
    client.connectionTimeout = Duration(seconds: 10);
    final req = await client.getUrl(Uri.parse('http://$controllerIP/fs/config.json'));
    if (auth != null) {
      req.headers.set('Authorization', 'Basic $auth');
    }
    final HttpClientResponse resp = await req.close();
    if (resp.contentLength == 0) {
      Logger.throwError('Device request error: ${resp.statusCode}', fwdThrow: true);
    }
    if ((resp.statusCode / 100).floor() != 2) {
      Logger.throwError('Device request error: ${resp.statusCode}', fwdThrow: true);
    }
    final completer = Completer<String>();
    completer.future.whenComplete(() => client.close(force: true));
    String contents = '';
    resp.transform(utf8.decoder).listen((c) {
      contents += c;
    }, onDone: () {
      completer.complete(contents);
    }, onError: completer.completeError);
    return completer.future;
  }

  static Future<String> fetchStringParam(String controllerIP, String paramName,
      {int? timeout = 5, int nRetries = 4, int wait = 1, String? auth}) async {
    return fetchString('http://$controllerIP/s?k=${paramName.toUpperCase()}',
        timeout: timeout, nRetries: nRetries, wait: wait, auth: auth);
  }

  static Future<String> fetchString(String url,
      {int? timeout = 5, int nRetries = 4, int wait = 0, String? auth}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    try {
      for (int i = 0; i < nRetries; ++i) {
        if (i != 0 && wait > 0) {
          await Future.delayed(Duration(seconds: wait));
        }
        try {
          final req = await client.getUrl(Uri.parse(url));
          if (auth != null) {
            req.headers.set('Authorization', 'Basic $auth');
          }
          final HttpClientResponse resp = await req.close();
          if (resp.contentLength == 0) {
            return '';
          }
          if ((resp.statusCode / 100).floor() != 2) {
            Logger.throwError('Device request error: ${resp.statusCode}', fwdThrow: true);
          }
          final completer = Completer<String>();
          completer.future.whenComplete(() => client.close(force: true));
          resp.transform(utf8.decoder).listen((contents) {
            completer.complete(contents);
          }, onError: completer.completeError);
          return completer.future;
        } catch (e) {
          if (i == nRetries - 1) {
            throw e;
          }
        }
      }
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"url": url}, fwdThrow: true);
    }
    throw Error();
  }

  static Future<int> fetchIntParam(String controllerIP, String paramName,
      {int? timeout = 5, int nRetries = 4, int wait = 1, String? auth}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    try {
      for (int i = 0; i < nRetries; ++i) {
        if (i != 0 && wait > 0) {
          await Future.delayed(Duration(seconds: wait));
        }
        try {
          final req = await client.getUrl(Uri.parse('http://$controllerIP/i?k=${paramName.toUpperCase()}'));
          if (auth != null) {
            req.headers.set('Authorization', 'Basic $auth');
          }
          final resp = await req.close();
          if ((resp.statusCode / 100).floor() != 2) {
            Logger.throwError('Device request error: ${resp.statusCode}', fwdThrow: true);
          }
          final completer = Completer<int>();
          completer.future.whenComplete(() => client.close(force: true));
          resp.transform(utf8.decoder).listen((contents) {
            try {
              completer.complete(int.parse(contents));
            } catch (e, trace) {
              Logger.logError(e, trace, data: {"controllerIP": controllerIP, "paramName": paramName}, fwdThrow: true);
            }
          }, onError: completer.completeError);
          return completer.future;
        } catch (e) {
          if (i == nRetries - 1) {
            throw e;
          }
        }
      }
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"controllerIP": controllerIP, "paramName": paramName}, fwdThrow: true);
    }
    throw Error();
  }

  static Future<String> setStringParam(String controllerIP, String paramName, String value,
      {int? timeout = 5, int nRetries = 4, int wait = 1, String? auth}) async {
    try {
      await post('http://$controllerIP/s?k=${paramName.toUpperCase()}&v=${Uri.encodeQueryComponent(value)}',
          timeout: timeout, nRetries: nRetries, wait: wait, auth: auth);
    } catch (e, trace) {
      Logger.logError(e, trace,
          data: {"controllerIP": controllerIP, "paramName": paramName, "value": value}, fwdThrow: true);
    }
    return fetchStringParam(controllerIP, paramName, auth: auth);
  }

  static Future<int> setIntParam(String controllerIP, String paramName, int value,
      {int? timeout = 5, int nRetries = 4, int wait = 1, String? auth}) async {
    try {
      await post('http://$controllerIP/i?k=${paramName.toUpperCase()}&v=$value',
          timeout: timeout, nRetries: nRetries, wait: wait, auth: auth);
    } catch (e, trace) {
      Logger.logError(e, trace,
          data: {"controllerIP": controllerIP, "paramName": paramName, "value": value}, fwdThrow: true);
    }
    return fetchIntParam(controllerIP, paramName, auth: auth);
  }

  static Future post(String url, {int? timeout = 5, int nRetries = 4, int wait = 1, String? auth}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    try {
      for (int i = 0; i < nRetries; ++i) {
        if (i != 0 && wait > 0) {
          await Future.delayed(Duration(seconds: wait));
        }
        try {
          final req = await client.postUrl(Uri.parse(url));
          if (auth != null) {
            req.headers.set('Authorization', 'Basic $auth');
          }
          final resp = await req.close();
          if ((resp.statusCode / 100).floor() != 2) {
            Logger.throwError('Device request error: ${resp.statusCode}', fwdThrow: true);
          }
          break;
        } catch (e) {
          if (i == nRetries - 1) {
            throw e;
          }
        }
      }
    } finally {
      client.close(force: true);
    }
  }

  static Future uploadFile(String controllerIP, String fileName, ByteData data,
      {int? timeout = 5, int nRetries = 4, int wait = 1, String? auth}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    try {
      for (int i = 0; i < nRetries; ++i) {
        if (i != 0 && wait > 0) {
          await Future.delayed(Duration(seconds: wait));
        }
        try {
          final req = await client.postUrl(Uri.parse('http://$controllerIP/fs/$fileName'));
          if (auth != null) {
            req.headers.set('Authorization', 'Basic $auth');
          }
          req.contentLength = data.lengthInBytes;
          req.add(data.buffer.asInt8List());
          await req.flush();
          final resp = await req.close();
          if ((resp.statusCode / 100).floor() != 2) {
            Logger.throwError('Device request error: ${resp.statusCode}', fwdThrow: true);
          }
          break;
        } catch (e) {
          if (i == nRetries - 1) {
            throw e;
          }
        }
      }
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"controllerIP": controllerIP, "fileName": fileName}, fwdThrow: true);
    } finally {
      client.close(force: true);
    }
  }

  static Map<int, bool> fetchingAllParams = {};

  static Future fetchAllParams(String ip, int deviceID, Function(double) advancement,
      {bool delete = false, String? auth}) async {
    if (DeviceAPI.fetchingAllParams[deviceID] == true) {
      return;
    }
    DeviceAPI.fetchingAllParams[deviceID] = true;
    try {
      final db = RelDB.get().devicesDAO;
      final Map<String, int> modules = Map();

      final config = await DeviceAPI.fetchConfig(ip, auth: auth);

      Map<String, dynamic> keys = json.decode(config);

      if (delete) {
        await db.deleteParams(deviceID);
        await db.deleteModules(deviceID);
      }

      double total = keys['keys'].length.toDouble(), done = 0;
      for (Map<String, dynamic> k in keys['keys']) {
        var moduleName = k['module'];
        int moduleID;
        if (modules.containsKey(moduleName) == false) {
          bool isArray = k.containsKey('array');
          Module? exists;
          try {
            exists = await db.getModule(deviceID, moduleName);
          } catch (e) {}
          if (exists == null) {
            ModulesCompanion module = ModulesCompanion.insert(
                device: deviceID, name: moduleName, isArray: isArray, arrayLen: isArray ? k['array']['len'] : 0);
            moduleID = await db.addModule(module);
          } else {
            moduleID = exists.id;
          }
          modules[moduleName] = moduleID;
        }
        int type = k['type'] == 'integer' ? INTEGER_TYPE : STRING_TYPE;
        Param? exists;
        try {
          exists = await db.getParam(deviceID, k['caps_name']);
        } catch (e) {}
        if (type == INTEGER_TYPE) {
          try {
            final value = await DeviceAPI.fetchIntParam(ip, k['caps_name'], auth: auth);
            if (exists == null) {
              ParamsCompanion param = ParamsCompanion.insert(
                  device: deviceID,
                  module: modules[moduleName]!,
                  key: k['caps_name'],
                  type: type,
                  ivalue: Value(value));
              await db.addParam(param);
            } else {
              await db.updateParam(exists.copyWith(ivalue: Value(value)));
            }
          } catch (e, trace) {
            Logger.logError(e, trace, data: {"ip": ip, "deviceID": deviceID, "param": k['caps_name']}, fwdThrow: true);
          }
        } else {
          try {
            final value = await DeviceAPI.fetchStringParam(ip, k['caps_name'], auth: auth);
            if (exists == null) {
              ParamsCompanion param = ParamsCompanion.insert(
                  device: deviceID,
                  module: modules[moduleName]!,
                  key: k['caps_name'],
                  type: type,
                  svalue: Value(value));
              await db.addParam(param);
            } else {
              await db.updateParam(exists.copyWith(svalue: Value(value)));
            }
          } catch (e, trace) {
            Logger.logError(e, trace, data: {"ip": ip, "deviceID": deviceID, "param": k['caps_name']}, fwdThrow: true);
          }
        }
        ++done;
        advancement(done / total);
      }
      bool isController = (keys['isController'] ?? 'true') == 'true';
      bool isScreen = (keys['isScreen'] ?? 'false') == 'true';
      int nBoxes = 0;
      int nSensorPorts = 0;
      int nLeds = 0;
      int nMotors = 0;
      if (isController) {
        try {
          final boxModule = await RelDB.get().devicesDAO.getModule(deviceID, 'box');
          nBoxes = boxModule.arrayLen;
        } catch (e) {}
        try {
          final i2cModule = await RelDB.get().devicesDAO.getModule(deviceID, 'i2c');
          nSensorPorts = i2cModule.arrayLen;
        } catch (e) {}
        try {
          final ledModule = await RelDB.get().devicesDAO.getModule(deviceID, 'led');
          nLeds = ledModule.arrayLen;
        } catch (e) {}
        try {
          final motorModule = await RelDB.get().devicesDAO.getModule(deviceID, 'motor');
          nMotors = motorModule.arrayLen;
        } catch (e) {}
      }
      await db.updateDevice(DevicesCompanion(
        id: Value(deviceID),
        isController: Value(isController),
        isScreen: Value(isScreen),
        isSetup: Value(true),
        needsRefresh: Value(false),
        nBoxes: Value(nBoxes),
        nSensorPorts: Value(nSensorPorts),
        nLeds: Value(nLeds),
        nMotors: Value(nMotors),
        config: Value(config),
      ));
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"ip": ip, "deviceID": deviceID}, fwdThrow: true);
    } finally {
      DeviceAPI.fetchingAllParams[deviceID] = false;
    }
  }
}
