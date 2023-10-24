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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:super_green_app/main.dart';
import 'package:super_green_app/notifications/model.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  final Function(NotificationData) onNotificationData;
  final Function(NotificationsBlocEvent) add;

  LocalNotifications(this.add, this.onNotificationData);

  Future init() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_notification');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onSelectNotification);
  }

  Future _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    NotificationData notificationData = NotificationData.fromJSON(payload ?? '{}');
    onNotificationData(notificationData);
  }

  Future _onSelectNotification(NotificationResponse? payload) async {
    NotificationData notificationData = NotificationData.fromJSON(payload?.payload ?? '{}');
    onNotificationData(notificationData);
  }

  Future<bool> checkPermissions() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
        true;
  }

  Future reminderNotification(int id, int afterMinutes, NotificationData notificationData) async {
    if (!await this.checkPermissions()) {
      return;
    }

    var scheduledNotificationDateTime = DateTime.now().add(Duration(minutes: afterMinutes));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('REMINDERS', 'Towelie\'s reminders',
        channelDescription: 'Towelie can help you not forget anything about your grow.');
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, notificationData.title, notificationData.body, tz.TZDateTime.from(scheduledNotificationDateTime, tz.UTC), platformChannelSpecifics,
        androidAllowWhileIdle: true, payload: notificationData.toJSON(),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
