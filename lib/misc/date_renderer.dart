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

import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:tuple/tuple.dart';

class DateRenderer {
  static String renderSchedule(Param onHour, Param onMin, Param offHour, Param offMin) {
    DateTime on = DateTime(2022, 1, 1, onHour.ivalue!, onMin.ivalue!);
    DateTime off = DateTime(2022, 1, 1, offHour.ivalue!, offMin.ivalue!);
    if (on.isAfter(off)) {
      off = off.add(Duration(days: 1));
    }
    Duration diff = off.difference(on);
    return '${diff.inHours}/${24 - diff.inHours}';
  }

  static String renderAbsoluteDate(DateTime date) {
    String format = AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
    DateFormat f = DateFormat(format);
    return f.format(date);
  }

  static String renderSinceNow(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    return renderDuration(diff);
  }

  static String renderSincePhase(PlantSettings plantSettings, DateTime date) {
    Tuple3<PlantPhases, DateTime, Duration>? phaseData = plantSettings.phaseAt(date);
    if (phaseData == null) {
      return 'Life events not set.';
    }
    List<String Function(Duration)> phases = [
      (Duration diff) => 'Germinated ${renderDuration(phaseData.item3)}',
      (Duration diff) => 'Vegging for ${renderDuration(phaseData.item3, suffix: '')}',
      (Duration diff) => 'Blooming for ${renderDuration(phaseData.item3, suffix: '')}',
      (Duration diff) => 'Drying for ${renderDuration(phaseData.item3, suffix: '')}',
      (Duration diff) => 'Curing for ${renderDuration(phaseData.item3, suffix: '')}'
    ];
    return phases[phaseData.item1.index](phaseData.item3);
  }

  static String renderSinceGermination(PlantSettings plantSettings, DateTime date) {
    if (plantSettings.germinationDate == null) {
      return 'Germination date not set.';
    }
    Duration diff = date.difference(plantSettings.germinationDate!);
    return 'Germinated ${renderDuration(diff)}';
  }

  static String renderDuration(Duration diff, {suffix = ' ago'}) {
    int minuteDiff = diff.inMinutes;
    int hourDiff = diff.inHours;
    int dayDiff = diff.inDays;
    String format;
    if (minuteDiff < 1) {
      format = 'few seconds$suffix';
    } else if (minuteDiff < 60) {
      format = '$minuteDiff minute${minuteDiff > 1 ? 's' : ''}$suffix';
    } else if (hourDiff < 24) {
      format = '$hourDiff hour${hourDiff > 1 ? 's' : ''} ${minuteDiff % 60}min$suffix';
    } else if (dayDiff < 7) {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''} ${hourDiff % 24}h$suffix';
    } else {
      if (dayDiff % 7 == 0) {
        format = '${(dayDiff / 7).floor()} weeks $suffix';
      } else {
        format = '${(dayDiff / 7).floor()} weeks ${dayDiff % 7} days $suffix';
      }
    }
    return format;
  }
}
