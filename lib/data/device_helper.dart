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
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class DeviceHelper {
  static Future updateDeviceName(Device device, String name) async {
    final mdnsDomain = name.toLowerCase().replaceAllMapped(RegExp(r'[\W_]+'), (match) => "");
    final ddb = RelDB.get().devicesDAO;
    await DeviceAPI.setStringParam(device.ip, 'DEVICE_NAME', name);
    await ddb.updateDevice(device
        .createCompanion(true)
        .copyWith(name: Value(name), mdns: Value(mdnsDomain)));
    Param mdns = await ddb.getParam(device.id, 'MDNS_DOMAIN');
    await DeviceHelper.updateStringParam(device, mdns, mdnsDomain);
  }

  static Future<String> updateStringParam(
      Device device, Param param, String value,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    value = await DeviceAPI.setStringParam(device.ip, param.key, value,
        timeout: timeout, nRetries: nRetries, wait: wait);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(svalue: value));
    return value;
  }

  static Future<int> updateIntParam(Device device, Param param, int value,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    value = await DeviceAPI.setIntParam(device.ip, param.key, value,
        timeout: timeout, nRetries: nRetries, wait: wait);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(ivalue: value));
    return value;
  }

  static Future refreshStringParam(Device device, Param param,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    String value = await DeviceAPI.fetchStringParam(device.ip, param.key,
        timeout: timeout, nRetries: nRetries, wait: wait);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(svalue: value));
  }

  static Future refreshIntParam(Device device, Param param,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    int value = await DeviceAPI.fetchIntParam(device.ip, param.key,
        timeout: timeout, nRetries: nRetries, wait: wait);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(ivalue: value));
  }
}
