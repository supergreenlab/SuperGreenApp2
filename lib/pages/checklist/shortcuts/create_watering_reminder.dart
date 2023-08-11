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

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/checklist/categories.dart';
import 'package:super_green_app/data/rel/checklist/conditions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/checklist/checklist_bloc.dart';
import 'package:super_green_app/pages/checklist/create/conditions/timer_condition_page.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';

class CreateWateringReminder extends StatefulWidget {
  final Function() onClose;
  final Checklist checklist;

  const CreateWateringReminder({Key? key, required this.checklist, required this.onClose}) : super(key: key);

  @override
  State<CreateWateringReminder> createState() => _CreateWateringReminderState();
}

class _CreateWateringReminderState extends State<CreateWateringReminder> {
  ChecklistCondition condition = ChecklistConditionTimer(
    date: DateTime.now().add(Duration(days: 1)),
  );

  @override
  Widget build(BuildContext context) {
    ChecklistActionCreateCard action = ChecklistActionCreateCard(
      entryType: FE_WATER,
    );
    return Column(
      children: [
        TimerConditionPage(
          condition: condition as ChecklistConditionTimer,
          onUpdate: (ChecklistCondition condition) {
            setState(() {
              this.condition = condition;
            });
          },
          hideTitle: true,
          noBorder: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GreenButton(
                title: 'Create',
                onPressed: condition.valid == false || action.valid == false
                    ? null
                    : () {
                        BlocProvider.of<ChecklistBloc>(context)
                            .add(ChecklistBlocEventCreate(ChecklistSeedsCompanion.insert(
                          checklist: 1,
                          title: drift.Value('Water plant reminder'),
                          category: drift.Value(CH_FEEDING),
                          public: drift.Value(false),
                          repeat: drift.Value(false),
                          conditions: drift.Value('[${condition.toJSON()}]'),
                          exitConditions: drift.Value('[]'),
                          actions: drift.Value('[${action.toJSON()}]'),
                          synced: drift.Value(false),
                        )));
                        Future.delayed(const Duration(milliseconds: 500), () {
                          BlocProvider.of<SyncerBloc>(context).add(SyncerBlocEventForceSyncChecklists());
                        });
                        widget.onClose();
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
