import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_light/card/bloc/feed_light_card_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_light/card/ui/feed_light_card_page.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_towelie_info/card/bloc/feed_light_card_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_towelie_info/card/ui/feed_towelie_info_card_page.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_water/card/bloc/feed_water_card_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_water/card/ui/feed_water_card_page.dart';

class FeedEntriesHelper {
  static Map<String, Widget Function(Feed feed, FeedEntry feedEntry)> _cards = {
    'FE_TOWELIE_INFO': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedTowelieInfoCardBloc(feed, feedEntry),
          child: FeedTowelieInfoCardPage(),
        ),
    'FE_LIGHT': (feed, feedEntry) => BlocProvider(
          create: (context) => FeedLightCardBloc(feed, feedEntry),
          child: FeedLightCardPage(),
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
