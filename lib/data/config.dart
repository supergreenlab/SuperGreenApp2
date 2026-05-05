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

import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Config {
  static String get recaptchaKey => dotenv.maybeGet('RECAPTCHA_KEY') ?? '';

  static String get skipCaptchaToken =>
      dotenv.maybeGet('SKIP_CAPTCHA_TOKEN') ?? '';

  static String get apiServerHost => dotenv.get('API_SERVER_HOST');

  static String get websocketServerHost => dotenv.get('WEBSOCKET_SERVER_HOST');

  static String get storageServerHost => dotenv.get('STORAGE_SERVER_HOST');

  static String get storageServerHostHeader =>
      dotenv.get('STORAGE_SERVER_HOST_HEADER');

  static bool get isProduction =>
      dotenv.getBool('IS_PRODUCTION', fallback: false);
}
