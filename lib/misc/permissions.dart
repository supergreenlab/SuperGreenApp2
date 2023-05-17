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

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> checkCapturePermissions() async {
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> res = await [
        Permission.photos,
      ].request();
      return res[Permission.photos] == PermissionStatus.granted || res[Permission.photos] == PermissionStatus.limited;
    } else if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int version = int.tryParse(androidInfo.version.release) ?? 0;
      if (version >= 13) {
        Map<Permission, PermissionStatus> res = await [
          Permission.photos,
          Permission.videos,
        ].request();
        return (res[Permission.photos] == PermissionStatus.granted ||
                res[Permission.photos] == PermissionStatus.limited) &&
            (res[Permission.videos] == PermissionStatus.granted || res[Permission.videos] == PermissionStatus.limited);
      } else {
        Map<Permission, PermissionStatus> res = await [
          Permission.storage,
        ].request();
        return (res[Permission.storage] == PermissionStatus.granted ||
            res[Permission.storage] == PermissionStatus.limited);
      }
    }
    return false;
  }
}
