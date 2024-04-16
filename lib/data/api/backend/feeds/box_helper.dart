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
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:uuid/uuid.dart';

class BoxHelper {
  static Future removeBoxDevice(Box box, {bool removeDevice = false, bool removeScreenDevice = false}) async {
    BoxesCompanion boxC = BoxesCompanion(id: Value(box.id), synced: Value(false));
    if (removeDevice && box.device != null && box.deviceBox != null) {
      final Device device = await RelDB.get().devicesDAO.getDevice(box.device!);
      final boxEnabled = await RelDB.get().devicesDAO.getParam(box.device!, 'BOX_${box.deviceBox}_ENABLED');
      await DeviceHelper.updateIntParam(device, boxEnabled, 0);

      final ledModule = await RelDB.get().devicesDAO.getModule(device.id, 'led');
      for (int i = 0; i < ledModule.arrayLen; ++i) {
        final ledBox = await RelDB.get().devicesDAO.getParam(device.id, 'LED_${i}_BOX');
        if (ledBox.ivalue == box.deviceBox) {
          await DeviceHelper.updateIntParam(device, ledBox, -1);
        }
      }

      boxC = boxC.copyWith(device: Value(null), deviceBox: Value(null));
    }
    if (removeScreenDevice && box.screenDevice != null) {
      final Device device = await RelDB.get().devicesDAO.getDevice(box.screenDevice!);
      final Param encKey = await RelDB.get().devicesDAO.getParam(box.screenDevice!, 'BROKER_ENCKEY');
      await DeviceHelper.updateStringParam(device, encKey, "", forceLocal: true);

      final Param token = await RelDB.get().devicesDAO.getParam(device.id, 'BROKER_SCRTOKEN');
      await DeviceHelper.updateStringParam(device, token, "", forceLocal: true);
      boxC = boxC.copyWith(screenDevice: Value(null));
    }
    await RelDB.get().plantsDAO.updateBox(boxC);
  }

  static Future setBoxDevice(Box box, {Device? device, int? deviceBox, Device? screenDevice}) async {
    BoxesCompanion boxC = BoxesCompanion(id: Value(box.id), synced: Value(false));
    if (device != null &&
        deviceBox != null &&
        device.isController &&
        (device.id != box.device || deviceBox != box.deviceBox)) {
      BoxSettings boxSettings = BoxSettings.fromJSON(box.settings);
      Map<String, dynamic> schedule = boxSettings.schedules[boxSettings.schedule];

      Param onHourParam = await RelDB.get().devicesDAO.getParam(device!.id, 'BOX_${deviceBox}_ON_HOUR');
      Param onMinParam = await RelDB.get().devicesDAO.getParam(device!.id, 'BOX_${deviceBox}_ON_MIN');
      await DeviceHelper.updateHourMinParams(device, onHourParam, onMinParam, schedule['ON_HOUR'], schedule['ON_MIN']);

      Param offHourParam = await RelDB.get().devicesDAO.getParam(device!.id, 'BOX_${deviceBox}_OFF_HOUR');
      Param offMinParam = await RelDB.get().devicesDAO.getParam(device!.id, 'BOX_${deviceBox}_OFF_MIN');
      await DeviceHelper.updateHourMinParams(
          device, offHourParam, offMinParam, schedule['OFF_HOUR'], schedule['OFF_MIN']);

      final timerTypeParam = await RelDB.get().devicesDAO.getParam(device.id, 'BOX_${deviceBox}_TIMER_TYPE');
      // TODO declare Param enums when possible
      if (timerTypeParam.ivalue != 1) {
        await DeviceHelper.updateIntParam(device, timerTypeParam, 1);
      }

      final stateParam = await RelDB.get().devicesDAO.getParam(device.id, 'STATE');
      // TODO declare Param enums when possible
      if (stateParam.ivalue != 2) {
        await DeviceHelper.updateIntParam(device, stateParam, 2);
      }

      final boxEnabled = await RelDB.get().devicesDAO.getParam(device.id, 'BOX_${deviceBox}_ENABLED');
      await DeviceHelper.updateIntParam(device, boxEnabled, 1);

      boxC = boxC.copyWith(device: Value(device.id), deviceBox: Value(deviceBox));
    }
    if (screenDevice != null && screenDevice.isScreen && screenDevice.id != box.screenDevice) {
      boxC = boxC.copyWith(screenDevice: Value(screenDevice.id));

      String key = Uuid().v4();
      final Param encKey = await RelDB.get().devicesDAO.getParam(screenDevice.id, 'BROKER_ENCKEY');
      await DeviceHelper.updateStringParam(screenDevice, encKey, key, forceLocal: true);

      String scrToken = Uuid().v4();
      final Param token = await RelDB.get().devicesDAO.getParam(screenDevice.id, 'BROKER_SCRTOKEN');
      await DeviceHelper.updateStringParam(screenDevice, token, scrToken, forceLocal: true);
      boxC = boxC.copyWith(screenDeviceToken: Value(scrToken), encKey: Value(key));

      final stateParam = await RelDB.get().devicesDAO.getParam(screenDevice.id, 'STATE');
      // TODO declare Param enums when possible
      if (stateParam.ivalue != 2) {
        await DeviceHelper.updateIntParam(screenDevice, stateParam, 2);
      }
    }
    await RelDB.get().plantsDAO.updateBox(boxC);
  }
}
