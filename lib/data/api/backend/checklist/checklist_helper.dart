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

import 'package:drift/drift.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class ChecklistHelper {
  static Future deleteChecklist(Checklist checklist, {addDeleted = true}) async {
    await RelDB.get().checklistsDAO.deleteChecklist(checklist);
    if (addDeleted && checklist.serverID != null) {
      await RelDB.get()
          .deletesDAO
          .addDelete(DeletesCompanion(serverID: Value(checklist.serverID!), type: Value('checklists')));
    }

    List<ChecklistSeed> checklistSeeds = await RelDB.get().checklistsDAO.getChecklistSeeds(checklist.id);
    for (ChecklistSeed checklistSeed in checklistSeeds) {
      await ChecklistHelper.deleteChecklistSeed(checklistSeed, addDeleted: addDeleted);
    }
  }

  static Future deleteChecklistSeed(ChecklistSeed checklistSeed, {addDeleted = true}) async {
    await RelDB.get().checklistsDAO.deleteChecklistSeed(checklistSeed);
    if (addDeleted && checklistSeed.serverID != null) {
      await RelDB.get()
          .deletesDAO
          .addDelete(DeletesCompanion(serverID: Value(checklistSeed.serverID!), type: Value('checklistseeds')));
    }

    List<ChecklistLog> checklistLogs = await RelDB.get().checklistsDAO.getChecklistLogsForChecklistSeed(checklistSeed);
    for (ChecklistLog checklistLog in checklistLogs) {
      await ChecklistHelper.deleteChecklistLog(checklistLog);
    }
  }

  static Future deleteChecklistLog(ChecklistLog checklistLog) async {
    if (checklistLog.checked || checklistLog.skipped) {
      return;
    }
    await RelDB.get().checklistsDAO.updateChecklistLog(checklistLog.copyWith(skipped: true, synced: false).toCompanion(true));
  }

  static Future checkChecklistLog(ChecklistLog checklistLog) async {
    await RelDB.get().checklistsDAO.updateChecklistLog(checklistLog.copyWith(checked: true, synced: false).toCompanion(true));
  }

  static Future skipChecklistLog(ChecklistLog checklistLog) async {
    await RelDB.get().checklistsDAO.updateChecklistLog(checklistLog.copyWith(skipped: true, synced: false).toCompanion(true));
  }
}
