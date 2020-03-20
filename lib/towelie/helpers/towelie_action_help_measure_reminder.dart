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
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_helper.dart';

class TowelieActionHelpMeasureReminder extends TowelieActionHelp {
  @override
  String get feedEntryType => 'FE_MEASURE';

  @override
  Stream<TowelieBlocState> feedEntryTrigger(
      TowelieBlocEventFeedEntryCreated event) async* {
    String notificationText = 'Don\'t forget to take the next measure!';
    yield TowelieBlocStateHelper(
        RouteSettings(name: '/feed/box', arguments: null),
        SGLLocalizations.current.towelieHelperMeasureReminder,
        reminders: [
          TowelieHelperReminder('1 min', event.feedEntry.id, 'Take the next measure', notificationText, 1),
          TowelieHelperReminder('2 days', event.feedEntry.id, 'Take the next measure', notificationText, 60 * 48),
          TowelieHelperReminder('3 days', event.feedEntry.id, 'Take the next measure', notificationText, 60 * 72),
          TowelieHelperReminder('4 days', event.feedEntry.id, 'Take the next measure', notificationText, 60 * 96),
          TowelieHelperReminder('6 days', event.feedEntry.id, 'Take the next measure', notificationText, 60 * 144)
        ]);
  }
}
