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

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/deep_link/deep_link.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/notifications/local_notification.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/main/main_page.dart';
import 'package:super_green_app/notifications/remote_notification.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/towelie/helpers/misc/towelie_action_help_notification.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  enableVibration: true,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      runApp(MultiBlocProvider(
          providers: <BlocProvider>[
            BlocProvider<MainNavigatorBloc>(
                create: (context) => MainNavigatorBloc(navigatorKey)),
            BlocProvider<TowelieBloc>(create: (context) => TowelieBloc()),
            BlocProvider<DeviceDaemonBloc>(
                create: (context) => DeviceDaemonBloc()),
            BlocProvider<SyncerBloc>(create: (context) => SyncerBloc()),
            BlocProvider<LocalNotificationBloc>(
                create: (context) => LocalNotificationBloc()),
            BlocProvider<RemoteNotificationBloc>(
                create: (context) => RemoteNotificationBloc()),
            BlocProvider<DeepLinkBloc>(create: (context) => DeepLinkBloc()),
          ],
          child:
              BlocListener<LocalNotificationBloc, LocalNotificationBlocState>(
                  listener:
                      (BuildContext context, LocalNotificationBlocState state) {
                    if (state is LocalNotificationBlocStateNotification) {
                      BlocProvider.of<TowelieBloc>(context).add(
                          TowelieBlocEventTrigger(
                              TowelieActionHelpNotification.id,
                              state,
                              ModalRoute.of(context).settings.name));
                    }
                  },
                  child: MainPage(navigatorKey))));
    },
    (dynamic error, StackTrace stackTrace) {
      Logger.log('$error\n$stackTrace');
    },
  );
}
