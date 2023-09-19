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

import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/checklist/conditions.dart';

const CH_FEEDING='FEEDING';
const CH_PESTS='PESTS';
const CH_TRAINING='TRAINING';
const CH_ENVIRONMENT='ENVIRONMENT';
const CH_SUPPLY='SUPPLY';
const CH_OTHER='OTHER';

const Map<String, String> ChecklistCategoryIcons = {
  CH_FEEDING: 'assets/checklist/icon_watering.svg',
  CH_PESTS: 'assets/checklist/icon_pests.svg',
  CH_TRAINING: 'assets/checklist/icon_training.svg',
  CH_ENVIRONMENT: 'assets/checklist/icon_environment.svg',
  CH_SUPPLY: 'assets/checklist/icon_supply.svg',
  CH_OTHER: 'assets/checklist/icon_other.svg',
};

const Map<String, String> ChecklistCategoryNames = {
  CH_FEEDING: 'Feeding',
  CH_PESTS: 'Pest/fungus/parasits control',
  CH_TRAINING: 'Plant care and training',
  CH_ENVIRONMENT: 'Environment',
  CH_SUPPLY: 'Supply',
  CH_OTHER: 'Other',
};

const Map<String, String> ChecklistConditionIcons = {
  ChecklistConditionTimer.TYPE: 'assets/checklist/icon_reminder.svg',
  ChecklistConditionMetric.TYPE: 'assets/checklist/icon_monitoring.svg',
  ChecklistConditionAfterCard.TYPE: 'assets/checklist/icon_diary.svg',
  ChecklistConditionAfterPhase.TYPE: 'assets/checklist/icon_phase.svg',
};

const Map<String, String> ChecklistActionIcons = {
  ChecklistActionWebpage.TYPE: 'assets/checklist/icon_webpage.svg',
  ChecklistActionCreateCard.TYPE: 'assets/checklist/icon_create_diary.svg',
  ChecklistActionBuyProduct.TYPE: 'assets/checklist/icon_buy_product.svg',
  ChecklistActionMessage.TYPE: 'assets/checklist/icon_message.svg',
};

const CO_BASICS='BASICS';
const CO_NUTRIENT='NUTRIENT';
const CO_RECIPE='RECIPE';

const Map<String, String> ChecklistCollectionCategory = {
  CO_BASICS: 'assets/checklist/icon_daily_checks.svg',
  CO_NUTRIENT: 'assets/checklist/icon_nutrient.svg',
  CO_RECIPE: 'assets/checklist/icon_recipe.svg',
};