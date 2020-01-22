import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_entries.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: Provider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateLoaded) {
          return _renderCards(context, state);
        }
        return Text('FeedPage loading', style: TextStyle(color: Colors.white));
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    return ListView.builder(
      itemCount: state.entries.length,
      itemBuilder: (context, i) {
        return FeedEntriesHelper.cardForFeedEntry(state.feed, state.entries[i]);
      });
  }
}
