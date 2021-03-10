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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/notification/notification_request_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';

class NotificationRequestPage extends TraceableStatelessWidget {
  static String get notificationRequestButton {
    return Intl.message(
      'NOTIFY ME',
      name: 'notificationRequestButton',
      desc: 'Notification request button',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get notificationRequestButtonCancel {
    return Intl.message(
      'NO THANKS',
      name: 'notificationRequestButtonCancel',
      desc: 'Notification request button cancel',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get notificationRequestTitle {
    return Intl.message(
      'Would you like to activate notifications?',
      name: 'notificationRequestTitle',
      desc: 'Notification request purpose',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get notificationPurposes {
    return Intl.message(
      '''You will get notified for:
- **Likes** on comments and public diary entry
- **Comments** on public diary entries
- **Replies** to your comments
- **Smart reminders** and **grow tips**
- **Temperature** and **humidity** alerts''',
      name: 'notificationPurposes',
      desc: 'Notification purpose',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 4.0,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: SvgPicture.asset(
                    'assets/home/icon_notification.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
                Expanded(
                  child: Text(
                    NotificationRequestPage.notificationRequestTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: ListView(
                children: [
                  MarkdownBody(
                    fitContent: false,
                    data: NotificationRequestPage.notificationPurposes,
                    styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: Colors.black, fontSize: 16),
                        strong: TextStyle(color: Color(0xff3bb30b), fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GreenButton(
                    color: Colors.red.value,
                    title: NotificationRequestPage.notificationRequestButtonCancel,
                    onPressed: () async {
                      BlocProvider.of<NotificationRequestBloc>(context).add(NotificationRequestBlocEventDone());
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GreenButton(
                  title: NotificationRequestPage.notificationRequestButton,
                  onPressed: () async {
                    await NotificationsBloc.remoteNotifications.requestPermissions();
                    BlocProvider.of<NotificationRequestBloc>(context).add(NotificationRequestBlocEventDone());
                  },
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
