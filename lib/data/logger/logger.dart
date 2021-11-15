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
  static late File logFile;

  static Future init() async {
    String logFilePath = await Logger.logFilePath();
    logFile = File(logFilePath);
    if (await logFile.exists()) {
      await logFile.delete();
    }
  }

  static void log(Object message) {
    print(message);
    try {
      logFile.writeAsStringSync('${DateTime.now().toIso8601String()} - $message\n', mode: FileMode.append, flush: true);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  static void logError(dynamic error, StackTrace stackTrace, {Map<String, dynamic>? data, bool fwdThrow = false}) {
    data = data ?? {};
    String dataStr = data.keys.map<String>((String key) {
      return "$key=${data![key]}";
    }).join("\n");
    print(error);
    print(stackTrace);
    print(dataStr);
    try {
      logFile.writeAsStringSync(
          '===============\nError:\n${DateTime.now().toIso8601String()} - $error\nData:\n$dataStr\nTrace:\n$stackTrace\n===============\n',
          mode: FileMode.append,
          flush: true);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
    if (fwdThrow == true) {
      throw error;
    }
  }

  static void throwError(String error, {Map<String, dynamic>? data, bool fwdThrow = false}) {
    try {
      throw error;
    } catch (e, trace) {
      logError(e, trace, data: data, fwdThrow: fwdThrow);
    }
  }

  static Future<String> logFilePath() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/log.txt';
  }
}
