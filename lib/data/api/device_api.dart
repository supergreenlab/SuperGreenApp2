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

import 'package:http/http.dart';
import 'package:multicast_dns/multicast_dns.dart';

class DeviceAPI {
  static Future<String> resolveLocalName(String name) async {
    name = '${name.toLowerCase()}.local';
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

  static Future<String> fetchStringParam(
      String controllerIP, String paramName) async {
    Response r = await get('http://$controllerIP/s?k=${paramName.toUpperCase()}');
    return r.body;
  }

  static Future<int> fetchIntParam(
      String controllerIP, String paramName) async {
    Response r = await get('http://$controllerIP/i?k=${paramName.toUpperCase()}');
    return int.parse(r.body);
  }

  static Future<String> setStringParam(
      String controllerIP, String paramName, String value) async {
    await post('http://$controllerIP/s?k=${paramName.toUpperCase()}&v=$value');
    return fetchStringParam(controllerIP, paramName);
  }

  static Future<int> setIntParam(
      String controllerIP, String paramName, int value) async {
    await post('http://$controllerIP/i?k=${paramName.toUpperCase()}&v=$value');
    return fetchIntParam(controllerIP, paramName);
  }

}
