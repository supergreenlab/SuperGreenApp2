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

import 'package:flutter/material.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_action_condition_popup.dart';

class ChecklistActionsSelector extends CreateChecklistActionConditionPopup {
  final void Function(ChecklistAction action) onAdd;

  ChecklistActionsSelector({required this.onAdd, required Function() onClose, required List<String> filteredValues})
      : super(onClose: onClose, title: 'Select new action type', filteredValues: filteredValues);

  Widget renderConditions(BuildContext context) {
    return Column(
      children: [
        renderCondition(context, 'assets/checklist/icon_webpage.svg', 'Open webpage',
            'Open a webpage to complete the checklist entry.', 'Ex: some growweedeasy.com article about pests', () {
          onAdd(ChecklistActionWebpage());
        }),
        renderCondition(context, 'assets/checklist/icon_create_diary.svg', 'Create diary entry',
            'Create a diary entry to complete the checklist entry.', 'Ex: create watering entry', () {
          onAdd(ChecklistActionCreateCard());
        }),
      ],
    );
  }
}
