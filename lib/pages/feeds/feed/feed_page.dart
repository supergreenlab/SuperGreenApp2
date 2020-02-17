import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_entries.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';

class FeedPage extends StatelessWidget {
  final Color color;
  final String title;

  const FeedPage(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: BlocProvider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateLoaded) {
          return _renderCards(context, state);
        }
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Loading feed...')]);
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    return Container(
      color: color,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: color,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(state.entries
                  .map((e) => FeedEntriesHelper.cardForFeedEntry(
                      state.feed, e))
                  .toList()))
        ],
      ),
    );
  }
}
