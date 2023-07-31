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

// TODO move those as static fields in their rel_db classes
import 'package:flutter/material.dart';

const FE_MEDIA='FE_MEDIA';
const FE_MEASURE='FE_MEASURE';
const FE_TRANSPLANT='FE_TRANSPLANT';
const FE_BENDING='FE_BENDING';
const FE_FIMMING='FE_FIMMING';
const FE_TOPPING='FE_TOPPING';
const FE_DEFOLIATION='FE_DEFOLIATION';
const FE_TIMELAPSE='FE_TIMELAPSE';
const FE_NUTRIENT_MIX='FE_NUTRIENT_MIX';
const FE_WATER='FE_WATER';
const FE_LIGHT='FE_LIGHT';
const FE_VENTILATION='FE_VENTILATION';
const FE_SCHEDULE='FE_SCHEDULE';

const FE_SCHEDULE_VEG='FE_SCHEDULE_VEG';
const FE_SCHEDULE_BLOOM='FE_SCHEDULE_BLOOM';
const FE_SCHEDULE_AUTO='FE_SCHEDULE_AUTO';

const FE_LIFE_EVENT='FE_LIFE_EVENT';
const FE_TOWELIE_INFO='FE_TOWELIE_INFO';

const Map<String, String> FeedEntryIcons = {
  FE_MEDIA: 'assets/feed_card/icon_media.svg',
  FE_MEASURE: 'assets/feed_card/icon_measure.svg',
  FE_TRANSPLANT: 'assets/feed_card/icon_transplant.svg',
  FE_BENDING: 'assets/feed_card/icon_bending.svg',
  FE_FIMMING: 'assets/feed_card/icon_fimming.svg',
  FE_TOPPING: 'assets/feed_card/icon_topping.svg',
  FE_DEFOLIATION: 'assets/feed_card/icon_defoliation.svg',
  FE_TIMELAPSE: 'assets/feed_card/icon_timelapse.svg',
  FE_NUTRIENT_MIX: 'assets/feed_card/icon_nutrient_mix.svg',
  FE_WATER: 'assets/feed_card/icon_watering.svg',
  FE_LIGHT: 'assets/feed_card/icon_light.svg',
  FE_VENTILATION: 'assets/feed_card/icon_blower.svg',
  
  FE_SCHEDULE: 'assets/feed_card/icon_schedule.svg',
  FE_SCHEDULE_VEG: 'assets/feed_card/icon_schedule.svg',
  FE_SCHEDULE_BLOOM: 'assets/feed_card/icon_schedule.svg',
  FE_SCHEDULE_AUTO: 'assets/feed_card/icon_schedule.svg',

  FE_LIFE_EVENT: 'assets/plant_infos/icon_germination_date.svg',
  FE_TOWELIE_INFO: 'assets/feed_card/icon_towelie.png',
};

const Map<String, String> FeedEntryNames = {
  FE_MEDIA: 'Media',
  FE_MEASURE: 'Measure',
  FE_TRANSPLANT: 'Transplant',
  FE_BENDING: 'Banding',
  FE_FIMMING: 'Fimming',
  FE_TOPPING: 'Topping',
  FE_DEFOLIATION: 'Defoliation',
  FE_TIMELAPSE: 'Timelapse',
  FE_NUTRIENT_MIX: 'Nutrient mix',
  FE_WATER: 'Watering',
  FE_LIGHT: 'Light',
  FE_VENTILATION: 'Ventilation',

  FE_SCHEDULE: 'Schedule',
  FE_SCHEDULE_VEG: 'Veg schedule',
  FE_SCHEDULE_BLOOM: 'Bloom schedule',
  FE_SCHEDULE_AUTO: 'Auto schedule',

  FE_LIFE_EVENT: 'Life event',
  FE_TOWELIE_INFO: 'Towelie',
};

const Map<String, Color> FeedEntryColors = {
  FE_MEDIA: Colors.blueGrey,
  FE_MEASURE: Colors.blueGrey,
  FE_TRANSPLANT: Colors.blueGrey,
  FE_BENDING: Colors.blueGrey,
  FE_FIMMING: Colors.blueGrey,
  FE_TOPPING: Colors.blueGrey,
  FE_DEFOLIATION: Colors.blueGrey,
  FE_TIMELAPSE: Colors.blueGrey,
  FE_NUTRIENT_MIX: Color(0xFF506EBA),
  FE_WATER: Color(0xFF506EBA),
  FE_LIGHT: Colors.blueGrey,
  FE_VENTILATION: Colors.blueGrey,

  FE_SCHEDULE: Colors.blueGrey,
  FE_SCHEDULE_VEG: Colors.blueGrey,
  FE_SCHEDULE_BLOOM: Colors.blueGrey,
  FE_SCHEDULE_AUTO: Colors.blueGrey,

  FE_LIFE_EVENT: Colors.blueGrey,
  FE_TOWELIE_INFO: Colors.blueGrey,
};

const Map<String, String> FeedEntryActionIcons = {
  FE_MEDIA: 'assets/app_bar/icon_growlog.svg',
  FE_MEASURE: 'assets/app_bar/icon_growlog.svg',
  FE_TRANSPLANT: 'assets/app_bar/icon_growlog.svg',
  FE_BENDING: 'assets/app_bar/icon_growlog.svg',
  FE_FIMMING: 'assets/app_bar/icon_growlog.svg',
  FE_TOPPING: 'assets/app_bar/icon_growlog.svg',
  FE_DEFOLIATION: 'assets/app_bar/icon_growlog.svg',
  FE_TIMELAPSE: 'assets/app_bar/icon_growlog.svg',
  FE_NUTRIENT_MIX: 'assets/app_bar/icon_watering.svg',
  FE_WATER: 'assets/app_bar/icon_watering.svg',
  FE_LIGHT: 'assets/app_bar/icon_growlog.svg',
  FE_VENTILATION: 'assets/app_bar/icon_growlog.svg',
  
  FE_SCHEDULE: 'assets/app_bar/icon_growlog.svg',
  FE_SCHEDULE_VEG: 'assets/app_bar/icon_growlog.svg',
  FE_SCHEDULE_BLOOM: 'assets/app_bar/icon_growlog.svg',
  FE_SCHEDULE_AUTO: 'assets/app_bar/icon_growlog.svg',

  FE_LIFE_EVENT: 'assets/app_bar/icon_growlog.svg',
  FE_TOWELIE_INFO: 'assets/app_bar/icon_growlog.svg',
};