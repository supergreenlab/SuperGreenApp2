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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_buyproduct_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_createcard_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_webpage_page.dart';

abstract class ChecklistActionButton extends StatelessWidget {
  final Plant plant;
  final Box box;
  final ChecklistSeed checklistSeed;
  final ChecklistAction checklistAction;

  final Function() onCheck;
  final Function() onSkip;

  const ChecklistActionButton({Key? key, required this.plant, required this.box, required this.checklistSeed, required this.checklistAction, required this.onCheck, required this.onSkip}) : super(key: key);

  static Widget getActionPage({required Plant plant, required Box box, required ChecklistSeed checklistSeed, required ChecklistAction checklistAction, required Function() onCheck, required Function() onSkip}) {
    switch (checklistAction.type) {
      case ChecklistActionWebpage.TYPE:
        return ChecklistActionWebpageButton(plant: plant, box: box, checklistSeed: checklistSeed, checklistAction: checklistAction, onCheck: onCheck, onSkip: onSkip);
      case ChecklistActionCreateCard.TYPE:
        return ChecklistActionCreateCardButton(plant: plant, box: box, checklistSeed: checklistSeed, checklistAction: checklistAction, onCheck: onCheck, onSkip: onSkip);
      case ChecklistActionBuyProduct.TYPE:
        return ChecklistActionBuyProductButton(plant: plant, box: box, checklistSeed: checklistSeed, checklistAction: checklistAction, onCheck: onCheck, onSkip: onSkip);
    }
    throw 'Uknown type ${checklistAction.type}';
  }
}
