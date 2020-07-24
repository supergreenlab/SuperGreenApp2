/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_feed_state.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';
import 'package:tuple/tuple.dart';

enum FeedCardDateDisplay {
  ABSOLUTE,
  SINCE_NOW,
  SINCE_PHASE,
}

class FeedCardDate extends StatefulWidget {
  final FeedEntryState feedEntryState;
  final FeedState feedState;

  const FeedCardDate(this.feedEntryState, this.feedState);

  @override
  _FeedCardDateState createState() => _FeedCardDateState();
}

class _FeedCardDateState extends State<FeedCardDate> {
  FeedCardDateDisplay display = FeedCardDateDisplay.SINCE_NOW;

  @override
  Widget build(BuildContext context) {
    String format;
    if (display == FeedCardDateDisplay.ABSOLUTE) {
      format = renderAbsoluteDate();
    } else if (display == FeedCardDateDisplay.SINCE_NOW) {
      format = renderSinceNow();
    } else if (display == FeedCardDateDisplay.SINCE_PHASE) {
      format = renderSincePhase();
    }
    return InkWell(
        onTap: () {
          int index = FeedCardDateDisplay.values.indexOf(display);
          index = (index + 1) % FeedCardDateDisplay.values.length;
          if (FeedCardDateDisplay.values[index] ==
                  FeedCardDateDisplay.SINCE_PHASE &&
              !(widget.feedState is PlantFeedState)) {
            index = (index + 1) % FeedCardDateDisplay.values.length;
          }
          setState(() {
            display = FeedCardDateDisplay.values[index];
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(format, style: TextStyle(color: Colors.black54)),
            Text('Tap to change', style: TextStyle(color: Colors.black12)),
          ],
        ));
  }

  String renderAbsoluteDate() {
    String format =
        AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
    DateFormat f = DateFormat(format);
    return f.format(widget.feedEntryState.date);
  }

  String renderSinceNow() {
    Duration diff = DateTime.now().difference(widget.feedEntryState.date);
    int minuteDiff = diff.inMinutes;
    int hourDiff = diff.inHours;
    int dayDiff = diff.inDays;
    String format;
    if (minuteDiff < 60) {
      format = '$minuteDiff minute${minuteDiff > 1 ? 's' : ''} ago';
    } else if (hourDiff < 24) {
      format = '$hourDiff hour${hourDiff > 1 ? 's' : ''} ago';
    } else {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''} ago';
    }
    return format;
  }

  String renderSincePhase() {
    PlantFeedState plantFeedState = widget.feedState;
    Tuple3<PlantPhases, DateTime, Duration> phaseData =
        plantFeedState.plantSettings.phaseAt(widget.feedEntryState.date);
    if (phaseData == null) {
      return 'Life events not set.';
    }
    List<String Function(Duration)> phases = [
      (Duration diff) => 'Germinated ${phaseData.item3.inDays} days ago',
      (Duration diff) => 'Vegging for ${phaseData.item3.inDays} days',
      (Duration diff) => 'Blooming for ${phaseData.item3.inDays} days',
      (Duration diff) => 'Drying for ${phaseData.item3.inDays} days',
      (Duration diff) => 'Curing for ${phaseData.item3.inDays} days'
    ];
    return phases[phaseData.item1.index](phaseData.item3);
  }
}
