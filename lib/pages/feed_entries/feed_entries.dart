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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_bending/card/feed_bending_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_bending/card/feed_bending_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/card/feed_defoliation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/card/feed_defoliation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_fimming/card/feed_fimming_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_fimming/card/feed_fimming_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_topping/card/feed_topping_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_topping/card/feed_topping_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_page.dart';

class FeedEntriesHelper {
  static Map<String, Widget Function(Feed feed, FeedEntry feedEntry, bool animate)> _cards = {
    'FE_LIGHT': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedLightCardBloc(feed, feedEntry),
          child: FeedLightCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_MEDIA': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedMediaCardBloc(feed, feedEntry),
          child: FeedMediaCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_SCHEDULE': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedScheduleCardBloc(feed, feedEntry),
          child: FeedScheduleCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_TOPPING': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedToppingCardBloc(feed, feedEntry),
          child: FeedToppingCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_DEFOLIATION': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedDefoliationCardBloc(feed, feedEntry),
          child: FeedDefoliationCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_FIMMING': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedFimmingCardBloc(feed, feedEntry),
          child: FeedFimmingCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_BENDING': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedBendingCardBloc(feed, feedEntry),
          child: FeedBendingCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_VENTILATION': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedVentilationCardBloc(feed, feedEntry),
          child: FeedVentilationCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_TOWELIE_INFO': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedTowelieInfoCardBloc(feed, feedEntry),
          child: FeedTowelieInfoCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
    'FE_WATER': (feed, feedEntry, animate) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedWaterCardBloc(feed, feedEntry),
          child: FeedWaterCardPage(animate, key: Key('{$feedEntry.id}')),
        ),
  };

  static Widget cardForFeedEntry(Feed feed, FeedEntry feedEntry, bool animate) {
    return _cards[feedEntry.type](feed, feedEntry, animate);
  }
}
