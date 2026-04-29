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

import 'package:envied/envied.dart';

part 'config.g.dart';

@Envied()
abstract class Config {
  @EnviedField(varName: 'RECAPTCHA_KEY')
  static const String recaptchaKey = _Config.recaptchaKey;

  @EnviedField(varName: 'SKIP_CAPTCHA_TOKEN')
  static const String skipCaptchaToken = _Config.skipCaptchaToken;

  @EnviedField(varName: 'API_SERVER_HOST')
  static const String apiServerHost = _Config.apiServerHost;

  @EnviedField(varName: 'WEBSOCKET_SERVER_HOST')
  static const String websocketServerHost = _Config.websocketServerHost;

  @EnviedField(varName: 'STORAGE_SERVER_HOST')
  static const String storageServerHost = _Config.storageServerHost;

  @EnviedField(varName: 'STORAGE_SERVER_HOST_HEADER')
  static const String storageServerHostHeader = _Config.storageServerHostHeader;

  @EnviedField(varName: 'IS_PRODUCTION', defaultValue: 'false')
  static const String _isProductionStr = _Config._isProductionStr;
  
  static bool get isProduction => _isProductionStr.toLowerCase() == 'true';
}
