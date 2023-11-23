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

import 'dart:async';
import 'dart:io';

import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/kv/models/device_data.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/deep_link/deep_link.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/main/main_page.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/settings/auth/common/captcha.dart';
import 'package:super_green_app/pin_lock/pin_lock_bloc.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

import 'data/config.dart';
import 'pages/feeds/home/common/settings/user_settings.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
  enableVibration: true,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final Directory tmpDocDir = await getTemporaryDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(AppDataAdapter());
  Hive.registerAdapter(DeviceDataAdapter());
  Hive.registerAdapter(UserSettingsAdapter());

  AppDB().documentPath = appDocDir.path;
  AppDB().tmpPath = tmpDocDir.path;

  final String dirPath = '${appDocDir.path}/Pictures/sgl';
  await Directory(dirPath).create(recursive: true);

  await AppDB().init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  RecaptchaHandler.instance.setupSiteKey(dataSiteKey: Config.recaptchaKey);

  await Logger.init();
  FlutterError.onError = (FlutterErrorDetails details) {
    Logger.logError(details.exception, details.stack);
  };

  final AppData appData = AppDB().getAppData();

  if (appData.storeGeo == null) {
    final Map<String, String> localeToStoreGeo = {
      'en_US': 'us_us',
      'de_DE': 'eu_de',
      'fr_FR': 'eu_fr',
    };
    final String? locale = await Devicelocale.currentLocale;
    AppDB().setStoreGeo(localeToStoreGeo[locale] ?? 'us_us');
  }

  // TODO remove this when all devices have migrated to new settings
  if (!AppDB().hasUserSettings()) {
    UserSettings userSettings = AppDB().getUserSettings();
    userSettings.freedomUnits = AppDB().getAppData().freedomUnits;
    AppDB().setUserSettings(userSettings);
  }

  BackendAPI(); // force init
  if (BackendAPI().usersAPI.loggedIn) {
    try {
      BackendAPI().blockedUserIDs = await BackendAPI().feedsAPI.fetchBlockedUserIDs();
      await BackendAPI().usersAPI.syncUserSettings();
    } catch (e, t) {
      Logger.logError(e, t);
    }
  }
}

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      await initApp();

      runApp(MultiBlocProvider(providers: <BlocProvider>[
        BlocProvider<PinLockBloc>(create: (context) => PinLockBloc()),
        BlocProvider<MainNavigatorBloc>(create: (context) => MainNavigatorBloc(navigatorKey)),
        BlocProvider<TowelieBloc>(create: (context) => TowelieBloc()),
        BlocProvider<DeviceDaemonBloc>(create: (context) => DeviceDaemonBloc()),
        BlocProvider<SyncerBloc>(create: (context) => SyncerBloc()),
        BlocProvider<NotificationsBloc>(create: (context) => NotificationsBloc()),
        BlocProvider<DeepLinkBloc>(create: (context) => DeepLinkBloc()),
      ], child: MainPage(navigatorKey)));
    },
    (dynamic error, StackTrace stackTrace) {
      Logger.logError(error, stackTrace);
    },
  );
}
