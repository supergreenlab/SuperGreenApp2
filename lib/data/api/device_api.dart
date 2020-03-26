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
import 'package:multicast_dns/multicast_dns.dart';

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
}
