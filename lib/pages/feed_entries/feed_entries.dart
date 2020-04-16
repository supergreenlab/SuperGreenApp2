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
import 'package:super_green_app/pages/feed_entries/feed_care/feed_transplant/card/feed_transplant_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_transplant/card/feed_transplant_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_products/feed_products_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_products/feed_products_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_page.dart';

class FeedEntriesHelper {
  static Map<String,
          Widget Function(Feed feed, FeedEntry feedEntry, Animation animation)>
      _cards = {
    'FE_LIGHT': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedLightCardBloc(feed, feedEntry),
          child: FeedLightCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_MEDIA': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedMediaCardBloc(feed, feedEntry),
          child: FeedMediaCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_MEASURE': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedMeasureCardBloc(feed, feedEntry),
          child: FeedMeasureCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_SCHEDULE': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedScheduleCardBloc(feed, feedEntry),
          child: FeedScheduleCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_TOPPING': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedToppingCardBloc(feed, feedEntry),
          child: FeedToppingCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_DEFOLIATION': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedDefoliationCardBloc(feed, feedEntry),
          child:
              FeedDefoliationCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_FIMMING': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedFimmingCardBloc(feed, feedEntry),
          child: FeedFimmingCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_BENDING': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedBendingCardBloc(feed, feedEntry),
          child: FeedBendingCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_TRANSPLANT': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedTransplantCardBloc(feed, feedEntry),
          child: FeedTransplantCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_VENTILATION': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedVentilationCardBloc(feed, feedEntry),
          child:
              FeedVentilationCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_WATER': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedWaterCardBloc(feed, feedEntry),
          child: FeedWaterCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_TOWELIE_INFO': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedTowelieInfoCardBloc(feed, feedEntry),
          child:
              FeedTowelieInfoCardPage(animation, key: Key('{$feedEntry.id}')),
        ),
    'FE_PRODUCTS': (feed, feedEntry, animation) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedProductsBloc(feed, feedEntry),
          child: FeedProductsPage(animation, key: Key('{$feedEntry.id}')),
        ),
  };

  static Widget cardForFeedEntry(
      Feed feed, FeedEntry feedEntry, Animation animation) {
    return _cards[feedEntry.type](feed, feedEntry, animation);
  }
}
