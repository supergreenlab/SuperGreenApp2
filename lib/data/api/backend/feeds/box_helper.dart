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

import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:uuid/uuid.dart';

class BoxHelper {
  static Future setBoxDevice(Box box, {Device? device, int? deviceBox, Device? screenDevice}) async {
    BoxesCompanion boxC = BoxesCompanion(id: Value(box.id), synced: Value(false));
    if (device != null && deviceBox != null && device.isController) {
      boxC = boxC.copyWith(device: Value(device.id), deviceBox: Value(deviceBox));
    }
    if (screenDevice != null && screenDevice.isScreen) {
      boxC = boxC.copyWith(screenDevice: Value(screenDevice.id));

      String key = Uuid().v4();
      final Param encKey = await RelDB.get().devicesDAO.getParam(screenDevice.id, 'BROKER_ENCKEY');
      await DeviceHelper.updateStringParam(screenDevice, encKey, key, forceLocal: true);

      String scrToken = Uuid().v4();
      final Param token = await RelDB.get().devicesDAO.getParam(screenDevice.id, 'BROKER_SCRTOKEN');
      await DeviceHelper.updateStringParam(screenDevice, token, scrToken, forceLocal: true);
      boxC = boxC.copyWith(screenDeviceToken: Value(scrToken), encKey: Value(key));
    }
    await RelDB.get().plantsDAO.updateBox(boxC);
  }
}