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

  String get towelieWelcomeApp {
    return Intl.message(
      '''Hey man, welcome here, my name’s Towelie, I’m here to make sure you don’t forget anything about your plant.\n\nBut first, let’s create a box feed. Press the “ADD A FIRST BOX” button below.''',
      name: 'towelieWelcomeApp',
      desc: 'Towelie Welcome App',
      locale: localeName,
    );
  }

  String get towelieWelcomeBox {
    return Intl.message(
      '''Welcome to your box feed!\n\nThis is where you will modify your box’s parameters, everytime you change your light dimming, change from veg to bloom, or change your ventilation, it will log a card here, so you’ll have a clear history of all changes you did, and how it affected the box’s environment.\n\nThis is also where you will log the actions you want to remember: last time you watered for example.\n\nThe app will also add log entries for temperature or humidity heads up and reminders you can set or\nreceive from the app.\n\nAnd all this feed can be reviewed, shared or replayed later, and that’s awesome.''',
      name: 'towelieWelcomeBox',
      desc: 'Towelie Welcome Box',
      locale: localeName,
    );
  }
}

class SGLLocalizationsDelegate extends LocalizationsDelegate<SGLLocalizations> {
  const SGLLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  Future<SGLLocalizations> load(Locale locale) => SGLLocalizations.load(locale);

  @override
  bool shouldReload(SGLLocalizationsDelegate old) => false;
}
