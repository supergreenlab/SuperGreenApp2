import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class SGLLocalizations {
  SGLLocalizations(this.localeName);

  static Future<SGLLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null || locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return SGLLocalizations(localeName);
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

  String get vegScheduleHelper {
    return Intl.message(
      'Vegetative stage is the phase between germination and blooming, the plant grows and develops it’s branches. It requires at least 13h lights per days, usual setting is 18h per day.',
      name: 'vegScheduleHelper',
      desc: 'Veg schedule helper',
      locale: localeName,
    );
  }

  String get bloomScheduleHelper {
    return Intl.message(
      'Bloom stage is the phase between germination and blooming, the plant grows and develops it’s branches. It requires at least 13h lights per days, usual setting is 18h per day.',
      name: 'bloomScheduleHelper',
      desc: 'Bloom schedule helper',
      locale: localeName,
    );
  }

  String get autoScheduleHelper {
    return Intl.message(
      'Auto flower plants are a special type of strain that won’t require light schedule change in order to start flowering. Their vegetative stage duration can’t be controlled, and varies from one plant to another.',
      name: 'autoScheduleHelper',
      desc: 'Auto schedule helper',
      locale: localeName,
    );
  }
}

class SGLLocalizationsDelegate
    extends LocalizationsDelegate<SGLLocalizations> {
  const SGLLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<SGLLocalizations> load(Locale locale) =>
      SGLLocalizations.load(locale);

  @override
  bool shouldReload(SGLLocalizationsDelegate old) => false;
}
