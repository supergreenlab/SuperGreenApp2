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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/notifications/model.dart';
import 'package:super_green_app/towelie/buttons/reminder/towelie_button_reminder.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpMeasureReminder extends TowelieActionHelp {
  static String get towelieHelperMeasureReminder {
    return Intl.message(
      '''Do you want me to **set a reminder** so you don't forget to take a measure again soon?''',
      name: 'towelieHelperMeasureReminder',
      desc: 'Towelie Helper measure reminder',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  String get feedEntryType => 'FE_MEASURE';

  @override
  Stream<TowelieBlocState> feedEntryTrigger(
      TowelieBlocEventFeedEntryCreated event) async* {
    Plant plant =
        await RelDB.get().plantsDAO.getPlantWithFeed(event.feedEntry.feed);
    yield TowelieBlocStateHelper(
        RouteSettings(name: '/feed/plant', arguments: null),
        TowelieActionHelpMeasureReminder.towelieHelperMeasureReminder,
        buttons: [
          TowelieButtonReminder.createButton(
              '1 day',
              NotificationDataReminder(
                  id: event.feedEntry.id,
                  title: 'Take the next measure',
                  body: '${plant.name} was measured 1 day ago.',
                  plantID: plant.id),
              60 * 24),
          TowelieButtonReminder.createButton(
              '2 days',
              NotificationDataReminder(
                  id: event.feedEntry.id,
                  title: 'Take the next measure',
                  body: '${plant.name} was measured 2 day ago.',
                  plantID: plant.id),
              60 * 24 * 2),
          TowelieButtonReminder.createButton(
              '3 days',
              NotificationDataReminder(
                  id: event.feedEntry.id,
                  title: 'Take the next measure',
                  body: '${plant.name} was measured 3 day ago.',
                  plantID: plant.id),
              60 * 24 * 3),
          TowelieButtonReminder.createButton(
              '4 days',
              NotificationDataReminder(
                  id: event.feedEntry.id,
                  title: 'Take the next measure',
                  body: '${plant.name} was measured 4 day ago.',
                  plantID: plant.id),
              60 * 24 * 4),
          TowelieButtonReminder.createButton(
              '6 days',
              NotificationDataReminder(
                  id: event.feedEntry.id,
                  title: 'Take the next measure',
                  body: '${plant.name} was measured 6 day ago.',
                  plantID: plant.id),
              60 * 24 * 6)
        ]);
  }
}
