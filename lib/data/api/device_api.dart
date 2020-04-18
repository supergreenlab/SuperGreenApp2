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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class DeviceAPI {
  static Future<String> resolveLocalName(String name) async {
    if (name.endsWith('.local')) {
      name.replaceAll('.local', '');
    }
    name = '${name.toLowerCase()}.local';
    // Temporary workaround, mdns discovery fails on the current version of the lib
    String ip;
    if (Platform.isAndroid) {
      ip = await DeviceAPI.resolveLocalNameMDNS(name);
    } else if (Platform.isIOS) {
      ip = await DeviceAPI.fetchStringParam(name, 'WIFI_IP', wait: 5);
    }
    return ip;
  }

  static Future<String> resolveLocalNameMDNS(String name) async {
    final MDnsClient client = MDnsClient();
    await client.start();

    String foundIP;
    await for (IPAddressResourceRecord record
        in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(name))) {
      foundIP = record.address.address;
      break;
    }
    client.stop();
    return foundIP;
  }

  static Future<String> fetchConfig(String controllerIP) async {
    Response r = await get('http://$controllerIP/fs/config.json');
    return r.body;
  }

  static Future<String> fetchStringParam(String controllerIP, String paramName,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    for (int i = 0; i < nRetries; ++i) {
      if (i != 0 && wait > 0) {
        await Future.delayed(Duration(seconds: wait));
      }
      try {
        final req = await client.getUrl(
            Uri.parse('http://$controllerIP/s?k=${paramName.toUpperCase()}'));
        final HttpClientResponse resp = await req.close();
        if (resp.contentLength == 0) {
          return '';
        }
        final completer = Completer<String>();
        resp.transform(utf8.decoder).listen((contents) {
          completer.complete(contents);
        }, onError: completer.completeError);
        return completer.future;
      } catch (e) {
        print(e);
        if (i == nRetries - 1) {
          throw e;
        }
      }
    }
    return null;
  }

  static Future<int> fetchIntParam(String controllerIP, String paramName,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    for (int i = 0; i < nRetries; ++i) {
      if (i != 0 && wait > 0) {
        await Future.delayed(Duration(seconds: wait));
      }
      try {
        final req = await client.getUrl(
            Uri.parse('http://$controllerIP/i?k=${paramName.toUpperCase()}'));
        final resp = await req.close();
        final completer = Completer<int>();
        resp.transform(utf8.decoder).listen((contents) {
          completer.complete(int.parse(contents));
        }, onError: completer.completeError);
        return completer.future;
      } catch (e) {
        print(e);
        if (i == nRetries - 1) {
          throw e;
        }
      }
    }
    return null;
  }

  static Future<String> setStringParam(
      String controllerIP, String paramName, String value,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    for (int i = 0; i < nRetries; ++i) {
      if (i != 0 && wait > 0) {
        await Future.delayed(Duration(seconds: wait));
      }
      try {
        final req = await client.postUrl(Uri.parse(
            'http://$controllerIP/s?k=${paramName.toUpperCase()}&v=$value'));
        await req.close();
        break;
      } catch (e) {
        print(e);
        if (i == nRetries - 1) {
          throw e;
        }
      }
    }
    return await fetchStringParam(controllerIP, paramName);
  }

  static Future<int> setIntParam(
      String controllerIP, String paramName, int value,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    final client = new HttpClient();
    if (timeout != null) {
      client.connectionTimeout = Duration(seconds: timeout);
    }
    for (int i = 0; i < nRetries; ++i) {
      if (i != 0 && wait > 0) {
        await Future.delayed(Duration(seconds: wait));
      }
      try {
        final req = await client.postUrl(Uri.parse(
            'http://$controllerIP/i?k=${paramName.toUpperCase()}&v=$value'));
        await req.close();
        break;
      } catch (e) {
        print(e);
        if (i == nRetries - 1) {
          throw e;
        }
      }
    }
    return fetchIntParam(controllerIP, paramName);
  }

  // TODO add check if param exists for insert/update
  static Future fetchAllParams(
      String ip, int deviceID, Map<String, dynamic> keys, Function(double) advancement) async {
    final db = RelDB.get().devicesDAO;
    final Map<String, int> modules = Map();

    await db.deleteParams(deviceID);
    await db.deleteModules(deviceID);

    double total = keys['keys'].length.toDouble(), done = 0;
    for (Map<String, dynamic> k in keys['keys']) {
      var moduleName = k['module'];
      if (modules.containsKey(moduleName) == false) {
        bool isArray = k.containsKey('array');
        ModulesCompanion module = ModulesCompanion.insert(
            device: deviceID,
            name: moduleName,
            isArray: isArray,
            arrayLen: isArray ? k['array']['len'] : 0);
        final moduleID = await db.addModule(module);
        modules[moduleName] = moduleID;
      }
      int type = k['type'] == 'integer' ? INTEGER_TYPE : STRING_TYPE;
      ParamsCompanion param;
      if (type == INTEGER_TYPE) {
        try {
          final value = await DeviceAPI.fetchIntParam(ip, k['caps_name']);
          param = ParamsCompanion.insert(
              device: deviceID,
              module: modules[moduleName],
              key: k['caps_name'],
              type: type,
              ivalue: Value(value));
          await db.addParam(param);
        } catch (e) {
          print(e);
          throw e;
        }
      } else {
        try {
          final value =
              await DeviceAPI.fetchStringParam(ip, k['caps_name']);
          param = ParamsCompanion.insert(
              device: deviceID,
              module: modules[moduleName],
              key: k['caps_name'],
              type: type,
              svalue: Value(value));
          await db.addParam(param);
        } catch (e) {
          print(e);
          throw e;
        }
      }
      ++done;
      advancement(done / total);
    }
  }
}
