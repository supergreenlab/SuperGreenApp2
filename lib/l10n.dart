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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class SGLLocalizations {
  SGLLocalizations(this.localeName);

  static SGLLocalizations current;

  static Future<SGLLocalizations> load(Locale locale) {
    final String name = locale.countryCode == null || locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      current = SGLLocalizations(localeName);
      return current;
    });
  }

  static SGLLocalizations of(BuildContext context) {
    return Localizations.of<SGLLocalizations>(context, SGLLocalizations);
  }

  final String localeName;

  String get title {
    return Intl.message(
      'SuperGreenLab',
      name: 'title',
      desc: 'App title',
      locale: localeName,
    );
  }

















}

class SGLLocalizationsDelegate extends LocalizationsDelegate<SGLLocalizations> {
  const SGLLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  Future<SGLLocalizations> load(Locale locale) => SGLLocalizations.load(locale);

  @override
  bool shouldReload(SGLLocalizationsDelegate old) => false;
}
