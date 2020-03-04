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
      '''Hey man, welcome here, my name’s **Towelie**, I’m here to make sure you don’t forget anything about your plant.
      
Welcome to **SuperGreenLab\'s** grow diary app!
While it can be used without, this app has been optimized to be used with a **Ninja bundle**.
Do you own one?''',
      name: 'towelieWelcomeApp',
      desc: 'Towelie Welcome App',
      locale: localeName,
    );
  }

  String get towelieWelcomeAppHasBundle {
    return Intl.message(
      '''Have you received it yet?''',
      name: 'towelieWelcomeAppHasBundle',
      desc: 'Towelie Welcome App - Has bundle',
      locale: localeName,
    );
  }

  String get towelieWelcomeAppNoBundle {
    return Intl.message(
      '''With 6 full spectrum LED grow lights providing dense light and little heat. This complete grow box bundle lets you build a grow box out of almost anything.

With these lights we successfully grew and harvested from space buckets, TV stands, office storages and custom built grow boxes. Some of our users even grew in toolboxes or suitcase ! What will you build ?

Coming with a sensor, ventilation, a controller and a companion App. The ninja grow bundle is fully controllable from your smartphone and can be split into 3 different chambers with different light dimming, schedules and ventilation setups.''',
      name: 'towelieWelcomeAppNoBundle',
      desc: 'Towelie Welcome App - No bundle',
      locale: localeName,
    );
  }

  String get towelieCreateBox {
    return Intl.message(
      '''Alright we're ready to create your **first box!**

The app works like this:
- you create a box
- attach it (or not) to a **SuperGreenController**
- configure the led channels used to **light it up**

Once this is done, you will have access to it's **feed**, it's like a timeline of the **box's life**.
Whenever you water, change light parameters, or train the plant, or any other action,
it will log it in the box's feed, so you can **share it**, or **replay it** for your next grow!

Press the **Create box** button below.
''',
      name: 'towelieCreateBox',
      desc: 'Towelie Create Box',
      locale: localeName,
    );
  }

  String get towelieBoxCreated {
    return Intl.message(
      '''Awesome, you created your first box!

You can access your newly box feed either by pressing the home button below, or the **View box** button below.
''',
      name: 'towelieBoxCreated',
      desc: 'Towelie Box Created',
      locale: localeName,
    );
  }

  String get towelieWelcomeBox {
    return Intl.message(
      '''**Welcome to your box feed!**
This is where you will modify your box’s parameters, everytime you change your light dimming, change from veg to bloom, or change your ventilation, **it will log a card here**, so you’ll have a clear history of all changes you did, and how it affected the box’s environment.

This is also where you will log the actions **you want to remember**: last time you watered for example.

The app will also add log entries for temperature or humidity **heads up and reminders** you can set or
receive from the app.

And all this feed can be reviewed, shared or replayed later, **and that’s awesome**.''',
      name: 'towelieWelcomeBox',
      desc: 'Towelie Welcome Box',
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
