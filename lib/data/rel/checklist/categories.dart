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