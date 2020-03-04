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
    await DeviceAPI.setStringParam(device.ip, 'DEVICE_NAME', name);
    await RelDB.get().devicesDAO.updateDevice(device.createCompanion(true).copyWith(name: Value(name)));
  }
  
  static Future updateStringParam(
      Device device, Param param, String value) async {
    await DeviceAPI.setStringParam(device.ip, param.key, value);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(svalue: value));
  }

  static Future updateIntParam(Device device, Param param, int value) async {
    await DeviceAPI.setIntParam(device.ip, param.key, value);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(ivalue: value));
  }

  static Future refreshStringParam(Device device, Param param) async {
    String value = await DeviceAPI.fetchStringParam(device.ip, param.key);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(svalue: value));
  }

  static Future refreshIntParam(Device device, Param param) async {
    int value = await DeviceAPI.fetchIntParam(device.ip, param.key);
    await RelDB.get().devicesDAO.updateParam(param.copyWith(ivalue: value));
  }
}
