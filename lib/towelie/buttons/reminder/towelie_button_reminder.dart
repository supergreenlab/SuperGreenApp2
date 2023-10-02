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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/checklist/conditions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/notifications/model.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:uuid/uuid.dart';

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
    NotificationDataReminder notificationData =
        NotificationDataReminder.fromMap(json.decode(event.params['notificationPayload']));

    if (event.feedEntry != null) {
      await selectButtons(event.feedEntry,
          selector: (params) => params['afterMinutes'] == event.params['afterMinutes']);
    }

    if (AppDB().getAppData().jwt == null) {
      return;
    }

    Checklist? checklist;
    try {
      checklist = await RelDB.get().checklistsDAO.getChecklistForPlant(notificationData.plantID);
    } catch (e) {}
    if (checklist == null) {
      int checklistID = await RelDB.get().checklistsDAO.addChecklist(ChecklistsCompanion.insert(
            plant: notificationData.plantID,
            synced: Value(false),
          ));
      checklist = await RelDB.get().checklistsDAO.getChecklist(checklistID);
    }

    ChecklistActionCreateCard action = ChecklistActionCreateCard(
      entryType: FE_WATER,
    );
    ChecklistCondition condition = ChecklistConditionTimer(
      id: Uuid().v4(),
      date: DateTime.now().add(Duration(days: 1)),
    );
    ChecklistSeedsCompanion reminder = ChecklistSeedsCompanion.insert(
      checklist: checklist.id,
      checklistServerID: Value(checklist.serverID),
      title: Value('Water plant reminder'),
      category: Value(CH_FEEDING),
      public: Value(false),
      repeat: Value(false),
      mine: Value(true),
      conditions: Value('[${condition.toJSON()}]'),
      exitConditions: Value('[]'),
      actions: Value('[${action.toJSON()}]'),
      synced: Value(false),
    );
    await RelDB.get().checklistsDAO.addChecklistSeed(reminder);
    BlocProvider.of<SyncerBloc>(event.context).add(SyncerBlocEventForceSyncChecklists());
  }
}
