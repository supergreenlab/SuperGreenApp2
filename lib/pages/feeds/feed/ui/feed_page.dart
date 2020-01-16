import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_entries.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: Provider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateLoaded) {
          return _renderCards(context, state);
        }
        return Text('FeedPage loading');
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    return ListView(
      children: state.entries
          .map((e) => FeedEntriesHelper.cardForFeedEntry(state.feed, e))
          .toList(),
    );
  }
}

class FeedEntrie {
}
