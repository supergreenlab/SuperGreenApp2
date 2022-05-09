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

import 'package:super_green_app/data/logger/logger.dart';

class MapUtils {
  static dynamic valuePath(Map<String, dynamic>? map, String path) {
    List<String> pathElem = path.split('.');
    dynamic value;
    for (int i = 0; i < pathElem.length; ++i) {
      try {
        map = map?[pathElem[i]];
        if (map == null) return null;
      } catch (e, trace) {
        Logger.logError(e, trace);
      }
      value = map?[pathElem[i]];
    }
    return value;
  }
}
