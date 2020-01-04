import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feeds/box_feed/bloc/box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/ui/feed_page.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';

class BoxFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoxFeedBloc, BoxFeedBlocState>(
      bloc: Provider.of<BoxFeedBloc>(context),
      builder: (BuildContext context, BoxFeedBlocState state) {
        return _renderFeed(context, state);
      },
    );
  }

  Widget _renderFeed(BuildContext context, BoxFeedBlocState state) {
    return BlocProvider(
                  create: (context) => FeedBloc(HomeNavigateToBoxFeedEvent(state.feed, state.box)),
                  child: FeedPage(),
                );
  }
}