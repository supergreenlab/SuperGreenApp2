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
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:tuple/tuple.dart';

enum FeedCardDateDisplay {
  ABSOLUTE,
  SINCE_NOW,
  SINCE_PHASE,
  SINCE_GERMINATION,
}

class FeedCardDate extends StatefulWidget {
  final FeedEntryState feedEntryState;
  final FeedState feedState;

  const FeedCardDate(this.feedEntryState, this.feedState);

  // TODO there is a problem with accessing plantSettings on multi-plant feeds, will be worst with box cards
  PlantSettings? get plantSettings {
    if (feedState is PlantFeedState) {
      PlantFeedState plantFeedState = feedState as PlantFeedState;
      return plantFeedState.plantSettings;
    } else {
      return feedEntryState.plantSettings;
    }
  }

  @override
  _FeedCardDateState createState() => _FeedCardDateState();
}

class _FeedCardDateState extends State<FeedCardDate> {
  FeedCardDateDisplay display = FeedCardDateDisplay.SINCE_NOW;

  @override
  Widget build(BuildContext context) {
    String format = [renderAbsoluteDate, renderSinceNow, renderSincePhase, renderSinceGermination][display.index]();
    return InkWell(
        onTap: () {
          int index = FeedCardDateDisplay.values.indexOf(display);
          index = (index + 1) % FeedCardDateDisplay.values.length;
          if (FeedCardDateDisplay.values[index] == FeedCardDateDisplay.SINCE_PHASE &&
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
            Text(format, style: TextStyle(color: Colors.black54, fontSize: 15)),
            Text('Change', style: TextStyle(color: Colors.black12)),
          ],
        ));
  }

  String renderAbsoluteDate() {
    String format = AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
    DateFormat f = DateFormat(format);
    return f.format(widget.feedEntryState.date);
  }

  String renderSinceNow() {
    Duration diff = DateTime.now().difference(widget.feedEntryState.date);
    return renderDuration(diff);
  }

  String renderSincePhase() {
    PlantSettings plantSettings = widget.plantSettings!;

    Tuple3<PlantPhases, DateTime, Duration>? phaseData = plantSettings.phaseAt(widget.feedEntryState.date);
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

  String renderSinceGermination() {
    if (widget.plantSettings?.germinationDate == null) {
      return 'Germination date not set.';
    }
    Duration diff = widget.feedEntryState.date.difference(widget.plantSettings!.germinationDate!);
    return 'Germinated ${renderDuration(diff)}';
  }

  // TODO DRY this
  String renderDuration(Duration diff, {suffix = ' ago'}) {
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
    } else {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''}$suffix';
    }
    return format;
  }
}
