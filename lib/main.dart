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
// @dart=2.9
import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:super_green_app/data/config.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/deep_link/deep_link.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/main/main_page.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pin_lock/pin_lock_bloc.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
  enableVibration: true,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      log("[DEV mode] Firebase disabled; If you see this message while on master you need to revert the commit introducing this message!");

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
