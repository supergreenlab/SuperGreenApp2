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
import 'package:super_green_app/pages/feed_entries/feed_life_event/card/feed_life_event_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_nutrient_mix/card/feed_nutrient_mix_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_products/feed_products_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_unknown/feed_unknown_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_page.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

import 'feed_timelapse/card/feed_timelapse_card_page.dart';

class FeedEntriesCardHelpers {
  static Map<
      String,
      Widget Function(Animation animation, FeedState feedState, FeedEntryState state,
          {List<Widget> Function(BuildContext context, FeedEntryState feedEntryState) cardActions})> _cards = {
    'FE_LIGHT': (animation, feedState, state, {cardActions}) =>
        FeedLightCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_MEDIA': (animation, feedState, state, {cardActions}) =>
        FeedMediaCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_MEASURE': (animation, feedState, state, {cardActions}) =>
        FeedMeasureCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_SCHEDULE': (animation, feedState, state, {cardActions}) =>
        FeedScheduleCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_TOPPING': (animation, feedState, state, {cardActions}) =>
        FeedToppingCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_DEFOLIATION': (animation, feedState, state, {cardActions}) =>
        FeedDefoliationCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_FIMMING': (animation, feedState, state, {cardActions}) =>
        FeedFimmingCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_BENDING': (animation, feedState, state, {cardActions}) =>
        FeedBendingCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_TRANSPLANT': (animation, feedState, state, {cardActions}) =>
        FeedTransplantCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_VENTILATION': (animation, feedState, state, {cardActions}) =>
        FeedVentilationCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_WATER': (animation, feedState, state, {cardActions}) =>
        FeedWaterCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_TOWELIE_INFO': (animation, feedState, state, {cardActions}) =>
        FeedTowelieInfoCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_PRODUCTS': (animation, feedState, state, {cardActions}) =>
        FeedProductsCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_LIFE_EVENT': (animation, feedState, state, {cardActions}) =>
        FeedLifeEventCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_NUTRIENT_MIX': (animation, feedState, state, {cardActions}) =>
        FeedNutrientMixCardPage(animation, feedState, state, cardActions: cardActions),
    'FE_TIMELAPSE': (animation, feedState, state, {cardActions}) =>
        FeedTimelapseCardPage(animation, feedState, state, cardActions: cardActions),
  };

  static Widget cardForFeedEntry(Animation animation, FeedState feedState, FeedEntryState state,
      {List<Widget> Function(BuildContext context, FeedEntryState feedEntryState) cardActions}) {
    Widget Function(Animation, FeedState, FeedEntryState,
            {List<Widget> Function(BuildContext context, FeedEntryState feedEntryState) cardActions}) builder =
        _cards[state.type];
    if (builder == null) {
      return FeedUnknownCardPage(animation, feedState, state);
    }
    return builder(animation, feedState, state, cardActions: cardActions);
  }
}
