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
import 'package:super_green_app/pages/feed_entries/feed_care/feed_bending/card/feed_bending_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/card/feed_defoliation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_fimming/card/feed_fimming_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_topping/card/feed_topping_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_transplant/card/feed_transplant_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_products/feed_products_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_page.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_state.dart';

class FeedEntriesHelper {
  static Map<String,
      Widget Function(Animation animation, FeedState feedState, FeedEntryState state)> _cards = {
    'FE_LIGHT': (animation, feedState, state) => FeedLightCardPage(animation, feedState, state),
    'FE_MEDIA': (animation, feedState, state) => FeedMediaCardPage(animation, feedState, state),
    'FE_MEASURE': (animation, feedState, state) => FeedMeasureCardPage(animation, feedState, state),
    'FE_SCHEDULE': (animation, feedState, state) => FeedScheduleCardPage(animation, feedState, state),
    'FE_TOPPING': (animation, feedState, state) => FeedToppingCardPage(animation, feedState, state),
    'FE_DEFOLIATION': (animation, feedState, state) =>
        FeedDefoliationCardPage(animation, feedState, state),
    'FE_FIMMING': (animation, feedState, state) => FeedFimmingCardPage(animation, feedState, state),
    'FE_BENDING': (animation, feedState, state) => FeedBendingCardPage(animation, feedState, state),
    'FE_TRANSPLANT': (animation, feedState, state) =>
        FeedTransplantCardPage(animation, feedState, state),
    'FE_VENTILATION': (animation, feedState, state) =>
        FeedVentilationCardPage(animation, feedState, state),
    'FE_WATER': (animation, feedState, state) => FeedWaterCardPage(animation, feedState, state),
    'FE_TOWELIE_INFO': (animation, feedState, state) =>
        FeedTowelieInfoCardPage(animation, feedState, state),
    'FE_PRODUCTS': (animation, feedState, state) => FeedProductsCardPage(animation, feedState, state),
  };

  static Widget cardForFeedEntry(Animation animation, FeedState feedState, FeedEntryState state) {
    return _cards[state.type](animation, feedState, state);
  }
}
