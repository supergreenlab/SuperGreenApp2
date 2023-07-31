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

const TEMP='TEMP';
const HUMI='HUMI';
const CO2='CO2';
const VPD='VPD';
const WEIGHT='WEIGHT';
const WATERING_LEFT='WATERING_LEFT';

const Map<String, String> LabMetricIcons = {
  TEMP: 'assets/app_bar/icon_temperature.svg',
  HUMI: 'assets/app_bar/icon_humidity.svg',
  CO2: 'assets/app_bar/icon_co2.svg',
  VPD: 'assets/app_bar/icon_vpd.svg',
  WEIGHT: 'assets/app_bar/icon_weight.svg',
  WATERING_LEFT: 'assets/app_bar/icon_watering.svg',
};

const Map<String, String> LabMetricNames = {
  TEMP: 'Temperature',
  HUMI: 'Humidity',
  CO2: 'CO2',
  VPD: 'VPD',
  WEIGHT: 'Weight',
  WATERING_LEFT: 'Watering left',
};