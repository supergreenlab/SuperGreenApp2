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

class TowelieActionHelpWaterReminder extends TowelieActionHelp {
  @override
  String get feedEntryType => 'FE_WATER';

  @override
  Stream<TowelieBlocState> feedEntryTrigger(
      TowelieBlocEventFeedEntryCreated event) async* {
    String notificationText = 'Don\'t forget to water your plant!';
    yield TowelieBlocStateHelper(
        RouteSettings(name: '/feed/plant', arguments: null),
        SGLLocalizations.current.towelieHelperWaterReminder,
        reminders: [
          //TowelieHelperReminder('1 min', event.feedEntry.id, 'Water your plant', notificationText, 1),
          TowelieHelperReminder('3 days', event.feedEntry.id, 'Water your plant', notificationText, 60 * 72),
          TowelieHelperReminder('4 days', event.feedEntry.id, 'Water your plant', notificationText, 60 * 96),
          TowelieHelperReminder('6 days', event.feedEntry.id, 'Water your plant', notificationText, 60 * 144)
        ]);
  }
}
