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

  String get instructionsVegScheduleHelper {
    return Intl.message(
      '**Vegetative stage** is the phase between germination and blooming, the plant **grows and develops** it’s branches. It requires **at least 13h lights per days**, usual setting is **18h** per day.',
      name: 'instructionsVegScheduleHelper',
      desc: 'Veg schedule helper',
      locale: localeName,
    );
  }

  String get instructionsBloomScheduleHelper {
    return Intl.message(
      '**Bloom stage** is the phase between germination and blooming, the plant grows and develops it’s branches. It requires **at most 12h lights per days**, usual setting is **12h** per day.',
      name: 'instructionsBloomScheduleHelper',
      desc: 'Bloom schedule helper',
      locale: localeName,
    );
  }

  String get instructionsAutoScheduleHelper {
    return Intl.message(
      'Auto flower plants are a special type of strain that **won’t require light schedule change** in order to start flowering. Their vegetative stage duration **can’t be controlled**, and varies from one plant to another.',
      name: 'instructionsAutoScheduleHelper',
      desc: 'Auto schedule helper',
      locale: localeName,
    );
  }

  String get instructionsExistingDeviceTitle {
    return Intl.message(
      '''Enter controller name or IP''',
      name: 'instructionsExistingDeviceTitle',
      desc: 'Instructions existing device title',
      locale: localeName,
    );
  }

  String get instructionsExistingDevice {
    return Intl.message(
      '''Please make sure your **mobile phone** is **connected to your home wifi**.
Then we\'ll search for it **by name** or **by IP**, please **fill** the following text field.''',
      name: 'instructionsExistingDevice',
      desc: 'Instructions existing device',
      locale: localeName,
    );
  }

  String get instructionsNewDeviceWifiFailed {
    return Intl.message(
      '''**Couldn\'t connect** to the 🤖🍁 wifi! Please go to your **mobile phone settings** to connect manually with the **following credentials**:''',
      name: 'instructionsNewDeviceWifiFailed',
      desc: 'Instructions new device wifi failed',
      locale: localeName,
    );
  }

  String get instructionsNewDeviceWifiFailed2 {
    return Intl.message(
      '''Then press the **DONE** button below''',
      name: 'instructionsNewDeviceWifiFailed2',
      desc: 'Instructions new device wifi failed2',
      locale: localeName,
    );
  }

  String get towelieWelcomeApp {
    return Intl.message(
      '''Hey man, welcome here, my name’s **Towelie**, I’m here to make sure you don’t forget anything about your plant.
      
Welcome to **SuperGreenLab\'s** grow diary app!
While it can be used without, this app has been optimized to be used with a **Ninja bundle**.
**Do you own one?**''',
      name: 'towelieWelcomeApp',
      desc: 'Towelie Welcome App',
      locale: localeName,
    );
  }

  String get towelieWelcomeAppHasBundle {
    return Intl.message(
      '''Have you **received it** yet?''',
      name: 'towelieWelcomeAppHasBundle',
      desc: 'Towelie Welcome App - Has bundle',
      locale: localeName,
    );
  }

  String get towelieWelcomeAppNoBundle {
    return Intl.message(
      '''With **6 full spectrum LED grow lights** providing dense light and **little heat**. This complete grow box bundle lets you **build a grow box** out of **almost anything**.

With these lights we successfully grew and harvested from **space buckets, TV stands, office storages** and custom built grow boxes. Some of our users even grew in **toolboxes or suitcase** ! What will you build ?

Coming with a **sensor, ventilation, a controller and a companion App**. The **ninja** grow bundle is fully controllable from your smartphone and can be split into **3 different chambers** with different **light dimming, schedules and ventilation setups**.''',
      name: 'towelieWelcomeAppNoBundle',
      desc: 'Towelie Welcome App - No bundle',
      locale: localeName,
    );
  }

  String get towelieCreateBox {
    return Intl.message(
      '''Alright we're ready to create your **first box!**

The app works like this:
- you **create a box**
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
      '''Awesome, **you created your first box**!

You can access your newly box feed either by **pressing the home button below**, or the **View box** button below.
''',
      name: 'towelieBoxCreated',
      desc: 'Towelie Box Created',
      locale: localeName,
    );
  }

  String get towelieWelcomeBox {
    return Intl.message(
      '''**Welcome to your box feed!**
This is where you will modify your box’s parameters, everytime you change your **light dimming**, change from **veg to bloom**, or change your **ventilation**, **it will log a card here**, so you’ll have a clear history of all changes you did, and how it affected the box’s environment.

This is also where you will log the actions **you want to remember**: last time you watered for example.

The app will also add log entries for temperature or humidity **heads up and reminders** you can set or
receive from the app.

And all this feed can be reviewed, shared or replayed later, **and that’s awesome**.''',
      name: 'towelieWelcomeBox',
      desc: 'Towelie Welcome Box',
      locale: localeName,
    );
  }

  String get towelieHelperCreateBox {
    return Intl.message(
      '''Hey man, **welcome to the box creation process**, I\'ll be there to guide you through it.
First step is to **give your new box a name**.''',
      name: 'towelieHelperCreateBox',
      desc: 'Towelie Helper Create Box',
      locale: localeName,
    );
  }

  String get towelieHelperSelectDevice {
    return Intl.message(
      '''Alright, now that your box has a name we can **start its configuration**:)
If you own a **SuperGreenLab bundle**, you need to tell the app **which controller will control the box lights, ventilation and sensors**.
Because it\'s all brand new, let\'s first **setup a new controller**.
If you don\'t own a bundle, you can skip this by pressing "NO SGL DEVICE".''',
      name: 'towelieHelperSelectDevice',
      desc: 'Towelie Helper Select box device',
      locale: localeName,
    );
  }

  String get towelieHelperAddDevice {
    return Intl.message(
      '''**Good**.
Now this is when you should **plug the controller to it\'s power supply** if not already.
Then you will choose one of the options above to **connect to the controller**.''',
      name: 'towelieHelperAddDevice',
      desc: 'Towelie Helper Add device',
      locale: localeName,
    );
  }

  String get towelieHelperAddExistingDevice {
    return Intl.message(
      '''Ok, so your controller is **already running** and **connected to your home wifi**, let\'s search for it over the network!
Enter the **name you gave it last time** (default is **supergreencontroller**), if you can\'t remember it, you can also type its **IP address**.
The **IP address** can be easily found on your **router\'s home page**.
To **access your router's homepage**: take the **IP** address of your **mobile phone** or **laptop**, replace the last digit by **1** and **type that** in a browser.''',
      name: 'towelieHelperAddExistingDevice',
      desc: 'Towelie Helper Add existing device',
      locale: localeName,
    );
  }

  String get towelieHelperDeviceWifi {
    return Intl.message(
      '''**While not mandatory**, connecting your controller to your home wifi has a few benefits:
- receive software **upgrade** and bug fixes
- remote **monitoring**
- remote **control** (coming soon)''',
      name: 'towelieHelperDeviceWifi',
      desc: 'Towelie Helper Device wifi',
      locale: localeName,
    );
  }

  String get towelieHelperSelectBoxDevice {
    return Intl.message(
      '''Your controller can **manage up to 3 boxes**, select an **already configured** box above, or create a **new one**.''',
      name: 'towelieHelperSelectBoxDevice',
      desc: 'Towelie Helper box Device box',
      locale: localeName,
    );
  }

  String get towelieHelperSelectNewBoxDevice {
    return Intl.message(
      '''Ok, this is where we'll choose which of the **controller's LED channel** will be used to light up the plant.
To **better understand** you should have your LED panels **connected to the controller**.''',
      name: 'towelieHelperSelectNewBoxDevice',
      desc: 'Towelie Helper box new Device box',
      locale: localeName,
    );
  }

  String get towelieHelperTestDevice {
    return Intl.message(
      '''This test is to make sure everything is working, **connect** your **LED** panels **to the controller** if not already.''',
      name: 'towelieHelperTestDevice',
      desc: 'Towelie Helper test device',
      locale: localeName,
    );
  }

  String get towelieHelperFormMeasure {
    return Intl.message(
      '''This is the **measuring tool**, while not perfectly accurate, it will still give you a **good hint for your next grow**.''',
      name: 'towelieHelperFormMeasure',
      desc: 'Towelie Helper measure form 2',
      locale: localeName,
    );
  }

  String get towelieHelperFormMeasure2 {
    return Intl.message(
      '''It's the **first time** you're using it, so there is no "before" picture **to compare to**. Take a pic of what you **want to measure**, and take a measure again in **a few days** to have a **difference**.''',
      name: 'towelieHelperFormMeasure2',
      desc: 'Towelie Helper measure form 2',
      locale: localeName,
    );
  }

  String get formAllowAnalytics {
    return Intl.message(
      '''**Help us** discern what's **useful** from what's
**useless** by sharing **anonymous** usage data.
*Note: no third party (ie google, facebook..)
is involved in our data analytics strategy.*''',
      name: 'formAllowAnalytics',
      desc: 'Form allow analytics',
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
