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
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:tuple/tuple.dart';

class DeviceHelper {
  static Future updateDeviceName(Device device, String name) async {
    final mdnsDomain = DeviceAPI.mdnsDomain(name);
    final ddb = RelDB.get().devicesDAO;
    await DeviceAPI.setStringParam(device.ip, 'DEVICE_NAME', name);
    Param mdns = await ddb.getParam(device.id, 'MDNS_DOMAIN');
    await DeviceHelper.updateStringParam(device, mdns, mdnsDomain);
    await ddb.updateDevice(DevicesCompanion(
        id: Value(device.id),
        name: Value(name),
        mdns: Value(mdnsDomain),
        synced: Value(false)));
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

  static Future<Tuple2<int, int>> updateHourMinParams(
      Device device, Param hourParam, Param minParam, int hour, int min,
      {int timeout = 5, int nRetries = 4, int wait = 0}) async {
    print(
        "${DateTime.now().timeZoneOffset.inHours} ${DateTime.now().timeZoneOffset.inMinutes % 60}");
    hour = hour - DateTime.now().timeZoneOffset.inHours;
    min = min - (DateTime.now().timeZoneOffset.inMinutes % 60);
    if (min < 0) {
      min += 60;
      hour -= 1;
    } else if (min > 59) {
      min %= 60;
      hour += 1;
    }
    if (hour < 0) {
      hour += 24;
    }
    hour = hour % 24;
    hour = await DeviceHelper.updateIntParam(device, hourParam, hour);
    min = await DeviceHelper.updateIntParam(device, minParam, min);
    return Tuple2<int, int>(hour, min);
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

  static Future deleteDevice(Device device, {addDeleted: true}) async {
    device = await RelDB.get().devicesDAO.getDevice(device.id);
    await RelDB.get().devicesDAO.deleteDevice(device);
    if (addDeleted && device.serverID != null) {
      await RelDB.get().deletesDAO.addDelete(DeletesCompanion(
          serverID: Value(device.serverID), type: Value('devices')));
    }

    await RelDB.get().devicesDAO.deleteParams(device.id);
    await RelDB.get().devicesDAO.deleteModules(device.id);
  }
}
