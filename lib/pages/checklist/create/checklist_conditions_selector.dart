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
import 'package:super_green_app/data/rel/checklist/conditions.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_action_condition_popup.dart';

class ChecklistConditionsSelector extends CreateChecklistActionConditionPopup {
  final void Function(ChecklistCondition action) onAdd;

  ChecklistConditionsSelector({required this.onAdd, required Function() onClose, required List<String> filteredValues})
      : super(onClose: onClose, title: 'Select new condition type', filteredValues: filteredValues);

  Widget renderConditions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        this.filteredValues.contains(ChecklistConditionTimer.TYPE) ? Container() : renderCondition(
            context,
            'assets/checklist/icon_reminder.svg',
            'Time reminder',
            'Just a simple reminder, set a date and it will show up in your checklist at that date.',
            'Ex: In X days.', () {
          onAdd(ChecklistConditionTimer(date: DateTime.now().add(Duration(days: 1)),));
        }),
        this.filteredValues.contains(ChecklistConditionMetric.TYPE) ? Container() : renderCondition(
            context,
            'assets/checklist/icon_monitoring.svg',
            'Metric monitoring',
            'This checklist item will show up in your checklist if a metric is in or out of a given range.',
            'Ex: When temperature is >X° for 3 days.', () {
          onAdd(ChecklistConditionMetric());
        }),
        this.filteredValues.contains(ChecklistConditionAfterCard.TYPE) ? Container() : renderCondition(
            context,
            'assets/checklist/icon_diary.svg',
            'After a diary entry is created',
            'Choose a diary entry type and set a duration after which this checklist entry will show up in your checklist.',
            'Ex: 5 days after last watering card', () {
          onAdd(ChecklistConditionAfterCard());
        }),
        this.filteredValues.contains(ChecklistConditionAfterPhase.TYPE) ? Container() : renderCondition(
            context,
            'assets/checklist/icon_phase.svg',
            'Plant phase',
            'Select a phase and a duration. This checklist item will show up on time in your checklist.',
            'Ex: after 2 weeks into bloom, start the next seeds', () {
          onAdd(ChecklistConditionAfterPhase());
        }),
      ],
    );
  }
}
