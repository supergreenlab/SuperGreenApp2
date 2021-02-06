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
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/main.dart';
import 'package:super_green_app/notifications/model.dart';
import 'package:super_green_app/notifications/notifications.dart';

class RemoteNotifications {
  final Function(NotificationData) onNotificationData;
  final Function(NotificationsBlocEvent) add;

  RemoteNotifications(this.add, this.onNotificationData);

  Future init() async {
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      Logger.log(await FirebaseMessaging.instance.getToken());
      try {
        await sendToken();
      } catch (e) {
        Logger.log(e);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen(saveToken);
    } else if (BackendAPI().usersAPI.loggedIn) {
      Timer(Duration(milliseconds: 3000), () {
        add(NotificationsBlocEventRequestPermission());
      });
    }
    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Timer(Duration(milliseconds: 300), () {
        notificationSelected(initialMessage);
      });
    }
    FirebaseMessaging.onMessage.listen(notificationReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(notificationSelected);
  }

  void notificationReceived(RemoteMessage message) {
    androidForegroundNotification(message);
    this._printDebugInfos(message);
  }

  void notificationSelected(RemoteMessage message) {
    NotificationData notificationData = NotificationData.fromMap(message.data);
    onNotificationData(notificationData);
  }

  Future saveToken(String token) async {
    print(token);
    if (AppDB().getAppData().notificationToken != token) {
      AppDB().getAppData().notificationToken = token;
      AppDB().getAppData().notificationTokenSent = false;
      sendToken();
    }
  }

  Future sendToken() async {
    if (BackendAPI().usersAPI.loggedIn && AppDB().getAppData().notificationTokenSent == false) {
      await BackendAPI().feedsAPI.updateNotificationToken(AppDB().getAppData().notificationToken);
      AppDB().getAppData().notificationTokenSent = true;
    }
  }

  Future<bool> requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      String token = await FirebaseMessaging.instance.getToken();
      FirebaseMessaging.instance.onTokenRefresh.listen(saveToken);
      saveToken(token);
      return true;
    }
    return false;
  }

  static Future<bool> checkPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  void androidForegroundNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: android?.smallIcon,
            ),
          ),
          payload: JsonEncoder().convert(message.data));
    }
  }

  void _printDebugInfos(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }
}
