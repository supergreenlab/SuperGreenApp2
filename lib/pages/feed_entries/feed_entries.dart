import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/feed_defoliation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/feed_defoliation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/card/feed_topping_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/card/feed_topping_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_page.dart';

class FeedEntriesHelper {
  static Map<String, Widget Function(Feed feed, FeedEntry feedEntry)> _cards = {
    'FE_DEFOLIATION': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedDefoliationCardBloc(feed, feedEntry),
          child: FeedDefoliationCardPage(),
        ),
    'FE_LIGHT': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedLightCardBloc(feed, feedEntry),
          child: FeedLightCardPage(),
        ),
    'FE_MEDIA': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedMediaCardBloc(feed, feedEntry),
          child: FeedMediaCardPage(),
        ),
    'FE_SCHEDULE': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedScheduleCardBloc(feed, feedEntry),
          child: FeedScheduleCardPage(),
        ),
    'FE_TOPPING': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedToppingCardBloc(feed, feedEntry),
          child: FeedToppingCardPage(),
        ),
    'FE_VENTILATION': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedVentilationCardBloc(feed, feedEntry),
          child: FeedVentilationCardPage(),
        ),
    'FE_TOWELIE_INFO': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedTowelieInfoCardBloc(feed, feedEntry),
          child: FeedTowelieInfoCardPage(),
        ),
    'FE_WATER': (feed, feedEntry) => BlocProvider(
          key: Key('{$feedEntry.id}'),
          create: (context) => FeedWaterCardBloc(feed, feedEntry),
          child: FeedWaterCardPage(),
        ),
  };

  static Widget cardForFeedEntry(Feed feed, FeedEntry feedEntry) {
    return _cards[feedEntry.type](feed, feedEntry);
  }
}
