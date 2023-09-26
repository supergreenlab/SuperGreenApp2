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
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
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
    date: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
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
                onPressed: condition.valid == false
                    ? null
                    : () {
                        String instructions = '''
# When to water

Make sure your soil is dry before watering, best way to check that is to check the dryness of the first inch of soil, if it's not dry, wait a few more days, and if you can, try to lift the pot manually, a dry soil is noticeably lightweight.

# Make sure you don't overwater

**If you PH seems right, make sure you are not over watering your plant**

Make sure the whole soil is dry before watering, just the top layer of soil being dry is not enough, the rest is certainly still humid.

![Dryness direction](https://www.supergreenlab.com/img/files/atttO4BAih4eTtxGY.jpg)

You can do a first "finger test", make sure to test deep enough.

![Dryness direction](https://www.supergreenlab.com/img/files/attN3ySXUYFNtBXGJ.jpg)

What you will want is something like the picture here, **the best way to test this is to weight the pot manually**, a dry soil is noticeably lighter.

![Dryness direction](https://www.supergreenlab.com/img/files/attEufkItB4Bm0Mw0.jpg)

# How to water

Follow these 3 steps to make sure your soil is well watered:

# 1. Place pot in a plate

![Pic](https://www.supergreenlab.com/img/files/attig9yWzQqc2zBTR.jpg)

# 2. Wait until run-off is absorbed

![Pic](https://www.supergreenlab.com/img/files/attLsvB1lFMOMQGCA.jpg)

# 3. Add more run-off if needed

![Pic](https://www.supergreenlab.com/img/files/attSbOfquWiBoP2tn.jpg)

# 4. Remove remaining run-off

![Pic](https://www.supergreenlab.com/img/files/attJg4Px8XDhCR6gO.jpg)

                        ''';
                        ChecklistActionCreateCard waterAction = ChecklistActionCreateCard(
                          entryType: FE_WATER,
                        );
                        /* ChecklistActionCreateCard mediaAction = ChecklistActionCreateCard(
                          entryType: FE_MEDIA,
                          instructions: 'Take a pic of your plant before the watering to see the difference.',
                        ); */
                        BlocProvider.of<ChecklistBloc>(context)
                            .add(ChecklistBlocEventCreate(ChecklistSeedsCompanion.insert(
                          checklist: widget.checklist.id,
                          title: drift.Value('Water plant reminder'),
                          description: drift.Value(instructions),
                          category: drift.Value(CH_FEEDING),
                          fast: drift.Value(false),
                          public: drift.Value(false),
                          repeat: drift.Value((condition as ChecklistConditionTimer).repeat),
                          mine: drift.Value(true),
                          conditions: drift.Value('[${condition.toJSON()}]'),
                          exitConditions: drift.Value('[]'),
                          actions: drift.Value('[${waterAction.toJSON()}]'), // ${mediaAction.toJSON()},
                          synced: drift.Value(false),
                        )));
                        SyncerBloc syncerBloc = BlocProvider.of<SyncerBloc>(context);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          syncerBloc.add(SyncerBlocEventForceSyncChecklists());
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
