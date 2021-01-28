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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:super_green_app/main.dart';

abstract class RemoteNotificationBlocEvent extends Equatable {}

class RemoteNotificationBlocEventInit extends RemoteNotificationBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class RemoteNotificationBlocState extends Equatable {}

class RemoteNotificationBlocStateInit extends RemoteNotificationBlocState {
  @override
  List<Object> get props => [];
}

class RemoteNotificationBloc
    extends Bloc<RemoteNotificationBlocEvent, RemoteNotificationBlocState> {
  RemoteNotificationBloc() : super(RemoteNotificationBlocStateInit());

  @override
  Stream<RemoteNotificationBlocState> mapEventToState(
      RemoteNotificationBlocEvent event) async* {
    if (event is RemoteNotificationBlocEventInit) {
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

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        String token = await FirebaseMessaging.instance.getToken();
        FirebaseMessaging.instance.onTokenRefresh.listen(saveToken);
        saveToken(token);
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        androidForegroundNotification(message);
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
    }
  }

  Future saveToken(String token) async {
    print(token);
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
          ));
    }
  }
}
