import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/bloc/feed_towelie_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/ui/feed_towelie_info_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/bloc/feed_defoliation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/ui/feed_defoliation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/bloc/feed_light_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/ui/feed_light_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/bloc/feed_media_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/ui/feed_media_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/bloc/feed_schedule_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/ui/feed_schedule_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/card/bloc/feed_topping_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/card/ui/feed_topping_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/bloc/feed_ventilation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/ui/feed_ventilation_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/bloc/feed_water_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/ui/feed_water_card_page.dart';

class FeedEntriesHelper {
  static Map<String, Widget Function(Feed feed, FeedEntry feedEntry)> _cards = {
    'FE_DEFOLIATION': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedDefoliationCardBloc(feed, feedEntry),
          child: FeedDefoliationCardPage(),
        ),
    'FE_LIGHT': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedLightCardBloc(feed, feedEntry),
          child: FeedLightCardPage(),
        ),
    'FE_MEDIA': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedMediaCardBloc(feed, feedEntry),
          child: FeedMediaCardPage(),
        ),
    'FE_SCHEDULE': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedScheduleCardBloc(feed, feedEntry),
          child: FeedScheduleCardPage(),
        ),
    'FE_TOPPING': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedToppingCardBloc(feed, feedEntry),
          child: FeedToppingCardPage(),
        ),
    'FE_VENTILATION': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedVentilationCardBloc(feed, feedEntry),
          child: FeedVentilationCardPage(),
        ),
    'FE_TOWELIE_INFO': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedTowelieInfoCardBloc(feed, feedEntry),
          child: FeedTowelieInfoCardPage(),
        ),
    'FE_WATER': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedWaterCardBloc(feed, feedEntry),
          child: FeedWaterCardPage(),
        ),
  };

  static Widget cardForFeedEntry(Feed feed, FeedEntry feedEntry) {
    return _cards[feedEntry.type](feed, feedEntry);
  }
}
