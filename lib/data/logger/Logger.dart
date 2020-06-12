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

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Logger {
  static File logFile;

  static Future init() async {
    String logFilePath = await Logger.logFilePath();
    logFile = File(logFilePath);
    if (await logFile.exists()) {
      await logFile.delete();
    }
  }

  static void log(String message) {
    try {
      logFile
          .writeAsStringSync('${DateTime.now().toIso8601String()} - $message\n', mode: FileMode.append, flush: true);
      print(message);
    } catch (e) {
      print(e);
    }
  }

  static Future<String> logFilePath() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/log.txt';
  }
}
