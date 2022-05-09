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

import 'package:super_green_app/notifications/model.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_button.dart';

const _id = 'REMINDER';

class TowelieButtonReminder extends TowelieButton {
  @override
  String get id => _id;

  static Map<String, dynamic> createButton(String title, NotificationData notificationData, int afterMinutes) =>
      TowelieButton.createButton(_id, {
        'title': title,
        'notificationID': notificationData.id,
        'notificationTitle': notificationData.title,
        'notificationBody': notificationData.body,
        'notificationPayload': notificationData.toJSON(),
        'afterMinutes': afterMinutes,
      });

  @override
  Stream<TowelieBlocState> buttonPressed(TowelieBlocEventButtonPressed event) async* {
    NotificationsBloc.localNotifications.reminderNotification(event.params['notificationID'],
        event.params['afterMinutes'], NotificationData.fromJSON(event.params['notificationPayload']));
    if (event.feedEntry != null) {
      await selectButtons(event.feedEntry,
          selector: (params) => params['afterMinutes'] == event.params['afterMinutes']);
    }
  }
}
