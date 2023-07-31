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
  final ChecklistSeed checklistSeed;
  final ChecklistAction checklistAction;

  const ChecklistActionButton({Key? key, required this.plant, required this.checklistSeed, required this.checklistAction}) : super(key: key);

  static Widget getActionPage(Plant plant, ChecklistSeed checklistSeed, ChecklistAction checklistAction) {
    switch (checklistAction.type) {
      case ChecklistActionWebpage.TYPE:
        return ChecklistActionWebpageButton(plant: plant, checklistSeed: checklistSeed, checklistAction: checklistAction);
      case ChecklistActionCreateCard.TYPE:
        return ChecklistActionCreateCardButton(plant: plant, checklistSeed: checklistSeed, checklistAction: checklistAction);
      case ChecklistActionBuyProduct.TYPE:
        return ChecklistActionBuyProductButton(plant: plant, checklistSeed: checklistSeed, checklistAction: checklistAction);
    }
    throw 'Uknown type ${checklistAction.type}';
  }
}
